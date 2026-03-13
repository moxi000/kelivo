import SwiftUI

// MARK: - ConversationRow

/// A single row in the conversation list showing the title,
/// last message preview, timestamp, and pin indicator.
struct ConversationRow: View {
    let conversation: Conversation

    var body: some View {
        HStack(spacing: 12) {
            // Assistant avatar or default icon
            avatarView

            // Title and preview
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(conversation.title)
                        .font(.body.weight(.medium))
                        .lineLimit(1)
                        .foregroundStyle(.primary)

                    Spacer()

                    if conversation.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                    }
                }

                HStack {
                    if let summary = conversation.summary, !summary.isEmpty {
                        Text(summary)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    } else {
                        Text(String(localized: "noMessages"))
                            .font(.callout)
                            .foregroundStyle(.tertiary)
                            .lineLimit(1)
                    }

                    Spacer()

                    Text(conversation.updatedAt.relativeFormatted())
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }

    // MARK: - Avatar

    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(Color.accentPrimary.opacity(0.15))
                .frame(width: 40, height: 40)

            Image(systemName: "bubble.left.fill")
                .font(.system(size: 16))
                .foregroundStyle(Color.accentPrimary)
        }
    }
}
