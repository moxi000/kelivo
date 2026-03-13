import Foundation
import SwiftData

@Model
final class ModelConfig {
    @Attribute(.unique) var id: String
    var providerId: String
    var modelId: String
    var displayName: String
    var isEnabled: Bool
    var isDefault: Bool
    var maxContextTokens: Int?
    var maxOutputTokens: Int?
    var supportsVision: Bool
    var supportsTools: Bool
    var supportsReasoning: Bool
    var sortOrder: Int

    var provider: ProviderConfig?

    init(
        id: String = UUID().uuidString,
        providerId: String,
        modelId: String,
        displayName: String = "",
        isEnabled: Bool = true,
        isDefault: Bool = false,
        maxContextTokens: Int? = nil,
        maxOutputTokens: Int? = nil,
        supportsVision: Bool = false,
        supportsTools: Bool = false,
        supportsReasoning: Bool = false,
        sortOrder: Int = 0
    ) {
        self.id = id
        self.providerId = providerId
        self.modelId = modelId
        self.displayName = displayName
        self.isEnabled = isEnabled
        self.isDefault = isDefault
        self.maxContextTokens = maxContextTokens
        self.maxOutputTokens = maxOutputTokens
        self.supportsVision = supportsVision
        self.supportsTools = supportsTools
        self.supportsReasoning = supportsReasoning
        self.sortOrder = sortOrder
    }
}
