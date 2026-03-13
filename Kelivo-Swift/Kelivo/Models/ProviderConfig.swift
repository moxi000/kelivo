import Foundation
import SwiftData

enum ApiType: String, Codable, CaseIterable {
    case openai
    case claude
    case gemini
    case vertex
}

@Model
final class ProviderConfig {
    @Attribute(.unique) var id: String
    var name: String
    var apiTypeRaw: String
    var baseUrl: String
    var isEnabled: Bool
    var sortOrder: Int
    var customHeadersJson: String?
    var groupId: String?

    /// Typed access to API type.
    var apiType: ApiType {
        get { ApiType(rawValue: apiTypeRaw) ?? .openai }
        set { apiTypeRaw = newValue.rawValue }
    }

    /// API key is stored in Keychain. This property holds a reference key
    /// for Keychain lookup, not the actual secret.
    var apiKeyRef: String?

    @Relationship(deleteRule: .cascade, inverse: \ModelConfig.provider)
    var models: [ModelConfig] = []

    init(
        id: String = UUID().uuidString,
        name: String,
        apiType: ApiType = .openai,
        baseUrl: String = "",
        apiKeyRef: String? = nil,
        isEnabled: Bool = true,
        sortOrder: Int = 0,
        customHeadersJson: String? = nil,
        groupId: String? = nil,
        models: [ModelConfig] = []
    ) {
        self.id = id
        self.name = name
        self.apiTypeRaw = apiType.rawValue
        self.baseUrl = baseUrl
        self.apiKeyRef = apiKeyRef
        self.isEnabled = isEnabled
        self.sortOrder = sortOrder
        self.customHeadersJson = customHeadersJson
        self.groupId = groupId
        self.models = models
    }
}
