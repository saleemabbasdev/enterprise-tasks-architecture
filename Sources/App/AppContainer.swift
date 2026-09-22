import Foundation
import DomainContracts
import Networking
import TasksFeature

/// The Composition Root. This is the one place in the app allowed to know
/// about concrete infrastructure (URLSessionAPIClient, RemoteTaskRepository,
/// OSLogger). Everything downstream only sees protocols from DomainContracts.
struct AppContainer {
    let taskRepository: any TaskRepository
    let logger: any Logging
    let analytics: any AnalyticsTracking
    let coordinator: AppCoordinator

    static func live() -> Self {
        let logger = OSLogger()
        let apiClient = URLSessionAPIClient(
            configuration: .production,
            logger: logger
        )
        let taskRepository = RemoteTaskRepository(apiClient: apiClient)

        return Self(
            taskRepository: taskRepository,
            logger: logger,
            analytics: NoOpAnalytics(),
            coordinator: AppCoordinator()
        )
    }

    @MainActor
    func makeTasksViewModel() -> TasksViewModel {
        let viewModel = TasksViewModel(repository: taskRepository, logger: logger)
        viewModel.onEvent = { [coordinator] event in
            coordinator.handle(event)
        }
        return viewModel
    }
}

private struct NoOpAnalytics: AnalyticsTracking {
    func track(_ event: String, properties: [String: String]) {}
}
