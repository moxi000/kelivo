import Foundation
import SwiftData

@Model
final class Assistant {
    static let defaultRecentChatsSummaryMessageCount = 5
    static let defaultContextMessageSize = 64

    @Attribute(.unique) var id: String
    var name: String
    var avatar: String?
    var useAssistantAvatar: Bool
    var useAssistantName: Bool
    var chatModelProvider: String?
    var chatModelId: String?
    var temperature: Double?
    var topP: Double?
    var contextMessageSize: Int
    var limitContextMessages: Bool
    var streamOutput: Bool
    var thinkingBudget: Int?
    var maxTokens: Int?
    var systemPrompt: String
    var messageTemplate: String
    var mcpServerIds: [String]
    var background: String?
    var deletable: Bool
    var customHeadersJson: String?
    var customBodyJson: String?
    var enableMemory: Bool
    var enableRecentChatsReference: Bool
    var recentChatsSummaryMessageCount: Int
    var presetMessagesJson: String?
    var regexRulesJson: String?

    init(
        id: String = UUID().uuidString,
        name: String,
        avatar: String? = nil,
        useAssistantAvatar: Bool = false,
        useAssistantName: Bool = false,
        chatModelProvider: String? = nil,
        chatModelId: String? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        contextMessageSize: Int = 64,
        limitContextMessages: Bool = true,
        streamOutput: Bool = true,
        thinkingBudget: Int? = nil,
        maxTokens: Int? = nil,
        systemPrompt: String = "",
        messageTemplate: String = "{{ message }}",
        mcpServerIds: [String] = [],
        background: String? = nil,
        deletable: Bool = true,
        customHeadersJson: String? = nil,
        customBodyJson: String? = nil,
        enableMemory: Bool = false,
        enableRecentChatsReference: Bool = false,
        recentChatsSummaryMessageCount: Int = 5,
        presetMessagesJson: String? = nil,
        regexRulesJson: String? = nil
    ) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.useAssistantAvatar = useAssistantAvatar
        self.useAssistantName = useAssistantName
        self.chatModelProvider = chatModelProvider
        self.chatModelId = chatModelId
        self.temperature = temperature
        self.topP = topP
        self.contextMessageSize = contextMessageSize
        self.limitContextMessages = limitContextMessages
        self.streamOutput = streamOutput
        self.thinkingBudget = thinkingBudget
        self.maxTokens = maxTokens
        self.systemPrompt = systemPrompt
        self.messageTemplate = messageTemplate
        self.mcpServerIds = mcpServerIds
        self.background = background
        self.deletable = deletable
        self.customHeadersJson = customHeadersJson
        self.customBodyJson = customBodyJson
        self.enableMemory = enableMemory
        self.enableRecentChatsReference = enableRecentChatsReference
        self.recentChatsSummaryMessageCount = recentChatsSummaryMessageCount
        self.presetMessagesJson = presetMessagesJson
        self.regexRulesJson = regexRulesJson
    }
}
