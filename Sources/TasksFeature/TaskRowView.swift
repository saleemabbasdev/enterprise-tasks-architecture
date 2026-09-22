import SwiftUI
import DesignSystem
import DomainContracts

struct TaskRowView: View {
    let task: TaskItem
    let onComplete: () -> Void
    let onSelect: () -> Void

    var body: some View {
        HStack {
            Button(action: onComplete) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(task.isCompleted ? DSColor.success : DSColor.secondaryText)
            }
            .buttonStyle(.plain)

            Text(task.title)
                .strikethrough(task.isCompleted)
                .foregroundStyle(task.isCompleted ? DSColor.secondaryText : .primary)

            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onSelect)
        .padding(.vertical, DSSpacing.xs)
    }
}
