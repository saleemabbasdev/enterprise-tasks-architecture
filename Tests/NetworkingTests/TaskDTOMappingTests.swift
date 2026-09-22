import XCTest
import DomainContracts
@testable import Networking

final class TaskDTOMappingTests: XCTestCase {
    func testMapsCompletionFlag() throws {
        let dto = TaskDTO(
            taskId: "42",
            taskTitle: "Write tests",
            isDone: 1,
            createdAt: "2026-01-01T00:00:00Z"
        )

        let task = try dto.toDomain()

        XCTAssertEqual(task.id.rawValue, "42")
        XCTAssertTrue(task.isCompleted)
    }

    func testInvalidDateThrows() {
        let dto = TaskDTO(taskId: "1", taskTitle: "x", isDone: 0, createdAt: "not-a-date")
        XCTAssertThrowsError(try dto.toDomain()) { error in
            XCTAssertTrue(error is RepositoryError)
        }
    }
}
