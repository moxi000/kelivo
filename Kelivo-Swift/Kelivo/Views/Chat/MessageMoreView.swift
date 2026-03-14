import SwiftUI

// MARK: - Message Action

/// Actions available in the message-more menu.
enum MessageMoreAction: String, CaseIterable {
    case selectCopy
    case renderWebView
    case edit
    case share
    case fork
    case delete
}

// MARK: - MessageMoreView

/// Displays a list of actions the user can perform on a chat message.
/// On iOS this is presented as a sheet; on macOS it can be used in a popover or menu.
/// Corresponds to Flutter: `lib/features/chat/widgets/message_more_sheet.dart`
struct MessageMoreView: View {
    @Environment(\.dismiss) private var dismiss

    let message: ChatMessage

    /// Called when the user selects an action.
    var onAction: ((MessageMoreAction) -> Void)?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    actionRow(
                        icon: "text.viewfinder",
                        label: String(localized: "Select & Copy"),
                        action: .selectCopy
                    )

                    actionRow(
                        icon: "doc.richtext",
                        label: String(localized: "Render in WebView"),
                        action: .renderWebView
                    )

                    if message.role != "user" {
                        actionRow(
                            icon: "pencil",
                            label: String(localized: "Edit"),
                            action: .edit
                        )
                    }

                    actionRow(
                        icon: "square.and.arrow.up",
                        label: String(localized: "Share"),
                        action: .share
                    )

                    actionRow(
                        icon: "arrow.triangle.branch",
                        label: String(localized: "Create Branch"),
                        action: .fork
                    )
                }

                Section {
                    Button(role: .destructive) {
                        dismiss()
                        onAction?(.delete)
                    } label: {
                        Label(String(localized: "Delete"), systemImage: "trash")
                    }
                }
            }
            .navigationTitle(String(localized: "Message Actions"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Close")) { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }

    // MARK: - Action Row

    private func actionRow(icon: String, label: String, action: MessageMoreAction) -> some View {
        Button {
            dismiss()
            onAction?(action)
        } label: {
            Label(label, systemImage: icon)
        }
    }
}

#Preview {
    MessageMoreView(
        message: ChatMessage(
            role: "assistant",
            content: "Hello, this is a test message.",
            conversationId: "preview-conv-id"
        ),
        onAction: { action in
            print("Selected: \(action)")
        }
    )
}
