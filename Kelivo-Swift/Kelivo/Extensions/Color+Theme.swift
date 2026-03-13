import SwiftUI

extension Color {
    // MARK: - Chat Colors

    /// Background color for user message bubbles.
    static let chatUserBubble = Color(
        light: Color(red: 0.22, green: 0.52, blue: 1.0).opacity(0.15),
        dark: Color(red: 0.30, green: 0.56, blue: 1.0).opacity(0.25)
    )

    /// Background color for assistant message bubbles.
    static let chatAssistantBubble = Color(
        light: Color(red: 0.92, green: 0.92, blue: 0.94),
        dark: Color(red: 0.22, green: 0.22, blue: 0.24)
    )

    /// Background color for the chat view.
    static let chatBackground = Color(
        light: Color(red: 0.97, green: 0.97, blue: 0.98),
        dark: Color(red: 0.11, green: 0.11, blue: 0.12)
    )

    // MARK: - Accent & Surface Colors

    /// Primary accent color for interactive elements.
    static let accentPrimary = Color(
        light: Color(red: 0.20, green: 0.48, blue: 1.0),
        dark: Color(red: 0.38, green: 0.62, blue: 1.0)
    )

    /// Primary surface color for cards and containers.
    static let surfacePrimary = Color(
        light: .white,
        dark: Color(red: 0.16, green: 0.16, blue: 0.18)
    )

    /// Secondary surface color for nested or grouped areas.
    static let surfaceSecondary = Color(
        light: Color(red: 0.95, green: 0.95, blue: 0.97),
        dark: Color(red: 0.20, green: 0.20, blue: 0.22)
    )
}

// MARK: - Adaptive Color Initializer

private extension Color {
    init(light: Color, dark: Color) {
        #if os(iOS)
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
        #elseif os(macOS)
        self.init(nsColor: NSColor(name: nil) { appearance in
            let isDark = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            return isDark ? NSColor(dark) : NSColor(light)
        })
        #endif
    }
}
