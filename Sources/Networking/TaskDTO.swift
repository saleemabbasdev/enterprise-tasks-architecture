import Foundation
import DomainContracts

/// Wire-format representation. Differs meaningfully from the domain model
/// (different key names, an Int flag instead of Bool, a raw date string),
/// so a mapper earns its place here as an anti-corruption layer. DTOs
/// never leave this module — only `TaskItem` crosses the public API.
public struct TaskDTO: Codable, Sendable {
    public let taskId: String
    public let taskTitle: String
    public let isDone: Int
    public let createdAt: String

    public init(taskId: String, taskTitle: String, isDone: Int, createdAt: String) {
        self.taskId = taskId
        self.taskTitle = taskTitle
        self.isDone = isDone
        self.createdAt = createdAt
    }
}

extension TaskDTO {
    public func toDomain() throws -> TaskItem {
        TaskItem(
            id: .init(rawValue: taskId),
            title: taskTitle,
            isCompleted: isDone == 1,
            createdAt: try Self.parseDate(createdAt)
        )
    }

    public static func from(_ task: TaskItem) -> TaskDTO {
        TaskDTO(
            taskId: task.id.rawValue,
            taskTitle: task.title,
            isDone: task.isCompleted ? 1 : 0,
            createdAt: ISO8601DateFormatter().string(from: task.createdAt)
        )
    }

    private static func parseDate(_ raw: String) throws -> Date {
        guard let date = ISO8601DateFormatter().date(from: raw) else {
            throw RepositoryError.decoding(message: "Invalid date: \(raw)")
        }
        return date
    }
}
