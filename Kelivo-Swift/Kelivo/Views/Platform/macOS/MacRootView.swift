import SwiftUI
import SwiftData

// MARK: - MacRootView

/// Root view for macOS using a NavigationSplitView with a conversation
/// sidebar and a chat detail pane.
struct MacRootView: View {
    @Environment(AppState.self) private var appState
    @Environment(ChatViewModel.self) private var chatVM
    @Environment(ConversationListViewModel.self) private var conversationListVM
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        @Bindable var state = appState

        NavigationSplitView(columnVisibility: $state.sidebarVisibility) {
            ConversationListView()
                .navigationSplitViewColumnWidth(min: 220, ideal: 280, max: 400)
        } detail: {
            detailView
        }
        .toolbar { macToolbarContent }
        .frame(minWidth: 700, minHeight: 500)
        .onAppear {
            chatVM.configure(modelContext: modelContext)
            conversationListVM.configure(modelContext: modelContext)
        }
    }

    // MARK: - Detail View

    @ViewBuilder
    private var detailView: some View {
        if let id = appState.selectedConversationID {
            ChatView(conversationId: id)
        } else {
            ContentUnavailableView(
                String(localized: "selectConversation"),
                systemImage: "bubble.left.and.bubble.right",
                description: Text(String(localized: "selectConversationDescription"))
            )
        }
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var macToolbarContent: some ToolbarContent {
        MacToolbar(
            onNewChat: {
                let conversation = conversationListVM.createNewConversation()
                appState.selectedConversationID = conversation.id
            },
            onToggleSidebar: {
                withAnimation {
                    appState.sidebarVisibility = appState.sidebarVisibility == .detailOnly
                        ? .all
                        : .detailOnly
                }
            }
        )
    }
}
