#if os(macOS)
import SwiftUI
import AppKit

// MARK: - MessageContextMenu

/// Right-click context menu for chat messages on macOS.
/// Provides copy, edit, delete, resend, select text, and export actions.
struct MessageContextMenu: View {
    let message: ChatMessage
    let onCopy: () -> Void
    let onEdit: (() -> Void)?
    let onDelete: () -> Void
    let onResend: (() -> Void)?
    let onSelectText: (() -> Void)?
    let onExport: (() -> Void)?

    init(
        message: ChatMessage,
        onCopy: @escaping () -> Void,
        onEdit: (() -> Void)? = nil,
        onDelete: @escaping () -> Void,
        onResend: (() -> Void)? = nil,
        onSelectText: (() -> Void)? = nil,
        onExport: (() -> Void)? = nil
    ) {
        self.message = message
        self.onCopy = onCopy
        self.onEdit = onEdit
        self.onDelete = onDelete
        self.onResend = onResend
        self.onSelectText = onSelectText
        self.onExport = onExport
    }

    var body: some View {
        Group {
            Button {
                onCopy()
            } label: {
                Label(String(localized: "copy"), systemImage: "doc.on.doc")
            }

            if let onSelectText {
                Button {
                    onSelectText()
                } label: {
                    Label(String(localized: "selectText"), systemImage: "text.cursor")
                }
            }

            Divider()

            if message.role == "user", let onEdit {
                Button {
                    onEdit()
                } label: {
                    Label(String(localized: "edit"), systemImage: "pencil")
                }
            }

            if message.role == "assistant", let onResend {
                Button {
                    onResend()
                } label: {
                    Label(String(localized: "regenerate"), systemImage: "arrow.clockwise")
                }
            }

            if let onExport {
                Button {
                    onExport()
                } label: {
                    Label(String(localized: "exportMessage"), systemImage: "square.and.arrow.up")
                }
            }

            Divider()

            Button(role: .destructive) {
                onDelete()
            } label: {
                Label(String(localized: "delete"), systemImage: "trash")
            }
        }
    }
}

// MARK: - ConversationContextMenu

/// Right-click context menu for conversation items in the sidebar on macOS.
/// Provides pin, rename, delete, and export actions.
struct ConversationContextMenu: View {
    let conversation: Conversation
    let onPin: () -> Void
    let onRename: () -> Void
    let onDelete: () -> Void
    let onExport: (() -> Void)?

    init(
        conversation: Conversation,
        onPin: @escaping () -> Void,
        onRename: @escaping () -> Void,
        onDelete: @escaping () -> Void,
        onExport: (() -> Void)? = nil
    ) {
        self.conversation = conversation
        self.onPin = onPin
        self.onRename = onRename
        self.onDelete = onDelete
        self.onExport = onExport
    }

    var body: some View {
        Group {
            Button {
                onRename()
            } label: {
                Label(String(localized: "rename"), systemImage: "pencil")
            }

            Button {
                onPin()
            } label: {
                Label(
                    conversation.isPinned
                        ? String(localized: "unpin")
                        : String(localized: "pin"),
                    systemImage: conversation.isPinned ? "pin.slash" : "pin"
                )
            }

            if let onExport {
                Divider()

                Button {
                    onExport()
                } label: {
                    Label(String(localized: "exportConversation"), systemImage: "square.and.arrow.up")
                }
            }

            Divider()

            Button(role: .destructive) {
                onDelete()
            } label: {
                Label(String(localized: "delete"), systemImage: "trash")
            }
        }
    }
}

// MARK: - ContextMenuBuilder

/// Generic context menu builder that composes multiple menu item groups
/// into a single context menu. Useful for building dynamic context menus
/// where sections vary based on context.
struct ContextMenuBuilder<Content: View>: ViewModifier {
    @ViewBuilder let menuContent: () -> Content

    func body(content: Content2) -> some View {
        content.contextMenu { menuContent() }
    }

    typealias Content2 = SwiftUI.ModifiedContent<Never, Never>.Never
}

extension ContextMenuBuilder {
    typealias Content2 = Never
}

extension View {
    /// Applies a context menu built from the provided content closure.
    func macContextMenu<MenuContent: View>(
        @ViewBuilder _ menuContent: @escaping () -> MenuContent
    ) -> some View {
        self.contextMenu { menuContent() }
    }
}

// MARK: - Preview

#Preview("Message Context Menu") {
    Text("Right-click me")
        .padding(40)
        .contextMenu {
            MessageContextMenu(
                message: ChatMessage(
                    role: "assistant",
                    content: "Hello, world!",
                    conversationId: "preview"
                ),
                onCopy: {},
                onDelete: {},
                onResend: {},
                onSelectText: {},
                onExport: {}
            )
        }
}
#endif
