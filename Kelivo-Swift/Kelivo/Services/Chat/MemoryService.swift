import Foundation
import SwiftData

actor MemoryService {
    static let shared = MemoryService()

    // MARK: - Fetch

    func getAll(context: ModelContext) throws -> [AssistantMemory] {
        let descriptor = FetchDescriptor<AssistantMemory>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    func getForAssistant(_ assistantId: String, context: ModelContext) throws -> [AssistantMemory] {
        let predicate = #Predicate<AssistantMemory> { $0.assistantId == assistantId }
        let descriptor = FetchDescriptor<AssistantMemory>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    // MARK: - Mutate

    func add(_ memory: AssistantMemory, context: ModelContext) throws {
        context.insert(memory)
        try context.save()
    }

    func update(_ id: String, content: String, context: ModelContext) throws {
        let predicate = #Predicate<AssistantMemory> { $0.id == id }
        let descriptor = FetchDescriptor<AssistantMemory>(predicate: predicate)
        guard let memory = try context.fetch(descriptor).first else {
            throw MemoryServiceError.notFound(id)
        }
        memory.content = content
        try context.save()
    }

    func delete(_ id: String, context: ModelContext) throws {
        let predicate = #Predicate<AssistantMemory> { $0.id == id }
        let descriptor = FetchDescriptor<AssistantMemory>(predicate: predicate)
        guard let memory = try context.fetch(descriptor).first else {
            throw MemoryServiceError.notFound(id)
        }
        context.delete(memory)
        try context.save()
    }

    func deleteForAssistant(_ assistantId: String, context: ModelContext) throws {
        let predicate = #Predicate<AssistantMemory> { $0.assistantId == assistantId }
        let descriptor = FetchDescriptor<AssistantMemory>(predicate: predicate)
        let memories = try context.fetch(descriptor)
        for memory in memories {
            context.delete(memory)
        }
        try context.save()
    }

    // MARK: - Errors

    enum MemoryServiceError: LocalizedError {
        case notFound(String)

        var errorDescription: String? {
            switch self {
            case .notFound(let id):
                return "Memory with id '\(id)' not found."
            }
        }
    }
}
