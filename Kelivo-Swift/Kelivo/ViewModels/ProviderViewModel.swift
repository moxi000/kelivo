import Foundation
import Observation
import Security
import SwiftData

// MARK: - Supporting Types

struct RemoteModel: Identifiable, Sendable {
    let id: String
    let name: String
    let supportsVision: Bool
    let supportsTools: Bool
    let supportsReasoning: Bool
    let maxContextTokens: Int?
    let maxOutputTokens: Int?
}

// MARK: - ProviderViewModel

@Observable
final class ProviderViewModel {

    // MARK: Published State

    var providers: [ProviderConfig] = []
    var selectedProvider: ProviderConfig?

    // MARK: Private

    private var modelContext: ModelContext?

    private static let keychainService = "com.kelivo.provider-api-keys"

    // MARK: Configuration

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Loading

    func loadProviders() {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<ProviderConfig>(
            sortBy: [SortDescriptor(\.sortOrder, order: .forward)]
        )

        do {
            providers = try context.fetch(descriptor)
        } catch {
            providers = []
        }
    }

    // MARK: - CRUD

    func addProvider(name: String, apiType: ApiType, baseUrl: String, apiKey: String) {
        let provider = ProviderConfig(
            name: name,
            apiType: apiType,
            baseUrl: baseUrl,
            sortOrder: providers.count
        )

        modelContext?.insert(provider)

        if !apiKey.isEmpty {
            saveApiKey(apiKey, for: provider.id)
            provider.apiKeyRef = provider.id
        }

        providers.append(provider)
        saveContext()
    }

    func updateProvider(_ provider: ProviderConfig) {
        saveContext()
    }

    func deleteProvider(_ provider: ProviderConfig) {
        guard let context = modelContext else { return }

        deleteApiKey(for: provider.id)
        providers.removeAll { $0.id == provider.id }
        context.delete(provider)
        saveContext()
    }

    // MARK: - Model Fetching

    func fetchModels(for provider: ProviderConfig) async throws -> [RemoteModel] {
        // TODO: Implement API call to fetch available models from the provider's endpoint
        // This would use provider.baseUrl, provider.apiType, and the API key
        // to call the appropriate models list endpoint
        _ = provider
        return []
    }

    // MARK: - Default Model / Provider

    func setDefaultModel(providerId: String, modelId: String) {
        guard let context = modelContext else { return }

        // Clear existing defaults
        let descriptor = FetchDescriptor<ModelConfig>()
        if let allModels = try? context.fetch(descriptor) {
            for model in allModels {
                model.isDefault = false
            }
        }

        // Set the new default
        let predicate = #Predicate<ModelConfig> {
            $0.providerId == providerId && $0.modelId == modelId
        }
        var targetDescriptor = FetchDescriptor<ModelConfig>(predicate: predicate)
        targetDescriptor.fetchLimit = 1

        if let targets = try? context.fetch(targetDescriptor),
           let target = targets.first
        {
            target.isDefault = true
        }

        saveContext()
    }

    func getDefaultProvider() -> ProviderConfig? {
        guard let context = modelContext else { return nil }

        let descriptor = FetchDescriptor<ModelConfig>(
            predicate: #Predicate<ModelConfig> { $0.isDefault == true }
        )

        guard let defaultModel = try? context.fetch(descriptor).first else { return nil }

        let providerId = defaultModel.providerId
        let providerPredicate = #Predicate<ProviderConfig> { $0.id == providerId }
        var providerDescriptor = FetchDescriptor<ProviderConfig>(predicate: providerPredicate)
        providerDescriptor.fetchLimit = 1

        return try? context.fetch(providerDescriptor).first
    }

    func getDefaultModel() -> ModelConfig? {
        guard let context = modelContext else { return nil }

        let descriptor = FetchDescriptor<ModelConfig>(
            predicate: #Predicate<ModelConfig> { $0.isDefault == true }
        )

        return try? context.fetch(descriptor).first
    }

    // MARK: - Keychain API Key Management

    func saveApiKey(_ key: String, for providerId: String) {
        guard let data = key.data(using: .utf8) else { return }

        // Delete existing entry first
        deleteApiKey(for: providerId)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Self.keychainService,
            kSecAttrAccount as String: providerId,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
        ]

        SecItemAdd(query as CFDictionary, nil)
    }

    func getApiKey(for providerId: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Self.keychainService,
            kSecAttrAccount as String: providerId,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func deleteApiKey(for providerId: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Self.keychainService,
            kSecAttrAccount as String: providerId,
        ]

        SecItemDelete(query as CFDictionary)
    }

    // MARK: - Multi-key Support

    func addApiKey(_ key: String, for providerId: String, label: String) {
        let compositeAccount = "\(providerId):\(label)"
        guard let data = key.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Self.keychainService,
            kSecAttrAccount as String: compositeAccount,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
        ]

        SecItemAdd(query as CFDictionary, nil)
    }

    func rotateApiKey(for providerId: String) -> String? {
        // TODO: Implement key rotation logic
        // This would cycle through stored keys for the provider
        // and update the active key reference
        _ = providerId
        return nil
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
