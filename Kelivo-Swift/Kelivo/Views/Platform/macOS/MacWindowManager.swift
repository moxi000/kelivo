#if os(macOS)
import AppKit
import SwiftUI

// MARK: - MacWindowManager

/// Manages window position, size persistence, and minimum size constraints
/// for the macOS main window. Saves and restores the window frame using
/// UserDefaults so the window reopens where the user left it.
@Observable
final class MacWindowManager {

    // MARK: - Constants

    private enum Keys {
        static let windowFrameX = "kelivo.window.frame.x"
        static let windowFrameY = "kelivo.window.frame.y"
        static let windowFrameWidth = "kelivo.window.frame.width"
        static let windowFrameHeight = "kelivo.window.frame.height"
    }

    static let minimumWidth: CGFloat = 700
    static let minimumHeight: CGFloat = 500
    static let defaultWidth: CGFloat = 1000
    static let defaultHeight: CGFloat = 700

    // MARK: - State

    private(set) var isConfigured: Bool = false

    // MARK: - Setup

    /// Configures the main window with saved frame and minimum size constraints.
    /// Should be called once during app launch, typically from the main window's
    /// `onAppear` or the App struct.
    func configureMainWindow() {
        guard !isConfigured else { return }
        isConfigured = true

        DispatchQueue.main.async { [self] in
            guard let window = NSApp.windows.first(where: { $0.isVisible || $0.canBecomeKey }) else {
                return
            }

            applyMinimumSize(to: window)
            restoreFrame(for: window)
            observeFrameChanges(for: window)
        }
    }

    // MARK: - Save

    /// Saves the current window frame to UserDefaults.
    func saveFrame(of window: NSWindow) {
        let frame = window.frame
        let defaults = UserDefaults.standard
        defaults.set(Double(frame.origin.x), forKey: Keys.windowFrameX)
        defaults.set(Double(frame.origin.y), forKey: Keys.windowFrameY)
        defaults.set(Double(frame.size.width), forKey: Keys.windowFrameWidth)
        defaults.set(Double(frame.size.height), forKey: Keys.windowFrameHeight)
    }

    // MARK: - Restore

    /// Restores window frame from UserDefaults, falling back to default
    /// centered size if no saved frame exists.
    func restoreFrame(for window: NSWindow) {
        let defaults = UserDefaults.standard

        guard defaults.object(forKey: Keys.windowFrameWidth) != nil else {
            // No saved frame; center with default size
            let defaultFrame = NSRect(
                x: 0, y: 0,
                width: Self.defaultWidth,
                height: Self.defaultHeight
            )
            window.setFrame(defaultFrame, display: true)
            window.center()
            return
        }

        let x = defaults.double(forKey: Keys.windowFrameX)
        let y = defaults.double(forKey: Keys.windowFrameY)
        let width = max(defaults.double(forKey: Keys.windowFrameWidth), Self.minimumWidth)
        let height = max(defaults.double(forKey: Keys.windowFrameHeight), Self.minimumHeight)

        let savedFrame = NSRect(x: x, y: y, width: width, height: height)

        // Verify the saved frame is still visible on a connected screen
        let isOnScreen = NSScreen.screens.contains { screen in
            screen.visibleFrame.intersects(savedFrame)
        }

        if isOnScreen {
            window.setFrame(savedFrame, display: true)
        } else {
            // Screen configuration changed; center with saved size
            let centeredFrame = NSRect(x: 0, y: 0, width: width, height: height)
            window.setFrame(centeredFrame, display: true)
            window.center()
        }
    }

    // MARK: - Minimum Size

    /// Applies minimum size constraints to the window.
    func applyMinimumSize(to window: NSWindow) {
        window.minSize = NSSize(
            width: Self.minimumWidth,
            height: Self.minimumHeight
        )
    }

    // MARK: - Frame Observation

    private var frameObservation: NSObjectProtocol?

    /// Observes window frame changes and persists them automatically.
    private func observeFrameChanges(for window: NSWindow) {
        frameObservation = NotificationCenter.default.addObserver(
            forName: NSWindow.didEndLiveResizeNotification,
            object: window,
            queue: .main
        ) { [weak self] notification in
            guard let window = notification.object as? NSWindow else { return }
            self?.saveFrame(of: window)
        }

        // Also save on move
        NotificationCenter.default.addObserver(
            forName: NSWindow.didMoveNotification,
            object: window,
            queue: .main
        ) { [weak self] notification in
            guard let window = notification.object as? NSWindow else { return }
            self?.saveFrame(of: window)
        }
    }

    deinit {
        if let observation = frameObservation {
            NotificationCenter.default.removeObserver(observation)
        }
    }
}

// MARK: - WindowManagerModifier

/// A view modifier that configures the window manager when the view appears.
struct WindowManagerModifier: ViewModifier {
    let windowManager: MacWindowManager

    func body(content: Content) -> some View {
        content
            .onAppear {
                windowManager.configureMainWindow()
            }
    }
}

extension View {
    /// Configures window frame persistence and minimum size constraints.
    func managedWindow(_ manager: MacWindowManager) -> some View {
        modifier(WindowManagerModifier(windowManager: manager))
    }
}

// MARK: - Preview

#Preview {
    Text("Window Manager Preview")
        .frame(width: 400, height: 300)
}
#endif
