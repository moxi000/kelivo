#if os(macOS)
import AppKit
import SwiftUI

// MARK: - MacTrayController

/// Manages the macOS system tray (NSStatusItem) for Kelivo.
/// Provides menu items for showing the main window, starting a new chat,
/// and quitting the app. Visibility is toggled via settings.
@Observable
final class MacTrayController {

    // MARK: - State

    private var statusItem: NSStatusItem?
    private var isVisible: Bool = false

    // MARK: - Setup

    /// Installs or removes the tray icon based on the `show` flag.
    func setVisible(_ show: Bool) {
        guard show != isVisible else { return }
        isVisible = show

        if show {
            install()
        } else {
            remove()
        }
    }

    // MARK: - Private

    private func install() {
        guard statusItem == nil else { return }

        let item = NSStatusBar.system.statusItem(
            withLength: NSStatusItem.squareLength
        )

        if let button = item.button {
            button.image = NSImage(
                systemSymbolName: "bubble.left.and.bubble.right",
                accessibilityDescription: "Kelivo"
            )
            button.image?.size = NSSize(width: 18, height: 18)
        }

        let menu = buildMenu()
        item.menu = menu
        statusItem = item
    }

    private func remove() {
        if let item = statusItem {
            NSStatusBar.system.removeStatusItem(item)
            statusItem = nil
        }
    }

    private func buildMenu() -> NSMenu {
        let menu = NSMenu()

        // Show Window
        let showItem = NSMenuItem(
            title: String(localized: "showWindow"),
            action: #selector(TrayActions.showWindow),
            keyEquivalent: ""
        )
        showItem.target = TrayActions.shared
        menu.addItem(showItem)

        // New Chat
        let newChatItem = NSMenuItem(
            title: String(localized: "newChat"),
            action: #selector(TrayActions.newChat),
            keyEquivalent: "n"
        )
        newChatItem.target = TrayActions.shared
        menu.addItem(newChatItem)

        menu.addItem(.separator())

        // Quit
        let quitItem = NSMenuItem(
            title: String(localized: "quit"),
            action: #selector(TrayActions.quitApp),
            keyEquivalent: "q"
        )
        quitItem.target = TrayActions.shared
        menu.addItem(quitItem)

        return menu
    }
}

// MARK: - TrayActions

/// Objective-C compatible target for tray menu actions.
private final class TrayActions: NSObject {
    static let shared = TrayActions()

    @objc func showWindow() {
        NSApp.activate(ignoringOtherApps: true)
        if let window = NSApp.windows.first {
            window.makeKeyAndOrderFront(nil)
        }
    }

    @objc func newChat() {
        showWindow()
        NotificationCenter.default.post(
            name: .kelivoNewChat,
            object: nil
        )
    }

    @objc func quitApp() {
        NSApp.terminate(nil)
    }
}
#endif
