import DomainContracts

/// Small deterministic stub — preferred over a mocking framework so tests
/// stay easy to read and reason about.
public final class TaskRepositoryStub: TaskRepository, @unchecked Sendable {
    public enum FetchResult {
        case success([TaskItem])
        case failure(Error)
    }

    public var fetchResult: FetchResult
    public private(set) var createdTasks: [TaskItem] = []
    public private(set) var completedIDs: [TaskItem.ID] = []

    public init(fetchResult: FetchResult) {
        self.fetchResult = fetchResult
    }

    public func fetchTasks() async throws -> [TaskItem] {
        switch fetchResult {
        case .success(let tasks): return tasks
        case .failure(let error): throw error
        }
    }

    public func create(_ task: TaskItem) async throws {
        createdTasks.append(task)
    }

    public func complete(id: TaskItem.ID) async throws {
        completedIDs.append(id)
    }
}
