import Foundation

// MARK: - Translation Error

enum TranslationError: Error, LocalizedError {
    case noProvider
    case emptyText
    case translationFailed(String)

    var errorDescription: String? {
        switch self {
        case .noProvider:
            return "No LLM provider available for translation"
        case .emptyText:
            return "Cannot translate empty text"
        case let .translationFailed(detail):
            return "Translation failed: \(detail)"
        }
    }
}

// MARK: - Translation Service

/// Translates text using a configured LLM provider.
struct TranslationService: Sendable {

    /// Translate text between languages using the specified LLM provider.
    ///
    /// - Parameters:
    ///   - text: The text to translate.
    ///   - from: Source language (e.g. "English", "Chinese", or "auto" for detection).
    ///   - to: Target language (e.g. "Chinese", "English").
    ///   - provider: The LLM provider to use for translation.
    ///   - model: The model ID to use.
    ///   - apiKey: The API key for the provider.
    ///   - baseUrl: The base URL for the provider.
    /// - Returns: The translated text.
    static func translate(
        text: String,
        from: String,
        to: String,
        provider: any LLMProvider,
        model: String,
        apiKey: String,
        baseUrl: String
    ) async throws -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw TranslationError.emptyText
        }

        let systemPrompt = buildTranslationPrompt(from: from, to: to)
        let messages: [MessagePayload] = [
            MessagePayload(role: "system", content: .text(systemPrompt)),
            MessagePayload(role: "user", content: .text(trimmed)),
        ]

        let parameters = ModelParameters(
            temperature: 0.3,
            maxTokens: 4096
        )

        var result = ""
        let stream = provider.sendMessage(
            messages: messages,
            model: model,
            parameters: parameters,
            tools: nil
        )

        for try await chunk in stream {
            if let content = chunk.content {
                result += content
            }
        }

        let translated = result.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !translated.isEmpty else {
            throw TranslationError.translationFailed("Empty response from provider")
        }

        return translated
    }

    // MARK: - Prompt Construction

    /// Build the system prompt for translation.
    static func buildTranslationPrompt(from sourceLang: String, to targetLang: String) -> String {
        let sourceDesc: String
        if sourceLang.lowercased() == "auto" {
            sourceDesc = "Detect the source language automatically"
        } else {
            sourceDesc = "The source language is \(sourceLang)"
        }

        return """
        You are a professional translator. \(sourceDesc). Translate the following text to \(targetLang).

        Rules:
        - Output ONLY the translated text, nothing else.
        - Preserve the original formatting, including line breaks and paragraphs.
        - Do not add explanations, notes, or comments.
        - Keep proper nouns, brand names, and technical terms as-is when appropriate.
        - Maintain the original tone and style.
        """
    }

    /// Common language codes for convenience.
    static let commonLanguages: [(code: String, name: String)] = [
        ("auto", "Auto Detect"),
        ("en", "English"),
        ("zh", "Chinese"),
        ("ja", "Japanese"),
        ("ko", "Korean"),
        ("fr", "French"),
        ("de", "German"),
        ("es", "Spanish"),
        ("pt", "Portuguese"),
        ("ru", "Russian"),
        ("ar", "Arabic"),
        ("it", "Italian"),
    ]
}
