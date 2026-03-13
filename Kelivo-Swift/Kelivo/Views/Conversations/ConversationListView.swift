import SwiftUI
import SwiftData

// MARK: - ConversationListView

/// Searchable list of conversations grouped by date, with support for
/// creating, pinning, renaming, and deleting conversations.
struct ConversationListView: View {
    @Environment(AppState.self) private var appState
    @Environment(ChatViewModel.self) private var chatVM
    @Environment(ConversationListViewModel.self) private var conversationListVM
    @Environment(\.modelContext) private var modelContext

    @State private var renamingConversation: Conversation?
    @State private var renameText: String = ""

    // MARK: Body

    var body: some View {
        @Bindable var listVM = conversationListVM

        List(selection: Bindable(appState).selectedConversationID) {
            pinnedSection
            todaySection
            yesterdaySection
            thisWeekSection
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
                .newChatButtonStyle()
                .help(String(localized: "newChat"))
            }
        }
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

    // MARK: - Sections

    @ViewBuilder
    private var pinnedSection: some View {
        let pinned = grouped.pinned
        if !pinned.isEmpty {
            Section(String(localized: "pinned")) {
                ForEach(pinned) { conversation in
                    conversationRow(conversation)
                }
            }
        }
    }

    @ViewBuilder
    private var todaySection: some View {
        let items = grouped.today
        if !items.isEmpty {
            Section(String(localized: "today")) {
                ForEach(items) { conversation in
                    conversationRow(conversation)
                }
            }
        }
    }

    @ViewBuilder
    private var yesterdaySection: some View {
        let items = grouped.yesterday
        if !items.isEmpty {
            Section(String(localized: "yesterday")) {
                ForEach(items) { conversation in
                    conversationRow(conversation)
                }
            }
        }
    }

    @ViewBuilder
    private var thisWeekSection: some View {
        let items = grouped.thisWeek
        if !items.isEmpty {
            Section(String(localized: "thisWeek")) {
                ForEach(items) { conversation in
                    conversationRow(conversation)
                }
            }
        }
    }

    @ViewBuilder
    private var olderSection: some View {
        let items = grouped.older
        if !items.isEmpty {
            Section(String(localized: "older")) {
                ForEach(items) { conversation in
                    conversationRow(conversation)
                }
            }
        }
    }

    // MARK: - Conversation Row

    private func conversationRow(_ conversation: Conversation) -> some View {
        ConversationRow(conversation: conversation)
            .tag(conversation.id)
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    conversationListVM.deleteConversation(conversation)
                    if appState.selectedConversationID == conversation.id {
                        appState.selectedConversationID = nil
                    }
                } label: {
                    Label(String(localized: "delete"), systemImage: "trash")
                }
            }
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button {
                    conversationListVM.togglePin(conversation)
                } label: {
                    Label(
                        conversation.isPinned
                            ? String(localized: "unpin")
                            : String(localized: "pin"),
                        systemImage: conversation.isPinned ? "pin.slash" : "pin"
                    )
                }
                .tint(.orange)
            }
            .contextMenu {
                Button {
                    renamingConversation = conversation
                    renameText = conversation.title
                } label: {
                    Label(String(localized: "rename"), systemImage: "pencil")
                }

                Button {
                    conversationListVM.togglePin(conversation)
                } label: {
                    Label(
                        conversation.isPinned
                            ? String(localized: "unpin")
                            : String(localized: "pin"),
                        systemImage: conversation.isPinned ? "pin.slash" : "pin"
                    )
                }

                Divider()

                Button(role: .destructive) {
                    conversationListVM.deleteConversation(conversation)
                    if appState.selectedConversationID == conversation.id {
                        appState.selectedConversationID = nil
                    }
                } label: {
                    Label(String(localized: "delete"), systemImage: "trash")
                }
            }
    }

    // MARK: - Grouping

    private var grouped: GroupedConversations {
        let conversations = conversationListVM.filteredConversations
            .filter { !$0.isPinned }
        let pinned = conversationListVM.filteredConversations
            .filter { $0.isPinned }

        let calendar = Calendar.current
        let now = Date.now
        let startOfToday = calendar.startOfDay(for: now)
        let startOfYesterday = calendar.date(byAdding: .day, value: -1, to: startOfToday)!
        let startOfWeek = calendar.date(byAdding: .day, value: -7, to: startOfToday)!

        var today: [Conversation] = []
        var yesterday: [Conversation] = []
        var thisWeek: [Conversation] = []
        var older: [Conversation] = []

        for conversation in conversations {
            if conversation.updatedAt >= startOfToday {
                today.append(conversation)
            } else if conversation.updatedAt >= startOfYesterday {
                yesterday.append(conversation)
            } else if conversation.updatedAt >= startOfWeek {
                thisWeek.append(conversation)
            } else {
                older.append(conversation)
            }
        }

        return GroupedConversations(
            pinned: pinned,
            today: today,
            yesterday: yesterday,
            thisWeek: thisWeek,
            older: older
        )
    }

    // MARK: - Actions

    private func createNewChat() {
        let conversation = conversationListVM.createNewConversation()
        appState.selectedConversationID = conversation.id
    }
}

// MARK: - GroupedConversations

private struct GroupedConversations {
    let pinned: [Conversation]
    let today: [Conversation]
    let yesterday: [Conversation]
    let thisWeek: [Conversation]
    let older: [Conversation]
}

// MARK: - Glass Modifier

private extension View {
    @ViewBuilder
    func newChatButtonStyle() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.buttonStyle(.glass)
        } else {
            self.buttonStyle(.plain)
        }
    }
}
