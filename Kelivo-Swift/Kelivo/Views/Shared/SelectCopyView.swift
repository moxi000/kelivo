import SwiftUI

// MARK: - SelectCopyView

/// A sheet view that displays message text with full text selection support.
/// Provides "Copy Selected" and "Select All" buttons for easy text extraction
/// from chat messages.
struct SelectCopyView: View {
    let text: String
    @Environment(\.dismiss) private var dismiss
    @State private var isCopied: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                selectableText
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(String(localized: "selectText"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "done")) {
                        dismiss()
                    }
                }

                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        selectAll()
                    } label: {
                        Label(String(localized: "selectAll"), systemImage: "selection.pin.in.out")
                    }

                    Spacer()

                    Button {
                        copyText()
                    } label: {
                        Label(
                            isCopied
                                ? String(localized: "copied")
                                : String(localized: "copy"),
                            systemImage: isCopied ? "checkmark" : "doc.on.doc"
                        )
                    }
                }
            }
        }
    }

    // MARK: - Selectable Text

    private var selectableText: some View {
        Text(text)
            .font(.body)
            .foregroundStyle(.primary)
            .textSelection(.enabled)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Actions

    private func copyText() {
        #if os(iOS)
        UIPasteboard.general.string = text
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        #endif

        withAnimation {
            isCopied = true
        }

        // Reset after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                isCopied = false
            }
        }
    }

    private func selectAll() {
        // On iOS/macOS the native text selection is handled by the system.
        // Copy the full text as a convenience.
        copyText()
    }
}

// MARK: - Preview

#Preview {
    SelectCopyView(
        text: """
        This is a sample message with multiple lines of text.

        It demonstrates the selectable text view where users can select
        and copy portions of the message content.

        Code example:
        let greeting = "Hello, World!"
        print(greeting)
        """
    )
}
