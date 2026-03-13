import SwiftUI
import SwiftData

@main
struct KelivoApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            iOSRootView()
                .environment(appState)
            #elseif os(macOS)
            MacRootView()
                .environment(appState)
            #endif
        }
        .modelContainer(for: [
            Conversation.self,
            Message.self,
            ProviderConfig.self,
        ])
        #if os(macOS)
        .commands {
            MacMenuCommands(appState: appState)
        }
        #endif
    }
}
