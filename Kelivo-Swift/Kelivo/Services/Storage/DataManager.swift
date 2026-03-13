import Foundation
import SwiftData

@MainActor
final class DataManager {
    static let shared = DataManager()

    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ChatMessage.self,
            Conversation.self,
            Assistant.self,
            AssistantMemory.self,
            AssistantTag.self,
            AssistantRegex.self,
            ProviderConfig.self,
            ModelConfig.self,
            QuickPhrase.self,
            InstructionInjection.self,
            WorldBookEntry.self,
            BackupConfig.self,
            TokenUsage.self,
            PresetMessage.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    let container: ModelContainer

    private init() {
        container = Self.sharedModelContainer
    }
}
