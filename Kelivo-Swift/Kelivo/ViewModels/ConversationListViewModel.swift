import Foundation
import Observation
import SwiftData

@Observable
final class ConversationListViewModel {

    // MARK: Published State

    var conversations: [Conversation] = []
    var searchText: String = ""

    var filteredConversations: [Conversation] {
        guard !searchText.isEmpty else { return conversations }
        let query = searchText.lowercased()
        return conversations.filter { $0.title.lowercased().contains(query) }
    }

    // MARK: Private

    private var modelContext: ModelContext?

    // MARK: Configuration

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Loading

    func loadConversations() {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<Conversation>(
            sortBy: [
                SortDescriptor(\.isPinned, order: .reverse),
                SortDescriptor(\.updatedAt, order: .reverse),
            ]
        )

        do {
            conversations = try context.fetch(descriptor)
        } catch {
            conversations = []
        }
    }

    // MARK: - CRUD

    func createNewConversation() -> Conversation {
        let conversation = Conversation(title: "New Chat")

        modelContext?.insert(conversation)
        saveContext()

        conversations.insert(conversation, at: 0)
        return conversation
    }

    func deleteConversation(_ conversation: Conversation) {
        guard let context = modelContext else { return }

        // Delete associated messages
        let conversationId = conversation.id
        let predicate = #Predicate<ChatMessage> { $0.conversationId == conversationId }
        let descriptor = FetchDescriptor<ChatMessage>(predicate: predicate)

        if let messages = try? context.fetch(descriptor) {
            for message in messages {
                context.delete(message)
            }
        }

        conversations.removeAll { $0.id == conversation.id }
        context.delete(conversation)
        saveContext()
    }

    func togglePin(_ conversation: Conversation) {
        conversation.isPinned.toggle()
        conversation.updatedAt = .now
        saveContext()
        loadConversations()
    }

    func renameConversation(_ conversation: Conversation, newTitle: String) {
        let trimmed = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        conversation.title = trimmed
        conversation.updatedAt = .now
        saveContext()
    }

    func searchConversations(query: String) -> [Conversation] {
        guard let context = modelContext else { return [] }

        let lowered = query.lowercased()
        let predicate = #Predicate<Conversation> {
            $0.title.localizedStandardContains(lowered)
        }
        let descriptor = FetchDescriptor<Conversation>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )

        do {
            return try context.fetch(descriptor)
        } catch {
            return []
        }
    }

    // MARK: - Private

    private func saveContext() {
        guard let context = modelContext else { return }
        do {
            try context.save()
        } catch {
            // TODO: Surface save errors to the UI layer
        }
    }
}
