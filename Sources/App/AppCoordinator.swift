import Observation
import TasksFeature

@MainActor
@Observable
final class AppCoordinator {
    enum Route: Hashable {
        case taskDetails(id: String)
        case settings
    }

    var path: [Route] = []

    /// Features emit semantic events (see TasksFeatureEvent); only the
    /// coordinator decides how those map to routes. This is what keeps
    /// TasksFeature ignorant of navigation and free of feature-to-feature imports.
    func handle(_ event: TasksFeatureEvent) {
        switch event {
        case .taskSelected(let id):
            path.append(.taskDetails(id: id))
        case .settingsRequested:
            path.append(.settings)
        }
    }
}
