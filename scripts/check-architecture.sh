#!/usr/bin/env bash
set -euo pipefail

# Minimal architecture fitness function: fails the build if a module
# boundary from the architecture is violated. This is deliberately simple
# (grep, not a real dependency graph tool) so it's easy to read and extend.

fail=0

check_forbidden_import() {
  local dir="$1"
  local forbidden="$2"
  local label="$3"

  if grep -rlE "^import ${forbidden}$" "$dir" --include="*.swift" > /dev/null 2>&1; then
    echo "FAIL: $label"
    grep -rnE "^import ${forbidden}$" "$dir" --include="*.swift"
    fail=1
  fi
}

echo "Checking architecture boundaries..."

# Domain stays framework-free: no SwiftUI, no infrastructure imports.
check_forbidden_import "Sources/DomainContracts" "SwiftUI" \
  "DomainContracts must not import SwiftUI (domain stays presentation-free)"
check_forbidden_import "Sources/DomainContracts" "Networking" \
  "DomainContracts must not import Networking (contracts don't depend on infrastructure)"

# Networking is infrastructure: it must not import the feature or app layer.
check_forbidden_import "Sources/Networking" "TasksFeature" \
  "Networking must not import TasksFeature (infrastructure can't depend upward on features)"
check_forbidden_import "Sources/Networking" "SwiftUI" \
  "Networking must not import SwiftUI (infrastructure stays presentation-free)"

# Features own product behavior; they must not reach into infrastructure
# directly, and must not import another feature module.
check_forbidden_import "Sources/TasksFeature" "Networking" \
  "TasksFeature must not import Networking directly (depend on DomainContracts instead)"

if [ "$fail" -eq 1 ]; then
  echo ""
  echo "Architecture check failed. See violations above."
  exit 1
else
  echo "All architecture boundaries respected."
fi
