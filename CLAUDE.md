# Root architecture rules

This repository demonstrates a modular SwiftUI architecture. AI agents and
contributors working anywhere in this repo should follow these global rules.

## Dependency direction (enforced by SPM + scripts/check-architecture.sh)

    DomainContracts -> Networking -----\
    DomainContracts -> DesignSystem -> TasksFeature -> App

- `DomainContracts` has no dependencies and imports no frameworks beyond Foundation.
- `Networking` depends only on `DomainContracts`.
- `DesignSystem` has no dependencies and only imports SwiftUI.
- `TasksFeature` depends only on `DomainContracts` and `DesignSystem` — never on `Networking` directly.
- `App` is the only target allowed to import `Networking` and `TasksFeature` together; it is the Composition Root.

## Concurrency

- Presentation state lives in `@MainActor @Observable` view models.
- Repositories and API clients are `Sendable`.
- Prefer structured concurrency (`async let`, `TaskGroup`) over detached tasks.

## Testing

- Use XCTest for new logic (this project targets Xcode 15.4/Swift 5.10 compatibility; switch to Swift Testing once you move to Xcode 16+).
- Prefer small stubs in `TestSupport` over mocking frameworks.

## Forbidden

- Circular dependencies between targets.
- Feature-to-feature imports (there's one feature here, but a second one must not import `TasksFeature`).
- A new protocol for every pure helper, formatter, or mapper — protocols belong at infrastructure boundaries and test seams, not everywhere.
