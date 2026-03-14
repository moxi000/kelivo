import SwiftUI

// MARK: - MessageEditView

/// Allows the user to edit an existing message before resending it.
struct MessageEditView: View {
    let message: ChatMessage
    let onSave: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var editedContent: String

    init(message: ChatMessage, onSave: @escaping (String) -> Void) {
        self.message = message
        self.onSave = onSave
        _editedContent = State(initialValue: message.content)
    }

    // MARK: Body

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TextEditor(text: $editedContent)
                    .font(.body)
                    .padding()
                    .scrollContentBackground(.hidden)
            }
            .background(Color.chatBackground)
            .navigationTitle(String(localized: "editMessage"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar { toolbarContent }
        }
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button(String(localized: "cancel")) {
                dismiss()
            }
        }

        ToolbarItem(placement: .confirmationAction) {
            Button(String(localized: "save")) {
                onSave(editedContent)
                dismiss()
            }
            .disabled(editedContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
}

// MARK: - Preview

#Preview {
    MessageEditView(
        message: ChatMessage(
            role: "user",
            content: "Hello, world!",
            conversationId: "preview"
        )
    ) { newContent in
        print("Saved: \(newContent)")
    }
}
