import SwiftUI
import SwiftData

// MARK: - ContextManagementView

/// Manages which messages are included in the conversation context window.
/// Shows token count estimates and allows setting a truncation point.
struct ContextManagementView: View {
    let conversation: Conversation

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var messages: [ChatMessage] = []
    @State private var excludedMessageIds: Set<String> = []
    @State private var truncationIndex: Int = -1

    // MARK: Body

    var body: some View {
        NavigationStack {
            List {
                tokenSummarySection
                messagesSection
            }
            .navigationTitle(String(localized: "contextManagement"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar { toolbarContent }
            .onAppear { loadMessages() }
        }
    }

    // MARK: - Token Summary

    private var tokenSummarySection: some View {
        Section {
            HStack {
                Label(
                    String(localized: "totalMessages"),
                    systemImage: "message"
                )
                Spacer()
                Text("\(includedMessages.count) / \(messages.count)")
                    .foregroundStyle(.secondary)
            }

            HStack {
                Label(
                    String(localized: "estimatedTokens"),
                    systemImage: "number.circle"
                )
                Spacer()
                Text("\(estimatedTotalTokens)")
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }

            if truncationIndex >= 0 {
                HStack {
                    Label(
                        String(localized: "truncationPoint"),
                        systemImage: "scissors"
                    )
                    Spacer()
                    Button(String(localized: "clearTruncation")) {
                        truncationIndex = -1
                    }
                    .font(.caption)
                }
            }
        } header: {
            Text(String(localized: "contextSummary"))
        }
    }

    // MARK: - Messages Section

    private var messagesSection: some View {
        Section {
            ForEach(Array(messages.enumerated()), id: \.element.id) {
                index,
                message in
                messageRow(message, index: index)
            }
        } header: {
            Text(String(localized: "messagesInContext"))
        }
    }

    private func messageRow(_ message: ChatMessage, index: Int) -> some View {
        HStack(spacing: 12) {
            // Include/exclude toggle
            Button {
                toggleMessage(message)
            } label: {
                Image(
                    systemName: isMessageIncluded(message)
                        ? "checkmark.circle.fill" : "circle"
                )
                .foregroundStyle(
                    isMessageIncluded(message)
                        ? Color.accentPrimary : .secondary
                )
                .font(.title3)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                // Role label
                Text(message.role.capitalized)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        message.role == "user" ? Color.accentPrimary : .secondary
                    )

                // Content preview
                Text(message.content)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundStyle(.primary)
            }

            Spacer()

            // Token estimate
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(estimateTokens(for: message.content))")
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
                Text(String(localized: "tokens"))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 2)
        .opacity(isTruncated(index: index) ? 0.4 : 1.0)
        .swipeActions(edge: .trailing) {
            Button {
                truncationIndex = index
            } label: {
                Label(
                    String(localized: "truncateHere"),
                    systemImage: "scissors"
                )
            }
            .tint(.orange)
        }
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button(String(localized: "done")) {
                dismiss()
            }
        }
    }

    // MARK: - Helpers

    private var includedMessages: [ChatMessage] {
        messages.enumerated().compactMap { index, message in
            guard !excludedMessageIds.contains(message.id) else { return nil }
            guard !isTruncated(index: index) else { return nil }
            return message
        }
    }

    private var estimatedTotalTokens: Int {
        includedMessages.reduce(0) { $0 + estimateTokens(for: $1.content) }
    }

    private func isMessageIncluded(_ message: ChatMessage) -> Bool {
        !excludedMessageIds.contains(message.id)
    }

    private func isTruncated(index: Int) -> Bool {
        guard truncationIndex >= 0 else { return false }
        return index < truncationIndex
    }

    private func toggleMessage(_ message: ChatMessage) {
        if excludedMessageIds.contains(message.id) {
            excludedMessageIds.remove(message.id)
        } else {
            excludedMessageIds.insert(message.id)
        }
    }

    /// Rough token estimate: ~4 characters per token for English text.
    private func estimateTokens(for text: String) -> Int {
        max(1, text.count / 4)
    }

    private func loadMessages() {
        let conversationId = conversation.id
        let descriptor = FetchDescriptor<ChatMessage>(
            predicate: #Predicate { $0.conversationId == conversationId },
            sortBy: [SortDescriptor(\.timestamp)]
        )
        messages = (try? modelContext.fetch(descriptor)) ?? []
        truncationIndex = conversation.truncateIndex
    }
}

// MARK: - Preview

#Preview {
    ContextManagementView(
        conversation: Conversation(title: "Preview Chat")
    )
    .modelContainer(for: [Conversation.self, ChatMessage.self], inMemory: true)
}
