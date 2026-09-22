import XCTest
@testable import DomainContracts

final class TaskItemTests: XCTestCase {
    func testIdentityByID() {
        let a = TaskItem(id: "1", title: "Ship app")
        let b = TaskItem(id: "1", title: "Different title")
        XCTAssertEqual(a.id, b.id)
    }

    func testDefaultsToIncomplete() {
        let task = TaskItem(id: "1", title: "Ship app")
        XCTAssertFalse(task.isCompleted)
    }
}
