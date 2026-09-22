/// Stable capability contract. Features depend on this; infrastructure
/// (Networking, Persistence, ...) supplies the concrete implementation.
/// This is the seam the Composition Root injects across.
public protocol TaskRepository: Sendable {
    func fetchTasks() async throws -> [TaskItem]
    func create(_ task: TaskItem) async throws
    func complete(id: TaskItem.ID) async throws
}
