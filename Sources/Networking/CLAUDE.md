# Networking module rules

- Allowed dependencies: `DomainContracts` only.
- Never import `TasksFeature`, `DesignSystem`, or SwiftUI — this module is UI-free infrastructure.
- Every repository implementation here must conform to a protocol defined in `DomainContracts`, not define its own ad hoc one.
- DTOs live here, next to the repository that decodes them, with a `toDomain()` mapper. Don't let a DTO leak past this module's public API.
- New network calls get a mapping test in `Tests/NetworkingTests` (DTO -> domain) and, where behavior matters, a repository test using a stub `APIClient`. Tests use XCTest here, not Swift Testing.
