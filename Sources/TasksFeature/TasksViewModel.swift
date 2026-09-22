import Foundation
import Observation
import DomainContracts

@MainActor
@Observable
public final class TasksViewModel {
    public private(set) var state: TasksViewState = .idle
    public private(set) var tasks: [TaskItem] = []

    /// Not @Sendable on purpose: this view model is @MainActor-isolated,
    /// so the closure only ever crosses actor boundaries the same way
    /// every other stored property here does.
    public var onEvent: ((TasksFeatureEvent) -> Void)?

    private let repository: any TaskRepository
    private let logger: any Logging

    public init(repository: any TaskRepository, logger: any Logging) {
        self.repository = repository
        self.logger = logger
    }

    public func load() async {
        state = .loading
        do {
            tasks = try await repository.fetchTasks()
            state = .loaded
        } catch is CancellationError {
            return
        } catch {
            logger.error(error, context: "TasksViewModel.load")
            state = .failed(error.localizedDescription)
        }
    }

    public func addTask(title: String) async {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newTask = TaskItem(id: .init(rawValue: UUID().uuidString), title: title)
        do {
            try await repository.create(newTask)
            await load()
        } catch {
            logger.error(error, context: "TasksViewModel.addTask")
            state = .failed(error.localizedDescription)
        }
    }

    public func complete(_ task: TaskItem) async {
        do {
            try await repository.complete(id: task.id)
            await load()
        } catch {
            logger.error(error, context: "TasksViewModel.complete")
            state = .failed(error.localizedDescription)
        }
    }

    /// Presentation intent, not navigation. The View asked "the user
    /// tapped this row"; deciding what that means is the coordinator's job.
    public func select(_ task: TaskItem) {
        onEvent?(.taskSelected(id: task.id.rawValue))
    }
}
