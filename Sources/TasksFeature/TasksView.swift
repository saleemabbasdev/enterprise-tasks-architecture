import SwiftUI
import DesignSystem
import DomainContracts

@MainActor
public struct TasksView: View {
    @Bindable var viewModel: TasksViewModel
    @State private var newTaskTitle = ""

    public init(viewModel: TasksViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: DSSpacing.md) {
            HStack {
                TextField("New task", text: $newTaskTitle)
                    .textFieldStyle(.roundedBorder)
                Button("Add") {
                    let title = newTaskTitle
                    newTaskTitle = ""
                    Task { await viewModel.addTask(title: title) }
                }
            }
            .padding(.horizontal, DSSpacing.md)

            content
        }
        .padding(.top, DSSpacing.md)
        .task { await viewModel.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .frame(maxHeight: .infinity)
        case .failed(let message):
            VStack(spacing: DSSpacing.sm) {
                Text("Something went wrong")
                    .font(DSFont.title)
                Text(message)
                    .font(DSFont.caption)
                    .foregroundStyle(DSColor.secondaryText)
                Button("Retry") { Task { await viewModel.load() } }
                    .buttonStyle(.primary)
            }
            .frame(maxHeight: .infinity)
        case .loaded:
            List(viewModel.tasks) { task in
                TaskRowView(task: task) {
                    Task { await viewModel.complete(task) }
                } onSelect: {
                    viewModel.select(task)
                }
            }
            .listStyle(.plain)
        }
    }
}
