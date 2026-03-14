import SwiftUI

// MARK: - ScrollNavigationButtons

/// Floating buttons for scrolling to top/bottom of the chat,
/// with an optional unread message count badge.
struct ScrollNavigationButtons: View {
    let showScrollToTop: Bool
    let showScrollToBottom: Bool
    var unreadCount: Int = 0
    var onScrollToTop: (() -> Void)?
    var onScrollToBottom: (() -> Void)?

    // MARK: Body

    var body: some View {
        VStack(spacing: 10) {
            if showScrollToTop {
                scrollButton(
                    icon: "chevron.up",
                    label: String(localized: "scrollToTop"),
                    action: { onScrollToTop?() }
                )
                .transition(.opacity.combined(with: .scale))
            }

            if showScrollToBottom {
                ZStack(alignment: .topTrailing) {
                    scrollButton(
                        icon: "chevron.down",
                        label: String(localized: "scrollToBottom"),
                        action: { onScrollToBottom?() }
                    )

                    // Unread badge
                    if unreadCount > 0 {
                        unreadBadge
                    }
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showScrollToTop)
        .animation(.easeInOut(duration: 0.2), value: showScrollToBottom)
    }

    // MARK: - Scroll Button

    private func scrollButton(
        icon: String,
        label: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .frame(width: 36, height: 36)
                .scrollButtonGlassBackground()
        }
        .buttonStyle(.plain)
        .help(label)
        .accessibilityLabel(label)
    }

    // MARK: - Unread Badge

    private var unreadBadge: some View {
        Text("\(min(unreadCount, 99))")
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.horizontal, 5)
            .padding(.vertical, 1)
            .background(Color.red, in: Capsule())
            .offset(x: 6, y: -6)
            .accessibilityLabel(
                String(localized: "\(unreadCount) unreadMessages")
            )
    }
}

// MARK: - Glass Background

private extension View {
    @ViewBuilder
    func scrollButtonGlassBackground() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.glassEffect(.regular, in: .circle)
        } else {
            self
                .background(.regularMaterial, in: Circle())
                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.chatBackground.ignoresSafeArea()

        VStack {
            Spacer()
            HStack {
                Spacer()
                ScrollNavigationButtons(
                    showScrollToTop: true,
                    showScrollToBottom: true,
                    unreadCount: 3,
                    onScrollToTop: { print("Top") },
                    onScrollToBottom: { print("Bottom") }
                )
                .padding()
            }
        }
    }
}
