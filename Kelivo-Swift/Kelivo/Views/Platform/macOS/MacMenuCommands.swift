import SwiftUI

// MARK: - MacMenuCommands

/// macOS menu bar commands for the Kelivo app, providing keyboard shortcuts
/// for common chat actions.
struct MacMenuCommands: Commands {
    let appState: AppState

    var body: some Commands {
        // Replace default "New" with "New Chat"
        CommandGroup(replacing: .newItem) {
            Button(String(localized: "newChat")) {
                NotificationCenter.default.post(
                    name: .kelivoNewChat,
                    object: nil
                )
            }
            .keyboardShortcut("n", modifiers: .command)
        }

        // Sidebar toggle
        CommandGroup(after: .sidebar) {
            Button(String(localized: "toggleSidebar")) {
                NotificationCenter.default.post(
                    name: .kelivoToggleSidebar,
                    object: nil
                )
            }
            .keyboardShortcut("s", modifiers: [.command, .control])
        }

        // Chat menu
        CommandMenu(String(localized: "chat")) {
            Button(String(localized: "sendMessage")) {
                NotificationCenter.default.post(
                    name: .kelivoSendMessage,
                    object: nil
                )
            }
            .keyboardShortcut(.return, modifiers: .command)

            Button(String(localized: "stopGeneration")) {
                NotificationCenter.default.post(
                    name: .kelivoStopGeneration,
                    object: nil
                )
            }
            .keyboardShortcut(".", modifiers: .command)

            Divider()

            Button(String(localized: "clearChat")) {
                NotificationCenter.default.post(
                    name: .kelivoClearChat,
                    object: nil
                )
            }
            .keyboardShortcut("k", modifiers: [.command, .shift])
        }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let kelivoNewChat = Notification.Name("kelivoNewChat")
    static let kelivoToggleSidebar = Notification.Name("kelivoToggleSidebar")
    static let kelivoSendMessage = Notification.Name("kelivoSendMessage")
    static let kelivoStopGeneration = Notification.Name("kelivoStopGeneration")
    static let kelivoClearChat = Notification.Name("kelivoClearChat")
}
