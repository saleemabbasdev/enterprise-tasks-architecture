import XCTest
import DomainContracts
import TestSupport
@testable import TasksFeature

@MainActor
final class TasksViewModelTests: XCTestCase {
    func testLoadingUpdatesState() async {
        let repository = TaskRepositoryStub(
            fetchResult: .success([TaskItem(id: "1", title: "Ship app")])
        )
        let viewModel = TasksViewModel(repository: repository, logger: NullLogger())

        await viewModel.load()

        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.state, .loaded)
    }

    func testLoadingFailureSurfacesError() async {
        struct DemoError: Error {}
        let repository = TaskRepositoryStub(fetchResult: .failure(DemoError()))
        let viewModel = TasksViewModel(repository: repository, logger: NullLogger())

        await viewModel.load()

        guard case .failed = viewModel.state else {
            XCTFail("Expected .failed state, got \(viewModel.state)")
            return
        }
    }

    func testSelectingEmitsEvent() {
        let repository = TaskRepositoryStub(fetchResult: .success([]))
        let viewModel = TasksViewModel(repository: repository, logger: NullLogger())
        var receivedEvent: TasksFeatureEvent?
        viewModel.onEvent = { receivedEvent = $0 }

        viewModel.select(TaskItem(id: "7", title: "Emit event"))

        XCTAssertNotNil(receivedEvent)
    }
}
