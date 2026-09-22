# TasksFeature module rules

- Allowed dependencies: `DomainContracts`, `DesignSystem`. Nothing else.
- Never import `Networking` — talk to `any TaskRepository` only.
- Never import another feature module.
- Navigation is not this module's job: emit a `TasksFeatureEvent`, don't push a route or reach for a NavigationPath directly.
- New view models are `@MainActor @Observable` and take their dependencies through `init`.
- Every new view model gets an XCTest suite in `Tests/TasksFeatureTests`, using `TaskRepositoryStub` from `TestSupport` — not a mocking framework.
