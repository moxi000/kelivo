import SwiftUI
import SwiftData

// MARK: - iOSRootView

/// Root view for iOS, providing tab-based navigation with
/// Chats, Translate, and Settings tabs.
struct iOSRootView: View {
    @Environment(AppState.self) private var appState
    @Environment(ChatViewModel.self) private var chatVM
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            Tab(String(localized: "chats"), systemImage: "bubble.left.and.bubble.right") {
                NavigationStack {
                    ConversationListView()
                        .navigationDestination(for: String.self) { conversationId in
                            ChatView(conversationId: conversationId)
                        }
                }
            }

            Tab(String(localized: "translate"), systemImage: "translate") {
                NavigationStack {
                    // TranslateView placeholder
                    ContentUnavailableView(
                        String(localized: "translate"),
                        systemImage: "translate",
                        description: Text(String(localized: "comingSoon"))
                    )
                    .navigationTitle(String(localized: "translate"))
                }
            }

            Tab(String(localized: "settings"), systemImage: "gearshape") {
                NavigationStack {
                    // SettingsView placeholder
                    ContentUnavailableView(
                        String(localized: "settings"),
                        systemImage: "gearshape",
                        description: Text(String(localized: "comingSoon"))
                    )
                    .navigationTitle(String(localized: "settings"))
                }
            }
        }
    }
}
