import Foundation

/// Domain model. Named `TaskItem` (not `Task`) to avoid colliding with
/// Swift's structured-concurrency `Task` type — a real collision you hit
/// the moment you model "tasks" in a modern Swift codebase.
public struct TaskItem: Identifiable, Hashable, Sendable {
    public let id: ID
    public var title: String
    public var isCompleted: Bool
    public var createdAt: Date

    public init(id: ID, title: String, isCompleted: Bool = false, createdAt: Date = .init()) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}

extension TaskItem {
    public struct ID: Hashable, Sendable, RawRepresentable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
    }
}

extension TaskItem.ID: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}
