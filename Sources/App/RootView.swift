import SwiftUI
import TasksFeature

@MainActor
struct RootView: View {
    let container: AppContainer
    @State private var tasksViewModel: TasksViewModel

    init(container: AppContainer) {
        self.container = container
        _tasksViewModel = State(wrappedValue: container.makeTasksViewModel())
    }

    var body: some View {
        NavigationStack(
            path: Binding(
                get: { container.coordinator.path },
                set: { container.coordinator.path = $0 }
            )
        ) {
            TasksView(viewModel: tasksViewModel)
                .navigationTitle("Tasks")
                .navigationDestination(for: AppCoordinator.Route.self) { route in
                    switch route {
                    case .taskDetails(let id):
                        Text("Task \(id)")
                    case .settings:
                        Text("Settings")
                    }
                }
        }
    }
}
