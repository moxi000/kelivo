import SwiftUI

// MARK: - MessageBubble

/// Displays a single chat message with Liquid Glass styling.
/// User messages are tinted and aligned right; assistant messages use clear glass and align left.
struct MessageBubble: View {
    @Environment(ChatViewModel.self) private var chatVM
    let message: ChatMessage

    @State private var showTimestamp = false
    @State private var isCopied = false

    // MARK: Body

    var body: some View {
        let isUser = message.role == "user"

        HStack(alignment: .top, spacing: 0) {
            if isUser { Spacer(minLength: 48) }

            VStack(alignment: isUser ? .trailing : .leading, spacing: 6) {
                // Model name badge
                if !isUser, let modelId = message.modelId, !modelId.isEmpty {
                    modelBadge(modelId)
                }

                // Reasoning section (collapsible)
                if let reasoning = message.reasoningText, !reasoning.isEmpty {
                    ReasoningView(
                        reasoningText: reasoning,
                        startedAt: message.reasoningStartAt,
                        finishedAt: message.reasoningFinishedAt
                    )
                }

                // Message content
                bubbleContent(isUser: isUser)

                // Timestamp
                if showTimestamp {
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }

            if !isUser { Spacer(minLength: 48) }
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                showTimestamp.toggle()
            }
        }
        .contextMenu { contextMenuItems }
    }

    // MARK: - Bubble Content

    @ViewBuilder
    private func bubbleContent(isUser: Bool) -> some View {
        Group {
            if isUser {
                Text(message.content)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .textSelection(.enabled)
            } else {
                MarkdownRenderer(content: message.content)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(maxWidth: isUser ? nil : .infinity, alignment: isUser ? .trailing : .leading)
        .bubbleGlassBackground(isUser: isUser)
    }

    // MARK: - Model Badge

    private func modelBadge(_ modelId: String) -> some View {
        Text(modelId)
            .font(.caption2)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .glassCard(cornerRadius: 8)
    }

    // MARK: - Context Menu

    @ViewBuilder
    private var contextMenuItems: some View {
        Button {
            UIPasteboard.copyText(message.content)
            isCopied = true
        } label: {
            Label(String(localized: "copy"), systemImage: "doc.on.doc")
        }

        if message.role == "user" {
            Button {
                // TODO: Present edit UI
            } label: {
                Label(String(localized: "edit"), systemImage: "pencil")
            }
        }

        if message.role == "assistant" {
            Button {
                Task { await chatVM.regenerateMessage(message) }
            } label: {
                Label(String(localized: "regenerate"), systemImage: "arrow.clockwise")
            }

            Button {
                Task { await chatVM.translateMessage(message) }
            } label: {
                Label(String(localized: "translate"), systemImage: "translate")
            }
        }

        Divider()

        Button(role: .destructive) {
            chatVM.deleteMessage(message)
        } label: {
            Label(String(localized: "delete"), systemImage: "trash")
        }
    }
}

// MARK: - Bubble Glass Background Modifier

private extension View {
    @ViewBuilder
    func bubbleGlassBackground(isUser: Bool) -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.glassEffect(
                isUser ? .regular.tint(.accentColor) : .regular,
                in: .rect(cornerRadius: 18)
            )
        } else {
            self.background(
                isUser ? Color.chatUserBubble : Color.chatAssistantBubble,
                in: RoundedRectangle(cornerRadius: 18)
            )
        }
    }
}

// MARK: - Cross-Platform Pasteboard

private enum UIPasteboard {
    static func copyText(_ text: String) {
        #if os(iOS)
        _UIKit_UIPasteboard.general.string = text
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        #endif
    }
}

#if os(iOS)
import UIKit
private typealias _UIKit_UIPasteboard = UIKit.UIPasteboard
#endif
