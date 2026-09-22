import SwiftUI

@main
struct EnterpriseTasksApp: App {
    private let container: AppContainer

    init() {
        container = AppContainer.live()
    }

    var body: some Scene {
        WindowGroup {
            RootView(container: container)
        }
    }
}
