import Foundation
import SwiftData

// MARK: - Import Errors

enum CrossPlatformImportError: LocalizedError {
    case invalidJSON(underlying: Error)
    case missingRequiredField(model: String, field: String)
    case typeMismatch(model: String, field: String, expected: String, actual: String)
    case unsupportedBackupType(String)

    var errorDescription: String? {
        switch self {
        case .invalidJSON(let underlying):
            return "Invalid JSON data: \(underlying.localizedDescription)"
        case .missingRequiredField(let model, let field):
            return "Missing required field '\(field)' in \(model)"
        case .typeMismatch(let model, let field, let expected, let actual):
            return "Type mismatch for '\(field)' in \(model): expected \(expected), got \(actual)"
        case .unsupportedBackupType(let type):
            return "Unsupported backup type: '\(type)'"
        }
    }
}

// MARK: - CrossPlatformImporter

/// Handles importing data from Flutter (JSON) format into SwiftData models.
///
/// Flutter uses specific JSON field names that may differ from Swift model property names.
/// This importer handles all field mapping, type conversion, and default value assignment.
struct CrossPlatformImporter {

    // MARK: - InstructionInjection

    /// Import InstructionInjection items from Flutter JSON format.
    ///
    /// Flutter JSON fields: `id`, `title`, `prompt`, `group`
    /// Swift model fields: `id`, `name`, `content`, `groupId`, `isEnabled`, `sortOrder`
    ///
    /// - Parameters:
    ///   - jsonData: JSON data as an array of InstructionInjection objects.
    ///   - context: The SwiftData model context to insert into.
    /// - Returns: The imported InstructionInjection models.
    /// - Throws: `CrossPlatformImportError` if the JSON is malformed.
    static func importInstructionInjections(
        from jsonData: Data,
        context: ModelContext
    ) throws -> [InstructionInjection] {
        let dtos: [InstructionInjectionDTO] = try decodeArray(from: jsonData, modelName: "InstructionInjection")
        let models = dtos.map { $0.toModel() }
        for model in models {
            context.insert(model)
        }
        return models
    }

    // MARK: - AssistantMemory

    /// Import AssistantMemory items from Flutter JSON format.
    ///
    /// Flutter JSON fields: `id` (int), `assistantId`, `content`
    /// Swift model fields: `id` (String), `assistantId`, `content`, `createdAt`
    ///
    /// - Parameters:
    ///   - jsonData: JSON data as an array of AssistantMemory objects.
    ///   - context: The SwiftData model context to insert into.
    /// - Returns: The imported AssistantMemory models.
    /// - Throws: `CrossPlatformImportError` if the JSON is malformed.
    static func importAssistantMemories(
        from jsonData: Data,
        context: ModelContext
    ) throws -> [AssistantMemory] {
        let dtos: [AssistantMemoryDTO] = try decodeArray(from: jsonData, modelName: "AssistantMemory")
        let models = dtos.map { $0.toModel() }
        for model in models {
            context.insert(model)
        }
        return models
    }

    // MARK: - WorldBookEntry

    /// Import WorldBook entries from Flutter JSON format.
    ///
    /// Flutter has a `WorldBook` container model with `entries` array. This method
    /// accepts both formats:
    /// - An array of `WorldBook` containers (each with an `entries` array) -- flattened
    /// - An array of `WorldBookEntry` objects directly
    ///
    /// Flutter enum values use UPPER_SNAKE_CASE (e.g. `AFTER_SYSTEM_PROMPT`),
    /// while Swift uses camelCase raw values. The DTO handles conversion.
    ///
    /// Flutter uses `enabled` (bool); Swift uses `isEnabled` (bool).
    ///
    /// - Parameters:
    ///   - jsonData: JSON data as an array of WorldBook containers or WorldBookEntry objects.
    ///   - context: The SwiftData model context to insert into.
    /// - Returns: The imported WorldBookEntry models.
    /// - Throws: `CrossPlatformImportError` if the JSON is malformed.
    static func importWorldBookEntries(
        from jsonData: Data,
        context: ModelContext
    ) throws -> [WorldBookEntry] {
        let rawArray: [[String: Any]]
        do {
            guard let array = try JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
                throw CrossPlatformImportError.invalidJSON(
                    underlying: NSError(domain: "CrossPlatformImporter", code: 0,
                                        userInfo: [NSLocalizedDescriptionKey: "Expected JSON array"])
                )
            }
            rawArray = array
        } catch let error as CrossPlatformImportError {
            throw error
        } catch {
            throw CrossPlatformImportError.invalidJSON(underlying: error)
        }

        // Detect format: WorldBook container (has "entries" key) vs flat WorldBookEntry
        var flatEntries: [[String: Any]] = []
        for item in rawArray {
            if let entries = item["entries"] as? [[String: Any]] {
                // WorldBook container -- flatten entries, inheriting container-level enabled state
                let containerEnabled = item["enabled"] as? Bool ?? true
                for var entry in entries {
                    // If the container is disabled, override entry enabled state
                    if !containerEnabled {
                        entry["enabled"] = false
                    }
                    flatEntries.append(entry)
                }
            } else {
                // Direct WorldBookEntry
                flatEntries.append(item)
            }
        }

        // Re-serialize to Data for DTO decoding
        let flatData = try JSONSerialization.data(withJSONObject: flatEntries)
        let dtos: [FlutterWorldBookEntryDTO] = try decodeArray(from: flatData, modelName: "WorldBookEntry")
        let models = dtos.map { $0.toModel() }
        for model in models {
            context.insert(model)
        }
        return models
    }

    // MARK: - QuickPhrase

    /// Import QuickPhrase items from Flutter JSON format.
    ///
    /// Flutter and Swift share the same field names for the common fields.
    /// Swift-only fields `sortOrder` and `isEnabled` default to 0 and true respectively.
    ///
    /// - Parameters:
    ///   - jsonData: JSON data as an array of QuickPhrase objects.
    ///   - context: The SwiftData model context to insert into.
    /// - Returns: The imported QuickPhrase models.
    /// - Throws: `CrossPlatformImportError` if the JSON is malformed.
    static func importQuickPhrases(
        from jsonData: Data,
        context: ModelContext
    ) throws -> [QuickPhrase] {
        let dtos: [QuickPhraseDTO] = try decodeArray(from: jsonData, modelName: "QuickPhrase")
        let models = dtos.map { $0.toModel() }
        for model in models {
            context.insert(model)
        }
        return models
    }

    // MARK: - Assistant

    /// Import Assistant items from Flutter JSON format.
    ///
    /// Flutter stores `customHeaders` as `[{name, value}]` and `customBody` as `[{key, value}]`.
    /// Swift stores these as JSON strings (`customHeadersJson`, `customBodyJson`).
    /// Flutter stores `presetMessages` as `[{id, role, content}]` and `regexRules` as arrays.
    /// Swift stores these as JSON strings (`presetMessagesJson`, `regexRulesJson`).
    ///
    /// - Parameters:
    ///   - jsonData: JSON data as an array of Assistant objects.
    ///   - context: The SwiftData model context to insert into.
    /// - Returns: The imported Assistant models.
    /// - Throws: `CrossPlatformImportError` if the JSON is malformed.
    static func importAssistants(
        from jsonData: Data,
        context: ModelContext
    ) throws -> [Assistant] {
        let dtos: [FlutterAssistantDTO] = try decodeArray(from: jsonData, modelName: "Assistant")
        let models = dtos.map { $0.toModel() }
        for model in models {
            context.insert(model)
        }
        return models
    }

    // MARK: - BackupConfig

    /// Import BackupConfig from Flutter WebDAV or S3 JSON format.
    ///
    /// Flutter has two separate config classes: `WebDavConfig` and `S3Config`.
    /// This method accepts a JSON object with a `type` field (`"webdav"` or `"s3"`)
    /// to determine which format to parse. If `type` is absent, it auto-detects
    /// based on the presence of S3-specific fields (`bucket`, `accessKeyId`).
    ///
    /// - Parameters:
    ///   - jsonData: JSON data as a single BackupConfig object.
    ///   - context: The SwiftData model context to insert into.
    /// - Returns: The imported BackupConfig model.
    /// - Throws: `CrossPlatformImportError` if the JSON is malformed.
    static func importBackupConfig(
        from jsonData: Data,
        context: ModelContext
    ) throws -> BackupConfig {
        let dto: FlutterBackupConfigDTO = try decodeSingle(from: jsonData, modelName: "BackupConfig")
        let model = dto.toModel()
        context.insert(model)
        return model
    }

    // MARK: - Private Helpers

    private static func decodeArray<T: Decodable>(from data: Data, modelName: String) throws -> [T] {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([T].self, from: data)
        } catch {
            throw CrossPlatformImportError.invalidJSON(underlying: error)
        }
    }

    private static func decodeSingle<T: Decodable>(from data: Data, modelName: String) throws -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw CrossPlatformImportError.invalidJSON(underlying: error)
        }
    }
}

// MARK: - Flutter-specific DTOs for Import

/// DTO for WorldBookEntry that handles Flutter's UPPER_SNAKE_CASE enum values
/// and the `enabled` vs `isEnabled` field name difference.
private struct FlutterWorldBookEntryDTO: Codable {
    let id: String
    let name: String
    let enabled: Bool
    let priority: Int
    let position: String
    let content: String
    let injectDepth: Int
    let role: String
    let keywords: [String]
    let useRegex: Bool
    let caseSensitive: Bool
    let scanDepth: Int
    let constantActive: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, enabled, isEnabled, priority, position, content
        case injectDepth, role, keywords, useRegex, caseSensitive
        case scanDepth, constantActive
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        // Flutter uses "enabled", Swift uses "isEnabled" -- accept both
        enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled)
            ?? container.decodeIfPresent(Bool.self, forKey: .isEnabled)
            ?? true
        priority = try container.decodeIfPresent(Int.self, forKey: .priority) ?? 0
        position = try container.decodeIfPresent(String.self, forKey: .position)
            ?? WorldBookInjectionPosition.afterSystemPrompt.rawValue
        content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
        injectDepth = try container.decodeIfPresent(Int.self, forKey: .injectDepth) ?? 4
        role = try container.decodeIfPresent(String.self, forKey: .role)
            ?? WorldBookInjectionRole.user.rawValue
        keywords = try container.decodeIfPresent([String].self, forKey: .keywords) ?? []
        useRegex = try container.decodeIfPresent(Bool.self, forKey: .useRegex) ?? false
        caseSensitive = try container.decodeIfPresent(Bool.self, forKey: .caseSensitive) ?? false
        scanDepth = try container.decodeIfPresent(Int.self, forKey: .scanDepth) ?? 4
        constantActive = try container.decodeIfPresent(Bool.self, forKey: .constantActive) ?? false
    }

    func encode(to encoder: Encoder) throws {
        // Not needed for import-only DTO, but required by Codable
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(enabled, forKey: .enabled)
        try container.encode(priority, forKey: .priority)
        try container.encode(position, forKey: .position)
        try container.encode(content, forKey: .content)
        try container.encode(injectDepth, forKey: .injectDepth)
        try container.encode(role, forKey: .role)
        try container.encode(keywords, forKey: .keywords)
        try container.encode(useRegex, forKey: .useRegex)
        try container.encode(caseSensitive, forKey: .caseSensitive)
        try container.encode(scanDepth, forKey: .scanDepth)
        try container.encode(constantActive, forKey: .constantActive)
    }

    /// Convert Flutter UPPER_SNAKE_CASE position to Swift camelCase rawValue.
    private static func mapPosition(_ flutterValue: String) -> WorldBookInjectionPosition {
        switch flutterValue.uppercased() {
        case "BEFORE_SYSTEM_PROMPT": return .beforeSystemPrompt
        case "AFTER_SYSTEM_PROMPT": return .afterSystemPrompt
        case "TOP_OF_CHAT": return .topOfChat
        case "BOTTOM_OF_CHAT": return .bottomOfChat
        case "AT_DEPTH": return .atDepth
        default: return .afterSystemPrompt
        }
    }

    /// Convert Flutter UPPER_SNAKE_CASE role to Swift camelCase rawValue.
    private static func mapRole(_ flutterValue: String) -> WorldBookInjectionRole {
        switch flutterValue.uppercased() {
        case "ASSISTANT": return .assistant
        case "USER": return .user
        default: return .user
        }
    }

    func toModel() -> WorldBookEntry {
        WorldBookEntry(
            id: id,
            name: name,
            isEnabled: enabled,
            priority: priority,
            position: Self.mapPosition(position),
            content: content,
            injectDepth: injectDepth,
            role: Self.mapRole(role),
            keywords: keywords.map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty },
            useRegex: useRegex,
            caseSensitive: caseSensitive,
            scanDepth: scanDepth,
            constantActive: constantActive,
            sortOrder: 0
        )
    }
}

/// DTO for Assistant that handles Flutter's nested JSON structures for
/// customHeaders, customBody, presetMessages, and regexRules.
private struct FlutterAssistantDTO: Codable {
    let id: String
    let name: String
    let avatar: String?
    let useAssistantAvatar: Bool
    let useAssistantName: Bool
    let chatModelProvider: String?
    let chatModelId: String?
    let temperature: Double?
    let topP: Double?
    let contextMessageSize: Int
    let limitContextMessages: Bool
    let streamOutput: Bool
    let thinkingBudget: Int?
    let maxTokens: Int?
    let systemPrompt: String
    let messageTemplate: String
    let mcpServerIds: [String]
    let background: String?
    let deletable: Bool
    let customHeaders: [[String: String]]?
    let customBody: [[String: String]]?
    let enableMemory: Bool
    let enableRecentChatsReference: Bool
    let recentChatsSummaryMessageCount: Int
    let presetMessages: [FlutterPresetMessageDTO]?
    let regexRules: [FlutterRegexRuleDTO]?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        useAssistantAvatar = try container.decodeIfPresent(Bool.self, forKey: .useAssistantAvatar) ?? false
        useAssistantName = try container.decodeIfPresent(Bool.self, forKey: .useAssistantName) ?? false
        chatModelProvider = try container.decodeIfPresent(String.self, forKey: .chatModelProvider)
        chatModelId = try container.decodeIfPresent(String.self, forKey: .chatModelId)
        temperature = try container.decodeIfPresent(Double.self, forKey: .temperature)
        topP = try container.decodeIfPresent(Double.self, forKey: .topP)
        contextMessageSize = try container.decodeIfPresent(Int.self, forKey: .contextMessageSize) ?? 64
        limitContextMessages = try container.decodeIfPresent(Bool.self, forKey: .limitContextMessages) ?? true
        streamOutput = try container.decodeIfPresent(Bool.self, forKey: .streamOutput) ?? true
        thinkingBudget = try container.decodeIfPresent(Int.self, forKey: .thinkingBudget)
        maxTokens = try container.decodeIfPresent(Int.self, forKey: .maxTokens)
        systemPrompt = try container.decodeIfPresent(String.self, forKey: .systemPrompt) ?? ""
        messageTemplate = try container.decodeIfPresent(String.self, forKey: .messageTemplate) ?? "{{ message }}"
        mcpServerIds = try container.decodeIfPresent([String].self, forKey: .mcpServerIds) ?? []
        background = try container.decodeIfPresent(String.self, forKey: .background)
        deletable = try container.decodeIfPresent(Bool.self, forKey: .deletable) ?? true
        customHeaders = try container.decodeIfPresent([[String: String]].self, forKey: .customHeaders)
        customBody = try container.decodeIfPresent([[String: String]].self, forKey: .customBody)
        enableMemory = try container.decodeIfPresent(Bool.self, forKey: .enableMemory) ?? false
        enableRecentChatsReference = try container.decodeIfPresent(Bool.self, forKey: .enableRecentChatsReference) ?? false
        let rawCount = try container.decodeIfPresent(Int.self, forKey: .recentChatsSummaryMessageCount)
        recentChatsSummaryMessageCount = (rawCount != nil && rawCount! >= 1) ? rawCount! : Assistant.defaultRecentChatsSummaryMessageCount
        presetMessages = try container.decodeIfPresent([FlutterPresetMessageDTO].self, forKey: .presetMessages)
        regexRules = try container.decodeIfPresent([FlutterRegexRuleDTO].self, forKey: .regexRules)
    }

    func toModel() -> Assistant {
        // Serialize customHeaders to JSON string
        let headersJson: String? = {
            guard let headers = customHeaders, !headers.isEmpty else { return nil }
            guard let data = try? JSONSerialization.data(withJSONObject: headers) else { return nil }
            return String(data: data, encoding: .utf8)
        }()

        // Serialize customBody to JSON string
        let bodyJson: String? = {
            guard let body = customBody, !body.isEmpty else { return nil }
            guard let data = try? JSONSerialization.data(withJSONObject: body) else { return nil }
            return String(data: data, encoding: .utf8)
        }()

        // Serialize presetMessages to JSON string
        let presetsJson: String? = {
            guard let presets = presetMessages, !presets.isEmpty else { return nil }
            let dicts = presets.map { ["id": $0.id, "role": $0.role, "content": $0.content] }
            guard let data = try? JSONSerialization.data(withJSONObject: dicts) else { return nil }
            return String(data: data, encoding: .utf8)
        }()

        // Serialize regexRules to JSON string
        let regexJson: String? = {
            guard let rules = regexRules, !rules.isEmpty else { return nil }
            let dicts: [[String: Any]] = rules.map {
                var dict: [String: Any] = [
                    "id": $0.id,
                    "name": $0.name,
                    "pattern": $0.pattern,
                    "replacement": $0.replacement,
                    "scopes": $0.scopes,
                    "visualOnly": $0.visualOnly,
                    "replaceOnly": $0.replaceOnly,
                    "enabled": $0.enabled,
                ]
                return dict
            }
            guard let data = try? JSONSerialization.data(withJSONObject: dicts) else { return nil }
            return String(data: data, encoding: .utf8)
        }()

        return Assistant(
            id: id,
            name: name,
            avatar: avatar,
            useAssistantAvatar: useAssistantAvatar,
            useAssistantName: useAssistantName,
            chatModelProvider: chatModelProvider,
            chatModelId: chatModelId,
            temperature: temperature,
            topP: topP,
            contextMessageSize: contextMessageSize,
            limitContextMessages: limitContextMessages,
            streamOutput: streamOutput,
            thinkingBudget: thinkingBudget,
            maxTokens: maxTokens,
            systemPrompt: systemPrompt,
            messageTemplate: messageTemplate,
            mcpServerIds: mcpServerIds,
            background: background,
            deletable: deletable,
            customHeadersJson: headersJson,
            customBodyJson: bodyJson,
            enableMemory: enableMemory,
            enableRecentChatsReference: enableRecentChatsReference,
            recentChatsSummaryMessageCount: recentChatsSummaryMessageCount,
            presetMessagesJson: presetsJson,
            regexRulesJson: regexJson
        )
    }
}

/// DTO for Flutter PresetMessage used within FlutterAssistantDTO.
private struct FlutterPresetMessageDTO: Codable {
    let id: String
    let role: String
    let content: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        let rawRole = try container.decodeIfPresent(String.self, forKey: .role) ?? "user"
        role = rawRole == "assistant" ? "assistant" : "user"
        content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
    }
}

/// DTO for Flutter AssistantRegex used within FlutterAssistantDTO.
private struct FlutterRegexRuleDTO: Codable {
    let id: String
    let name: String
    let pattern: String
    let replacement: String
    let scopes: [String]
    let visualOnly: Bool
    let replaceOnly: Bool
    let enabled: Bool

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        pattern = try container.decodeIfPresent(String.self, forKey: .pattern) ?? ""
        replacement = try container.decodeIfPresent(String.self, forKey: .replacement) ?? ""
        scopes = try container.decodeIfPresent([String].self, forKey: .scopes) ?? []
        visualOnly = try container.decodeIfPresent(Bool.self, forKey: .visualOnly) ?? false
        let rawReplaceOnly = try container.decodeIfPresent(Bool.self, forKey: .replaceOnly) ?? false
        // Match Flutter logic: visualOnly and replaceOnly cannot both be true
        replaceOnly = (visualOnly && rawReplaceOnly) ? false : rawReplaceOnly
        enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled) ?? true
    }
}

/// DTO for BackupConfig that handles Flutter's separate WebDavConfig and S3Config.
///
/// Accepts a JSON object with an optional `type` field (`"webdav"` or `"s3"`).
/// If `type` is absent, auto-detects based on S3-specific fields.
///
/// Flutter WebDavConfig JSON: `url`, `username`, `password`, `path`, `includeChats`, `includeFiles`
/// Flutter S3Config JSON: `endpoint`, `region`, `bucket`, `accessKeyId`, `secretAccessKey`,
///                        `sessionToken`, `prefix`, `pathStyle`, `includeChats`, `includeFiles`
private struct FlutterBackupConfigDTO: Codable {
    // Type discriminator
    let type: String?

    // WebDAV fields
    let url: String?
    let username: String?
    let password: String?
    let path: String?

    // S3 fields
    let endpoint: String?
    let region: String?
    let bucket: String?
    let accessKeyId: String?
    let secretAccessKey: String?
    let sessionToken: String?
    let prefix: String?
    let pathStyle: Bool?

    // Common fields
    let includeChats: Bool?
    let includeFiles: Bool?

    func toModel() -> BackupConfig {
        let isS3 = detectIsS3()

        if isS3 {
            return BackupConfig(
                backupType: .s3,
                url: "",
                username: "",
                path: "",
                s3Bucket: bucket?.trimmingCharacters(in: .whitespaces) ?? "",
                s3Region: {
                    let r = region?.trimmingCharacters(in: .whitespaces) ?? ""
                    return r.isEmpty ? "us-east-1" : r
                }(),
                s3Endpoint: endpoint?.trimmingCharacters(in: .whitespaces) ?? "",
                s3PathStyle: pathStyle ?? true,
                includeChats: includeChats ?? true,
                includeFiles: includeFiles ?? true
            )
        } else {
            return BackupConfig(
                backupType: .webdav,
                url: url?.trimmingCharacters(in: .whitespaces) ?? "",
                username: username?.trimmingCharacters(in: .whitespaces) ?? "",
                path: {
                    let p = path?.trimmingCharacters(in: .whitespaces) ?? ""
                    return p.isEmpty ? "kelivo_backups" : p
                }(),
                includeChats: includeChats ?? true,
                includeFiles: includeFiles ?? true
            )
        }
    }

    private func detectIsS3() -> Bool {
        if let type = type?.lowercased() {
            return type == "s3"
        }
        // Auto-detect: if S3-specific fields are present, treat as S3
        if bucket != nil || accessKeyId != nil || endpoint != nil {
            return true
        }
        return false
    }
}
