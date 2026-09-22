import XCTest
import Foundation
import DomainContracts
@testable import Networking

final class RemoteTaskRepositoryTests: XCTestCase {
    func testFetchTasksDecodesAndMaps() async throws {
        let json = """
        [{"taskId":"1","taskTitle":"Ship","isDone":0,"createdAt":"2026-01-01T00:00:00Z"}]
        """.data(using: .utf8)!

        let apiClient = StubAPIClient(result: .success(json))
        let repository = RemoteTaskRepository(apiClient: apiClient)

        let tasks = try await repository.fetchTasks()

        XCTAssertEqual(tasks.count, 1)
        XCTAssertEqual(tasks.first?.title, "Ship")
    }
}

/// Kept local to this test target rather than in TestSupport, since only
/// Networking's own tests need to fake the wire layer.
private final class StubAPIClient: APIClient, @unchecked Sendable {
    enum Result {
        case success(Data)
        case failure(Error)
    }

    var result: Result

    init(result: Result) { self.result = result }

    func get(_ path: String) async throws -> Data {
        switch result {
        case .success(let data): return data
        case .failure(let error): throw error
        }
    }

    func post(_ path: String, body: Data) async throws -> Data {
        switch result {
        case .success(let data): return data
        case .failure(let error): throw error
        }
    }
}
