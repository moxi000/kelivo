#if os(macOS)
import SwiftUI
import SwiftData

// MARK: - MacSidebar

/// Desktop sidebar for macOS with conversation list, search, section headers
/// (pinned, recent), new conversation button, and assistant selector.
/// Width is resizable via NavigationSplitView column width constraints.
struct MacSidebar: View {
    @Environment(AppState.self) private var appState
    @Environment(ConversationListViewModel.self) private var conversationListVM
    @Environment(\.modelContext) private var modelContext

    @State private var renamingConversation: Conversation?
    @State private var renameText: String = ""
    @State private var selectedAssistantId: String?

    // MARK: Body

    var body: some View {
        @Bindable var listVM = conversationListVM

        VStack(spacing: 0) {
            conversationList
            Divider()
            assistantSelector
        }
        .navigationSplitViewColumnWidth(min: 220, ideal: 280, max: 400)
        .onAppear {
            conversationListVM.configure(modelContext: modelContext)
            conversationListVM.loadConversations()
        }
        .alert(
            String(localized: "renameConversation"),
            isPresented: .init(
                get: { renamingConversation != nil },
                set: { if !$0 { renamingConversation = nil } }
            )
        ) {
            TextField(String(localized: "conversationTitle"), text: $renameText)
            Button(String(localized: "cancel"), role: .cancel) {}
            Button(String(localized: "rename")) {
                if let conversation = renamingConversation {
                    conversationListVM.renameConversation(conversation, newTitle: renameText)
                }
                renamingConversation = nil
            }
        }
    }

    // MARK: - Conversation List

    private var conversationList: some View {
        @Bindable var listVM = conversationListVM

        return List(selection: Bindable(appState).selectedConversationID) {
            pinnedSection
            recentSection
            olderSection
        }
        .listStyle(.sidebar)
        .searchable(
            text: $listVM.searchText,
            placement: .sidebar,
            prompt: String(localized: "searchConversations")
        )
        .navigationTitle(String(localized: "chats"))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    createNewChat()
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                .sidebarGlassButton()
                .help(String(localized: "newChat"))
            }
        }
    }

    // MARK: - Sections

    @ViewBuilder
    private var pinnedSection: some View {
        let pinned = conversationListVM.filteredConversations.filter(\.isPinned)
        if !pinned.isEmpty {
            Section(String(localized: "pinned")) {
                ForEach(pinned) { conversation in
                    conversationRow(conversation)
                }
            }
        }
    }

    @ViewBuilder
    private var recentSection: some View {
        let recent = recentConversations
        if !recent.isEmpty {
            Section(String(localized: "today")) {
                ForEach(recent) { conversation in
                    conversationRow(conversation)
                }
            }
        }
    }

    @ViewBuilder
    private var olderSection: some View {
        let older = olderConversations
        if !older.isEmpty {
            Section(String(localized: "older")) {
                ForEach(older) { conversation in
                    conversationRow(conversation)
                }
            }
        }
    }

    // MARK: - Conversation Row

    private func conversationRow(_ conversation: Conversation) -> some View {
        ConversationRow(conversation: conversation)
            .tag(conversation.id)
            .contextMenu {
                ConversationContextMenu(
                    conversation: conversation,
                    onPin: {
                        conversationListVM.togglePin(conversation)
                    },
                    onRename: {
                        renamingConversation = conversation
                        renameText = conversation.title
                    },
                    onDelete: {
                        conversationListVM.deleteConversation(conversation)
                        if appState.selectedConversationID == conversation.id {
                            appState.selectedConversationID = nil
                        }
                    },
                    onExport: {
                        // TODO: Implement conversation export
                    }
                )
            }
    }

    // MARK: - Assistant Selector

    private var assistantSelector: some View {
        HStack(spacing: 8) {
            Image(systemName: "person.crop.circle")
                .font(.title3)
                .foregroundStyle(.secondary)

            Text(String(localized: "defaultAssistant"))
                .font(.callout)
                .foregroundStyle(.primary)
                .lineLimit(1)

            Spacer()

            Image(systemName: "chevron.up.chevron.down")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }

    // MARK: - Helpers

    private var recentConversations: [Conversation] {
        let startOfToday = Calendar.current.startOfDay(for: .now)
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: startOfToday)!
        return conversationListVM.filteredConversations
            .filter { !$0.isPinned && $0.updatedAt >= weekAgo }
    }

    private var olderConversations: [Conversation] {
        let startOfToday = Calendar.current.startOfDay(for: .now)
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: startOfToday)!
        return conversationListVM.filteredConversations
            .filter { !$0.isPinned && $0.updatedAt < weekAgo }
    }

    private func createNewChat() {
        let conversation = conversationListVM.createNewConversation()
        appState.selectedConversationID = conversation.id
    }
}

// MARK: - Glass Modifier

private extension View {
    @ViewBuilder
    func sidebarGlassButton() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.buttonStyle(.glass)
        } else {
            self.buttonStyle(.plain)
        }
    }
}

// MARK: - Preview

#Preview {
    MacSidebar()
        .environment(AppState())
        .environment(ConversationListViewModel())
        .frame(width: 280, height: 600)
}
#endif
