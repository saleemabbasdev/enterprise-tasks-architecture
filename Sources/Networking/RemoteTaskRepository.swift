import Foundation
import DomainContracts

/// Infrastructure adapter. Implements the `TaskRepository` contract owned
/// by the feature layer, using `APIClient` + `TaskDTO` under the hood.
public final class RemoteTaskRepository: TaskRepository {
    private let apiClient: any APIClient
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    public init(apiClient: any APIClient) {
        self.apiClient = apiClient
    }

    public func fetchTasks() async throws -> [TaskItem] {
        let data = try await apiClient.get("tasks")
        let dtos = try decoder.decode([TaskDTO].self, from: data)
        return try dtos.map { try $0.toDomain() }
    }

    public func create(_ task: TaskItem) async throws {
        let dto = TaskDTO.from(task)
        let body = try encoder.encode(dto)
        _ = try await apiClient.post("tasks", body: body)
    }

    public func complete(id: TaskItem.ID) async throws {
        _ = try await apiClient.post("tasks/\(id.rawValue)/complete", body: Data())
    }
}
