import Foundation
import SwiftData

enum AssistantRegexScope: String, Codable {
    case user
    case assistant
}

@Model
final class AssistantRegex {
    @Attribute(.unique) var id: String
    var assistantId: String
    var name: String
    var pattern: String
    var replacement: String
    var scopesRaw: [String]
    var visualOnly: Bool
    var replaceOnly: Bool
    var isEnabled: Bool

    /// Typed access to scopes.
    var scopes: [AssistantRegexScope] {
        get { scopesRaw.compactMap { AssistantRegexScope(rawValue: $0) } }
        set { scopesRaw = newValue.map(\.rawValue) }
    }

    init(
        id: String = UUID().uuidString,
        assistantId: String,
        name: String = "",
        pattern: String,
        replacement: String,
        scopes: [AssistantRegexScope] = [],
        visualOnly: Bool = false,
        replaceOnly: Bool = false,
        isEnabled: Bool = true
    ) {
        self.id = id
        self.assistantId = assistantId
        self.name = name
        self.pattern = pattern
        self.replacement = replacement
        self.scopesRaw = scopes.map(\.rawValue)
        self.visualOnly = visualOnly
        self.replaceOnly = replaceOnly
        self.isEnabled = isEnabled
    }
}

// MARK: - Cross-platform Compatibility

/// Portable representation for cross-platform JSON import/export.
/// Flutter lacks `assistantId` (defaults to "" on import; caller must supplement).
/// Flutter uses `enabled` instead of `isEnabled`.
/// Flutter uses `scopes` as `[String]`; Swift uses `scopesRaw`.
struct AssistantRegexDTO: Codable {
    let id: String
    let assistantId: String
    let name: String
    let pattern: String
    let replacement: String
    let scopes: [String]
    let visualOnly: Bool
    let replaceOnly: Bool
    let isEnabled: Bool

    enum CodingKeys: String, CodingKey {
        case id, assistantId, name, pattern, replacement, scopes
        case visualOnly, replaceOnly, isEnabled, enabled
    }

    init(from model: AssistantRegex) {
        self.id = model.id
        self.assistantId = model.assistantId
        self.name = model.name
        self.pattern = model.pattern
        self.replacement = model.replacement
        self.scopes = model.scopesRaw
        self.visualOnly = model.visualOnly
        self.replaceOnly = model.replaceOnly
        self.isEnabled = model.isEnabled
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        assistantId = try container.decodeIfPresent(String.self, forKey: .assistantId) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        pattern = try container.decodeIfPresent(String.self, forKey: .pattern) ?? ""
        replacement = try container.decodeIfPresent(String.self, forKey: .replacement) ?? ""
        scopes = try container.decodeIfPresent([String].self, forKey: .scopes) ?? []
        visualOnly = try container.decodeIfPresent(Bool.self, forKey: .visualOnly) ?? false
        let rawReplaceOnly = try container.decodeIfPresent(Bool.self, forKey: .replaceOnly) ?? false
        // Match Flutter logic: visualOnly and replaceOnly cannot both be true
        replaceOnly = (visualOnly && rawReplaceOnly) ? false : rawReplaceOnly
        // Accept both "isEnabled" (Swift) and "enabled" (Flutter)
        isEnabled = try container.decodeIfPresent(Bool.self, forKey: .isEnabled)
            ?? container.decodeIfPresent(Bool.self, forKey: .enabled)
            ?? true
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(assistantId, forKey: .assistantId)
        try container.encode(name, forKey: .name)
        try container.encode(pattern, forKey: .pattern)
        try container.encode(replacement, forKey: .replacement)
        try container.encode(scopes, forKey: .scopes)
        try container.encode(visualOnly, forKey: .visualOnly)
        try container.encode(replaceOnly, forKey: .replaceOnly)
        // Export both keys for maximum compatibility
        try container.encode(isEnabled, forKey: .isEnabled)
        try container.encode(isEnabled, forKey: .enabled)
    }

    func toModel() -> AssistantRegex {
        AssistantRegex(
            id: id,
            assistantId: assistantId,
            name: name,
            pattern: pattern,
            replacement: replacement,
            scopes: scopes.compactMap { AssistantRegexScope(rawValue: $0) },
            visualOnly: visualOnly,
            replaceOnly: replaceOnly,
            isEnabled: isEnabled
        )
    }
}
