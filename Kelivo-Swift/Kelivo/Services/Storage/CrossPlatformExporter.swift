import Foundation
import SwiftData

// MARK: - Export Errors

enum CrossPlatformExportError: LocalizedError {
    case serializationFailed(model: String, underlying: Error)

    var errorDescription: String? {
        switch self {
        case .serializationFailed(let model, let underlying):
            return "Failed to serialize \(model) to JSON: \(underlying.localizedDescription)"
        }
    }
}

// MARK: - CrossPlatformExporter

/// Handles exporting SwiftData models to Flutter-compatible JSON format.
///
/// All exported JSON uses Flutter's field naming conventions so that the data
/// can be directly consumed by Flutter's `fromJson` constructors.
struct CrossPlatformExporter {

    // MARK: - InstructionInjection

    /// Export InstructionInjection items to Flutter JSON format.
    ///
    /// Output fields: `id`, `title`, `prompt`, `group`
    /// (Flutter field names, not Swift model property names)
    ///
    /// - Parameter items: The InstructionInjection models to export.
    /// - Returns: JSON data as an array of objects.
    /// - Throws: `CrossPlatformExportError` if serialization fails.
    static func exportInstructionInjections(_ items: [InstructionInjection]) throws -> Data {
        let dicts: [[String: Any]] = items.map { item in
            [
                "id": item.id,
                "title": item.name,
                "prompt": item.content,
                "group": item.groupId,
            ]
        }
        return try serializeArray(dicts, modelName: "InstructionInjection")
    }

    // MARK: - AssistantMemory

    /// Export AssistantMemory items to Flutter JSON format.
    ///
    /// Output fields: `id` (int if possible, else string), `assistantId`, `content`
    /// Flutter expects `id` as int for auto-increment compatibility.
    ///
    /// - Parameter items: The AssistantMemory models to export.
    /// - Returns: JSON data as an array of objects.
    /// - Throws: `CrossPlatformExportError` if serialization fails.
    static func exportAssistantMemories(_ items: [AssistantMemory]) throws -> Data {
        let dicts: [[String: Any]] = items.map { item in
            var dict: [String: Any] = [
                "assistantId": item.assistantId,
                "content": item.content,
            ]
            // Flutter uses int id; encode as int if the string is a pure integer
            if let intId = Int(item.id) {
                dict["id"] = intId
            } else {
                dict["id"] = item.id
            }
            return dict
        }
        return try serializeArray(dicts, modelName: "AssistantMemory")
    }

    // MARK: - WorldBookEntry

    /// Export WorldBookEntry items to Flutter WorldBook container JSON format.
    ///
    /// Flutter expects a `WorldBook` container with `entries` array.
    /// All entries are wrapped in a single WorldBook container.
    ///
    /// Enum values are converted to UPPER_SNAKE_CASE to match Flutter format.
    /// Swift `isEnabled` maps to Flutter `enabled`.
    ///
    /// - Parameter entries: The WorldBookEntry models to export.
    /// - Returns: JSON data as an array containing one WorldBook container.
    /// - Throws: `CrossPlatformExportError` if serialization fails.
    static func exportWorldBookEntries(_ entries: [WorldBookEntry]) throws -> Data {
        let entryDicts: [[String: Any]] = entries.map { entry in
            [
                "id": entry.id,
                "name": entry.name,
                "enabled": entry.isEnabled,
                "priority": entry.priority,
                "position": mapPositionToFlutter(entry.position),
                "content": entry.content,
                "injectDepth": entry.injectDepth,
                "role": mapRoleToFlutter(entry.role),
                "keywords": entry.keywords,
                "useRegex": entry.useRegex,
                "caseSensitive": entry.caseSensitive,
                "scanDepth": entry.scanDepth,
                "constantActive": entry.constantActive,
            ]
        }

        let worldBook: [String: Any] = [
            "id": UUID().uuidString,
            "name": "",
            "description": "",
            "enabled": true,
            "entries": entryDicts,
        ]
        return try serializeArray([worldBook], modelName: "WorldBookEntry")
    }

    // MARK: - QuickPhrase

    /// Export QuickPhrase items to Flutter JSON format.
    ///
    /// Output fields: `id`, `title`, `content`, `isGlobal`, `assistantId`
    ///
    /// - Parameter items: The QuickPhrase models to export.
    /// - Returns: JSON data as an array of objects.
    /// - Throws: `CrossPlatformExportError` if serialization fails.
    static func exportQuickPhrases(_ items: [QuickPhrase]) throws -> Data {
        let dicts: [[String: Any?]] = items.map { item in
            [
                "id": item.id,
                "title": item.title,
                "content": item.content,
                "isGlobal": item.isGlobal,
                "assistantId": item.assistantId,
            ]
        }
        return try serializeArray(dicts, modelName: "QuickPhrase")
    }

    // MARK: - BackupConfig

    /// Export BackupConfig to Flutter WebDAV or S3 JSON format.
    ///
    /// Exports as a single JSON object with a `type` discriminator field.
    /// For WebDAV: outputs `url`, `username`, `password`, `path`, `includeChats`, `includeFiles`
    /// For S3: outputs `endpoint`, `region`, `bucket`, `accessKeyId`, `secretAccessKey`,
    ///         `sessionToken`, `prefix`, `pathStyle`, `includeChats`, `includeFiles`
    ///
    /// Note: Sensitive fields (`password`, `accessKeyId`, `secretAccessKey`, `sessionToken`)
    /// are exported as empty strings. Credentials must be handled separately via secure channels.
    ///
    /// - Parameter config: The BackupConfig model to export.
    /// - Returns: JSON data as a single object.
    /// - Throws: `CrossPlatformExportError` if serialization fails.
    static func exportBackupConfig(_ config: BackupConfig) throws -> Data {
        let dict: [String: Any]

        switch config.backupType {
        case .webdav:
            dict = [
                "type": "webdav",
                "url": config.url,
                "username": config.username,
                "password": "",
                "path": config.path,
                "includeChats": config.includeChats,
                "includeFiles": config.includeFiles,
            ]
        case .s3:
            dict = [
                "type": "s3",
                "endpoint": config.s3Endpoint,
                "region": config.s3Region,
                "bucket": config.s3Bucket,
                "accessKeyId": "",
                "secretAccessKey": "",
                "sessionToken": "",
                "prefix": config.path,
                "pathStyle": config.s3PathStyle,
                "includeChats": config.includeChats,
                "includeFiles": config.includeFiles,
            ]
        }

        return try serializeSingle(dict, modelName: "BackupConfig")
    }

    // MARK: - Assistant

    /// Export Assistant items to Flutter JSON format.
    ///
    /// Converts Swift's JSON-string stored fields (`customHeadersJson`, `customBodyJson`,
    /// `presetMessagesJson`, `regexRulesJson`) back to nested JSON arrays.
    ///
    /// - Parameter items: The Assistant models to export.
    /// - Returns: JSON data as an array of objects.
    /// - Throws: `CrossPlatformExportError` if serialization fails.
    static func exportAssistants(_ items: [Assistant]) throws -> Data {
        let dicts: [[String: Any?]] = items.map { item in
            // Deserialize customHeaders from JSON string
            let customHeaders: Any = {
                guard let json = item.customHeadersJson,
                      let data = json.data(using: .utf8),
                      let parsed = try? JSONSerialization.jsonObject(with: data) else {
                    return [] as [[String: String]]
                }
                return parsed
            }()

            // Deserialize customBody from JSON string
            let customBody: Any = {
                guard let json = item.customBodyJson,
                      let data = json.data(using: .utf8),
                      let parsed = try? JSONSerialization.jsonObject(with: data) else {
                    return [] as [[String: String]]
                }
                return parsed
            }()

            // Deserialize presetMessages from JSON string
            let presetMessages: Any = {
                guard let json = item.presetMessagesJson,
                      let data = json.data(using: .utf8),
                      let parsed = try? JSONSerialization.jsonObject(with: data) else {
                    return [] as [[String: String]]
                }
                return parsed
            }()

            // Deserialize regexRules from JSON string
            let regexRules: Any = {
                guard let json = item.regexRulesJson,
                      let data = json.data(using: .utf8),
                      let parsed = try? JSONSerialization.jsonObject(with: data) else {
                    return [] as [[String: Any]]
                }
                return parsed
            }()

            return [
                "id": item.id,
                "name": item.name,
                "avatar": item.avatar,
                "useAssistantAvatar": item.useAssistantAvatar,
                "useAssistantName": item.useAssistantName,
                "chatModelProvider": item.chatModelProvider,
                "chatModelId": item.chatModelId,
                "temperature": item.temperature,
                "topP": item.topP,
                "contextMessageSize": item.contextMessageSize,
                "limitContextMessages": item.limitContextMessages,
                "streamOutput": item.streamOutput,
                "thinkingBudget": item.thinkingBudget,
                "maxTokens": item.maxTokens,
                "systemPrompt": item.systemPrompt,
                "messageTemplate": item.messageTemplate,
                "mcpServerIds": item.mcpServerIds,
                "background": item.background,
                "deletable": item.deletable,
                "customHeaders": customHeaders,
                "customBody": customBody,
                "enableMemory": item.enableMemory,
                "enableRecentChatsReference": item.enableRecentChatsReference,
                "recentChatsSummaryMessageCount": item.recentChatsSummaryMessageCount,
                "presetMessages": presetMessages,
                "regexRules": regexRules,
            ]
        }
        return try serializeArray(dicts, modelName: "Assistant")
    }

    // MARK: - Private Helpers

    /// Convert Swift WorldBookInjectionPosition to Flutter UPPER_SNAKE_CASE string.
    private static func mapPositionToFlutter(_ position: WorldBookInjectionPosition) -> String {
        switch position {
        case .beforeSystemPrompt: return "BEFORE_SYSTEM_PROMPT"
        case .afterSystemPrompt: return "AFTER_SYSTEM_PROMPT"
        case .topOfChat: return "TOP_OF_CHAT"
        case .bottomOfChat: return "BOTTOM_OF_CHAT"
        case .atDepth: return "AT_DEPTH"
        }
    }

    /// Convert Swift WorldBookInjectionRole to Flutter UPPER_SNAKE_CASE string.
    private static func mapRoleToFlutter(_ role: WorldBookInjectionRole) -> String {
        switch role {
        case .user: return "USER"
        case .assistant: return "ASSISTANT"
        }
    }

    private static func serializeArray(_ array: Any, modelName: String) throws -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted, .sortedKeys])
        } catch {
            throw CrossPlatformExportError.serializationFailed(model: modelName, underlying: error)
        }
    }

    private static func serializeSingle(_ dict: [String: Any], modelName: String) throws -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted, .sortedKeys])
        } catch {
            throw CrossPlatformExportError.serializationFailed(model: modelName, underlying: error)
        }
    }
}
