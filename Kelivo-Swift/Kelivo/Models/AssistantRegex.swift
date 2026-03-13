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
