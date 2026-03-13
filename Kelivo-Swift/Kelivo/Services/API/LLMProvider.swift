import Foundation

// MARK: - API Type

enum APIType: String, Codable, Sendable, CaseIterable {
    case openaiChatCompletions
    case openaiResponses
    case claude
    case gemini
    case vertex
}

// MARK: - LLM Provider Protocol

protocol LLMProvider: Sendable {
    var id: String { get }
    var name: String { get }
    var apiType: APIType { get }

    func sendMessage(
        messages: [MessagePayload],
        model: String,
        parameters: ModelParameters,
        tools: [ToolDefinition]?
    ) -> AsyncThrowingStream<ChatStreamChunk, Error>

    func fetchModels(baseUrl: String, apiKey: String) async throws -> [RemoteModel]
}

// MARK: - Message Types

struct MessagePayload: Sendable, Codable {
    let role: String
    let content: MessageContent
}

enum MessageContent: Sendable, Codable {
    case text(String)
    case parts([ContentPart])

    // MARK: Codable

    private enum CodingKeys: String, CodingKey {
        case type
        case text
        case parts
    }

    init(from decoder: Decoder) throws {
        // Try single string first
        if let container = try? decoder.singleValueContainer(),
            let text = try? container.decode(String.self)
        {
            self = .text(text)
            return
        }
        // Try keyed container
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let text = try? container.decode(String.self, forKey: .text) {
            self = .text(text)
        } else if let parts = try? container.decode([ContentPart].self, forKey: .parts) {
            self = .parts(parts)
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Cannot decode MessageContent"
                ))
        }
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case .text(let string):
            var container = encoder.singleValueContainer()
            try container.encode(string)
        case .parts(let parts):
            var container = encoder.singleValueContainer()
            try container.encode(parts)
        }
    }
}

enum ContentPart: Sendable, Codable {
    case text(String)
    case image(data: Data, mimeType: String)

    private enum CodingKeys: String, CodingKey {
        case type
        case text
        case data
        case mimeType = "mime_type"
    }

    private enum PartType: String, Codable {
        case text
        case image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(PartType.self, forKey: .type)
        switch type {
        case .text:
            let text = try container.decode(String.self, forKey: .text)
            self = .text(text)
        case .image:
            let data = try container.decode(Data.self, forKey: .data)
            let mimeType = try container.decode(String.self, forKey: .mimeType)
            self = .image(data: data, mimeType: mimeType)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .text(let text):
            try container.encode(PartType.text, forKey: .type)
            try container.encode(text, forKey: .text)
        case .image(let data, let mimeType):
            try container.encode(PartType.image, forKey: .type)
            try container.encode(data, forKey: .data)
            try container.encode(mimeType, forKey: .mimeType)
        }
    }
}

// MARK: - Model Parameters

struct ModelParameters: Sendable {
    var temperature: Double?
    var topP: Double?
    var maxTokens: Int?
    var frequencyPenalty: Double?
    var presencePenalty: Double?
    var reasoningBudget: Int?

    init(
        temperature: Double? = nil,
        topP: Double? = nil,
        maxTokens: Int? = nil,
        frequencyPenalty: Double? = nil,
        presencePenalty: Double? = nil,
        reasoningBudget: Int? = nil
    ) {
        self.temperature = temperature
        self.topP = topP
        self.maxTokens = maxTokens
        self.frequencyPenalty = frequencyPenalty
        self.presencePenalty = presencePenalty
        self.reasoningBudget = reasoningBudget
    }
}

// MARK: - Stream Chunk

struct ChatStreamChunk: Sendable {
    let id: String?
    let content: String?
    let reasoningContent: String?
    let toolCalls: [ToolCall]?
    let finishReason: String?
    let usage: UsageInfo?

    init(
        id: String? = nil,
        content: String? = nil,
        reasoningContent: String? = nil,
        toolCalls: [ToolCall]? = nil,
        finishReason: String? = nil,
        usage: UsageInfo? = nil
    ) {
        self.id = id
        self.content = content
        self.reasoningContent = reasoningContent
        self.toolCalls = toolCalls
        self.finishReason = finishReason
        self.usage = usage
    }
}

// MARK: - Tool Types

struct ToolCall: Sendable, Codable {
    let id: String
    let name: String
    let arguments: String
}

struct ToolDefinition: Sendable, Codable {
    let name: String
    let description: String
    let parameters: JSONSchema
}

/// A lightweight JSON Schema representation for tool parameter definitions.
struct JSONSchema: Sendable, Codable {
    let type: String
    let properties: [String: JSONSchemaProperty]?
    let required: [String]?
    let description: String?

    init(
        type: String = "object",
        properties: [String: JSONSchemaProperty]? = nil,
        required: [String]? = nil,
        description: String? = nil
    ) {
        self.type = type
        self.properties = properties
        self.required = required
        self.description = description
    }
}

struct JSONSchemaProperty: Sendable, Codable {
    let type: String
    let description: String?
    let enumValues: [String]?
    let items: JSONSchemaProperty?

    private enum CodingKeys: String, CodingKey {
        case type
        case description
        case enumValues = "enum"
        case items
    }

    init(
        type: String,
        description: String? = nil,
        enumValues: [String]? = nil,
        items: JSONSchemaProperty? = nil
    ) {
        self.type = type
        self.description = description
        self.enumValues = enumValues
        self.items = items
    }
}

// MARK: - Usage Info

struct UsageInfo: Sendable {
    let promptTokens: Int?
    let completionTokens: Int?
    let totalTokens: Int?

    init(
        promptTokens: Int? = nil,
        completionTokens: Int? = nil,
        totalTokens: Int? = nil
    ) {
        self.promptTokens = promptTokens
        self.completionTokens = completionTokens
        self.totalTokens = totalTokens
    }
}

// MARK: - Remote Model

struct RemoteModel: Sendable {
    let id: String
    let displayName: String
    let contextWindow: Int?
    let maxOutputTokens: Int?

    init(
        id: String,
        displayName: String,
        contextWindow: Int? = nil,
        maxOutputTokens: Int? = nil
    ) {
        self.id = id
        self.displayName = displayName
        self.contextWindow = contextWindow
        self.maxOutputTokens = maxOutputTokens
    }
}
