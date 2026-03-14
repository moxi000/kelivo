import Foundation
import Observation
import SwiftData

@Observable
final class AssistantViewModel {

    // MARK: Published State

    var assistants: [Assistant] = []
    var tags: [AssistantTag] = []
    var memories: [AssistantMemory] = []
    var selectedAssistant: Assistant?

    // MARK: Private

    private var modelContext: ModelContext?

    // MARK: Configuration

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Assistants

    func loadAssistants() {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<Assistant>(
            sortBy: [SortDescriptor(\.name, order: .forward)]
        )

        do {
            assistants = try context.fetch(descriptor)
        } catch {
            assistants = []
        }
    }

    func createAssistant(name: String, systemPrompt: String) -> Assistant {
        let assistant = Assistant(name: name, systemPrompt: systemPrompt)
        modelContext?.insert(assistant)
        assistants.append(assistant)
        saveContext()
        return assistant
    }

    func updateAssistant(_ assistant: Assistant) {
        saveContext()
    }

    func deleteAssistant(_ assistant: Assistant) {
        guard let context = modelContext else { return }
        guard assistant.deletable else { return }

        // Delete associated memories
        let assistantId = assistant.id
        let memoryPredicate = #Predicate<AssistantMemory> { $0.assistantId == assistantId }
        if let memories = try? context.fetch(FetchDescriptor(predicate: memoryPredicate)) {
            for memory in memories {
                context.delete(memory)
            }
        }

        // Delete associated regex rules
        let regexPredicate = #Predicate<AssistantRegex> { $0.assistantId == assistantId }
        if let rules = try? context.fetch(FetchDescriptor(predicate: regexPredicate)) {
            for rule in rules {
                context.delete(rule)
            }
        }

        assistants.removeAll { $0.id == assistant.id }
        context.delete(assistant)
        saveContext()
    }

    /// Ensures a default assistant exists. Call on app startup.
    func ensureDefaults() {
        guard let context = modelContext else { return }

        let predicate = #Predicate<Assistant> { $0.deletable == false }
        let descriptor = FetchDescriptor<Assistant>(predicate: predicate)

        let defaults = (try? context.fetch(descriptor)) ?? []
        if defaults.isEmpty {
            let defaultAssistant = Assistant(
                name: "Default",
                deletable: false
            )
            context.insert(defaultAssistant)
            saveContext()
            assistants.insert(defaultAssistant, at: 0)
        }
    }

    // MARK: - Tags

    func loadTags() {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<AssistantTag>(
            sortBy: [SortDescriptor(\.sortOrder, order: .forward)]
        )

        do {
            tags = try context.fetch(descriptor)
        } catch {
            tags = []
        }
    }

    func createTag(name: String, color: String) -> AssistantTag {
        let tag = AssistantTag(name: name, color: color, sortOrder: tags.count)
        modelContext?.insert(tag)
        tags.append(tag)
        saveContext()
        return tag
    }

    func deleteTag(_ tag: AssistantTag) {
        guard let context = modelContext else { return }
        tags.removeAll { $0.id == tag.id }
        context.delete(tag)
        saveContext()
    }

    // MARK: - Memory

    func loadMemories(for assistantId: String) {
        guard let context = modelContext else {
            memories = []
            return
        }

        let predicate = #Predicate<AssistantMemory> { $0.assistantId == assistantId }
        let descriptor = FetchDescriptor<AssistantMemory>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        memories = (try? context.fetch(descriptor)) ?? []
    }

    /// Overload that accepts an Assistant directly for convenience.
    func loadMemories(for assistant: Assistant) {
        loadMemories(for: assistant.id)
    }

    func addMemory(assistantId: String, content: String) {
        let memory = AssistantMemory(
            assistantId: assistantId,
            content: content
        )
        modelContext?.insert(memory)
        saveContext()
        loadMemories(for: assistantId)
    }

    func updateMemory(id: String, content: String) {
        guard let context = modelContext else { return }

        let predicate = #Predicate<AssistantMemory> { $0.id == id }
        let descriptor = FetchDescriptor<AssistantMemory>(predicate: predicate)
        guard let memory = try? context.fetch(descriptor).first else { return }

        memory.content = content
        saveContext()

        // Refresh the local list if it contains this memory
        if let index = memories.firstIndex(where: { $0.id == id }) {
            memories[index] = memory
        }
    }

    func deleteMemory(id: String) {
        guard let context = modelContext else { return }

        let predicate = #Predicate<AssistantMemory> { $0.id == id }
        let descriptor = FetchDescriptor<AssistantMemory>(predicate: predicate)
        guard let memory = try? context.fetch(descriptor).first else { return }

        context.delete(memory)
        memories.removeAll { $0.id == id }
        saveContext()
    }

    /// Legacy overload accepting an AssistantMemory object directly.
    func deleteMemory(_ memory: AssistantMemory) {
        guard let context = modelContext else { return }
        memories.removeAll { $0.id == memory.id }
        context.delete(memory)
        saveContext()
    }

    // MARK: - Regex Rules

    func loadRegexRules(for assistant: Assistant) -> [AssistantRegex] {
        guard let context = modelContext else { return [] }

        let assistantId = assistant.id
        let predicate = #Predicate<AssistantRegex> { $0.assistantId == assistantId }
        let descriptor = FetchDescriptor<AssistantRegex>(predicate: predicate)

        return (try? context.fetch(descriptor)) ?? []
    }

    func addRegex(pattern: String, replacement: String, for assistant: Assistant) {
        let regex = AssistantRegex(
            assistantId: assistant.id,
            pattern: pattern,
            replacement: replacement
        )
        modelContext?.insert(regex)
        saveContext()
    }

    func deleteRegex(_ regex: AssistantRegex) {
        guard let context = modelContext else { return }
        context.delete(regex)
        saveContext()
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
