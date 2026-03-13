import SwiftUI

// MARK: - StreamingIndicator

/// Animated indicator shown while the assistant response is streaming.
/// Displays partial content if available, otherwise shows an animated
/// "Thinking..." pulse.
struct StreamingIndicator: View {
    let partialContent: String

    @State private var animationPhase: CGFloat = 0

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            content
            Spacer(minLength: 48)
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if partialContent.isEmpty {
            thinkingPulse
        } else {
            partialContentView
        }
    }

    // MARK: - Thinking Pulse

    private var thinkingPulse: some View {
        HStack(spacing: 6) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.accentPrimary)
                    .frame(width: 8, height: 8)
                    .opacity(dotOpacity(for: index))
                    .animation(
                        .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: animationPhase
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .streamingGlassCard()
        .onAppear {
            animationPhase = 1
        }
    }

    private func dotOpacity(for index: Int) -> CGFloat {
        let base = 0.3
        let peak = 1.0
        // Simple cycling opacity based on animation phase
        return animationPhase > 0 ? peak : base
    }

    // MARK: - Partial Content

    private var partialContentView: some View {
        HStack(alignment: .bottom, spacing: 4) {
            Text(partialContent)
                .font(.body)
                .textSelection(.enabled)

            // Blinking cursor
            Rectangle()
                .fill(Color.primary)
                .frame(width: 2, height: 16)
                .opacity(animationPhase > 0.5 ? 1 : 0)
                .animation(
                    .easeInOut(duration: 0.5).repeatForever(),
                    value: animationPhase
                )
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .streamingGlassCard()
        .onAppear {
            animationPhase = 1
        }
    }
}

// MARK: - Glass Card Modifier

private extension View {
    @ViewBuilder
    func streamingGlassCard() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.glassEffect(.regular, in: .rect(cornerRadius: 18))
        } else {
            self.background(
                Color.chatAssistantBubble,
                in: RoundedRectangle(cornerRadius: 18)
            )
        }
    }
}
