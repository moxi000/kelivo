import SwiftUI

// MARK: - ReasoningView

/// A collapsible card that shows the model's reasoning/thinking process.
/// Displays a "Thinking..." header with optional duration, and expands
/// to reveal the full reasoning text.
struct ReasoningView: View {
    let reasoningText: String
    let startedAt: Date?
    let finishedAt: Date?

    @State private var isExpanded = false

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerRow
            if isExpanded {
                expandedContent
            }
        }
        .reasoningGlassCard()
        .animation(.easeInOut(duration: 0.25), value: isExpanded)
    }

    // MARK: - Header

    private var headerRow: some View {
        Button {
            withAnimation { isExpanded.toggle() }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "brain")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(String(localized: "thinking"))
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)

                if let duration = formattedDuration {
                    Text(duration)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Expanded Content

    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
                .padding(.horizontal, 12)

            Text(reasoningText)
                .font(.callout)
                .foregroundStyle(.secondary)
                .textSelection(.enabled)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }

    // MARK: - Duration

    private var formattedDuration: String? {
        guard let start = startedAt, let end = finishedAt else { return nil }
        let interval = end.timeIntervalSince(start)
        guard interval > 0 else { return nil }

        if interval < 60 {
            return String(format: "%.1fs", interval)
        } else {
            let minutes = Int(interval) / 60
            let seconds = Int(interval) % 60
            return "\(minutes)m \(seconds)s"
        }
    }
}

// MARK: - Glass Card Modifier

private extension View {
    @ViewBuilder
    func reasoningGlassCard() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.glassEffect(.regular, in: .rect(cornerRadius: 14))
        } else {
            self
                .background(
                    Color.surfaceSecondary,
                    in: RoundedRectangle(cornerRadius: 14)
                )
        }
    }
}
