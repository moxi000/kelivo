import Foundation

// MARK: - Prompt Transformer

/// Transforms and assembles prompts for LLM requests.
///
/// All methods are static and pure — no side effects or stored state.
struct PromptTransformer {

    // MARK: - System Prompt Assembly

    /// Build a complete system prompt from assistant config, injections, world book matches, and memories.
    ///
    /// Assembly order:
    /// 1. Before-injections (sorted by sortOrder)
    /// 2. Base system prompt from assistant
    /// 3. World book matches (sorted by priority, descending)
    /// 4. Memories
    /// 5. After-injections (sorted by sortOrder)
    static func buildSystemPrompt(
        assistant: SendableAssistant?,
        injections: [SendableInjection],
        worldBookMatches: [SendableWorldBookEntry],
        memories: [SendableAssistantMemory],
        userName: String?
    ) -> String {
        var parts: [String] = []

        // Before-injections
        let beforeInjections = injections
            .filter { $0.isEnabled && $0.groupId == "before" }
            .sorted { $0.sortOrder < $1.sortOrder }
        for injection in beforeInjections {
            parts.append(injection.content)
        }

        // Base system prompt with placeholder replacement
        if let assistant, !assistant.systemPrompt.isEmpty {
            var prompt = assistant.systemPrompt
            let placeholders = buildPlaceholders(
                assistantName: assistant.name,
                userName: userName,
                modelId: assistant.chatModelId
            )
            prompt = replacePlaceholders(prompt, with: placeholders)
            parts.append(prompt)
        }

        // World book entries (already filtered for system-level positions by caller)
        let sortedEntries = worldBookMatches.sorted { $0.priority > $1.priority }
        for entry in sortedEntries {
            parts.append(entry.content)
        }

        // Memories
        if !memories.isEmpty {
            let memoryBlock = memories
                .map(\.content)
                .joined(separator: "\n")
            parts.append("## Memories\n\(memoryBlock)")
        }

        // After-injections
        let afterInjections = injections
            .filter { $0.isEnabled && $0.groupId == "after" }
            .sorted { $0.sortOrder < $1.sortOrder }
        for injection in afterInjections {
            parts.append(injection.content)
        }

        return parts.joined(separator: "\n\n")
    }

    // MARK: - Placeholder Replacement

    /// Build a dictionary of placeholder keys to their runtime values.
    static func buildPlaceholders(
        assistantName: String?,
        userName: String?,
        modelId: String?,
        modelName: String? = nil,
        locale: String? = nil
    ) -> [String: String] {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: now)

        let year = String(format: "%04d", components.year ?? 0)
        let month = String(format: "%02d", components.month ?? 0)
        let day = String(format: "%02d", components.day ?? 0)
        let hour = String(format: "%02d", components.hour ?? 0)
        let minute = String(format: "%02d", components.minute ?? 0)

        let date = "\(year)-\(month)-\(day)"
        let time = "\(hour):\(minute)"
        let datetime = "\(date) \(time)"

        let tz = TimeZone.current.abbreviation() ?? TimeZone.current.identifier

        #if os(macOS)
        let os = "macOS"
        #elseif os(iOS)
        let os = "iOS"
        #else
        let os = "Unknown"
        #endif

        let osVersion = ProcessInfo.processInfo.operatingSystemVersionString

        return [
            "{cur_date}": date,
            "{cur_time}": time,
            "{cur_datetime}": datetime,
            "{model_id}": modelId ?? "",
            "{model_name}": modelName ?? (modelId ?? ""),
            "{locale}": locale ?? Locale.current.identifier,
            "{timezone}": tz,
            "{system_version}": "\(os) \(osVersion)",
            "{device_info}": os,
            "{battery_level}": "unknown",
            "{nickname}": userName ?? "",
            "{assistant_name}": assistantName ?? "",
        ]
    }

    /// Replace all placeholder tokens in the given text.
    static func replacePlaceholders(_ text: String, with vars: [String: String]) -> String {
        var result = text
        for (key, value) in vars {
            result = result.replacingOccurrences(of: key, with: value)
        }
        return result
    }

    // MARK: - Message Template

    /// Apply a mustache-like message template.
    ///
    /// Supported variables: `{{ role }}`, `{{ message }}`, `{{ time }}`, `{{ date }}`.
    static func applyMessageTemplate(
        _ template: String,
        role: String,
        message: String,
        now: Date = .now
    ) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: now)

        let year = String(format: "%04d", components.year ?? 0)
        let month = String(format: "%02d", components.month ?? 0)
        let day = String(format: "%02d", components.day ?? 0)
        let hour = String(format: "%02d", components.hour ?? 0)
        let minute = String(format: "%02d", components.minute ?? 0)

        let date = "\(year)-\(month)-\(day)"
        let time = "\(hour):\(minute)"

        let vars: [String: String] = [
            "role": role,
            "message": message,
            "time": time,
            "date": date,
        ]

        let pattern = #/\{\{\s*(\w+)\s*\}\}/#
        return template.replacing(pattern) { match in
            let key = String(match.1)
            return vars[key] ?? String(match.0)
        }
    }

    // MARK: - Regex Rules

    /// Apply regex transformation rules to user input text.
    ///
    /// Only enabled, non-visualOnly rules with the `.user` scope are applied.
    /// Rules are applied in order; each rule operates on the output of the previous.
    static func applyRegexRules(_ text: String, rules: [SendableAssistantRegex]) -> String {
        var result = text

        for rule in rules {
            guard rule.isEnabled else { continue }
            guard !rule.visualOnly else { continue }
            guard rule.scopes.contains("user") else { continue }

            do {
                let regex = try NSRegularExpression(pattern: rule.pattern)
                let range = NSRange(result.startIndex..., in: result)
                result = regex.stringByReplacingMatches(
                    in: result,
                    range: range,
                    withTemplate: rule.replacement
                )
            } catch {
                // Skip invalid regex patterns silently — the user is informed
                // about invalid patterns in the regex editor UI.
                continue
            }
        }

        return result
    }

    // MARK: - Search Context

    /// Format search results as context text for injection into the prompt.
    static func buildSearchContext(_ results: [SearchResult]) -> String {
        guard !results.isEmpty else { return "" }

        var lines: [String] = ["## Web Search Results\n"]

        for (index, result) in results.enumerated() {
            lines.append("### [\(index + 1)] \(result.title)")
            lines.append("URL: \(result.url)")
            if !result.snippet.isEmpty {
                lines.append(result.snippet)
            }
            if let content = result.content, !content.isEmpty {
                lines.append(content)
            }
            lines.append("") // blank line separator
        }

        return lines.joined(separator: "\n")
    }

    // MARK: - Token Estimation and Truncation

    /// Truncate message history to fit within a token budget.
    ///
    /// The system message (role == "system") is always preserved. When the total
    /// estimated token count exceeds `maxTokens`, older messages are removed
    /// starting from `truncateIndex` until the budget is met.
    static func truncateMessages(
        _ messages: [MessagePayload],
        maxTokens: Int,
        truncateIndex: Int
    ) -> [MessagePayload] {
        guard maxTokens > 0 else { return messages }

        let totalEstimate = messages.reduce(0) { sum, msg in
            sum + estimateTokens(for: msg)
        }

        guard totalEstimate > maxTokens else { return messages }

        // Separate system messages (always kept) from conversation messages
        var systemMessages: [MessagePayload] = []
        var conversationMessages: [MessagePayload] = []

        for message in messages {
            if message.role == "system" {
                systemMessages.append(message)
            } else {
                conversationMessages.append(message)
            }
        }

        let systemTokens = systemMessages.reduce(0) { sum, msg in
            sum + estimateTokens(for: msg)
        }
        let availableTokens = maxTokens - systemTokens
        guard availableTokens > 0 else { return systemMessages }

        // Remove oldest conversation messages (starting from truncateIndex)
        // until we fit within budget. Always keep the most recent messages.
        var trimmed = conversationMessages
        var currentTokens = trimmed.reduce(0) { sum, msg in
            sum + estimateTokens(for: msg)
        }

        let effectiveStart = max(0, min(truncateIndex, trimmed.count))
        var removeIndex = effectiveStart

        while currentTokens > availableTokens && removeIndex < trimmed.count - 1 {
            currentTokens -= estimateTokens(for: trimmed[removeIndex])
            trimmed.remove(at: removeIndex)
            // Don't increment removeIndex since array shifted
        }

        return systemMessages + trimmed
    }

    /// Estimate the token count for a message payload.
    private static func estimateTokens(for message: MessagePayload) -> Int {
        switch message.content {
        case .text(let text):
            return estimateTokens(text)
        case .parts(let parts):
            return parts.reduce(0) { sum, part in
                switch part {
                case .text(let text):
                    return sum + estimateTokens(text)
                case .image:
                    // Images typically consume a fixed token budget
                    return sum + 1000
                }
            }
        }
    }

    /// Estimate token count for a string.
    ///
    /// Uses a rough heuristic: ~4 characters per token for Latin scripts,
    /// ~2 characters per token for CJK characters.
    static func estimateTokens(_ text: String) -> Int {
        guard !text.isEmpty else { return 0 }

        var latinChars = 0
        var cjkChars = 0

        for scalar in text.unicodeScalars {
            let value = scalar.value
            // CJK Unified Ideographs and common CJK ranges
            if (0x4E00...0x9FFF).contains(value)
                || (0x3400...0x4DBF).contains(value)
                || (0x3000...0x303F).contains(value)
                || (0x3040...0x309F).contains(value)  // Hiragana
                || (0x30A0...0x30FF).contains(value)  // Katakana
                || (0xAC00...0xD7AF).contains(value)  // Korean
            {
                cjkChars += 1
            } else {
                latinChars += 1
            }
        }

        // ~4 chars per token for Latin, ~2 chars per token for CJK
        let latinTokens = (latinChars + 3) / 4
        let cjkTokens = (cjkChars + 1) / 2

        return max(1, latinTokens + cjkTokens)
    }
}

// MARK: - Sendable Snapshots for PromptTransformer

/// A Sendable snapshot of an Assistant for crossing concurrency boundaries.
struct SendableAssistant: Sendable {
    let id: String
    let name: String
    let systemPrompt: String
    let messageTemplate: String
    let chatModelProvider: String?
    let chatModelId: String?
    let enableMemory: Bool
    let enableRecentChatsReference: Bool
    let recentChatsSummaryMessageCount: Int
}

/// A Sendable snapshot of an AssistantMemory for crossing concurrency boundaries.
struct SendableAssistantMemory: Sendable {
    let id: String
    let assistantId: String
    let content: String
    let createdAt: Date
}

/// A Sendable snapshot of an AssistantRegex for crossing concurrency boundaries.
struct SendableAssistantRegex: Sendable {
    let id: String
    let name: String
    let pattern: String
    let replacement: String
    let scopes: [String]  // raw values of AssistantRegexScope
    let visualOnly: Bool
    let replaceOnly: Bool
    let isEnabled: Bool
}
