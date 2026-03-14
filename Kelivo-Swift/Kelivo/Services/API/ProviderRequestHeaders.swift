import Foundation

// MARK: - Provider Request Headers

/// Builds HTTP request headers for LLM provider API calls.
struct ProviderRequestHeaders {

    // MARK: - OpenRouter Constants

    private static let openRouterReferer = "https://github.com/Chevey339/kelivo"
    private static let openRouterTitle = "Kelivo"
    private static let openRouterCategories = "general-chat"

    // MARK: - Header Construction

    /// Build the full set of headers for an API request to the given provider.
    ///
    /// - Parameters:
    ///   - provider: The provider configuration.
    ///   - apiKey: The decrypted API key.
    /// - Returns: A dictionary of HTTP headers.
    static func headers(for provider: ProviderConfig, apiKey: String) -> [String: String] {
        var result: [String: String] = [:]

        // Auth headers based on API type
        switch provider.apiType {
        case .claude:
            result["x-api-key"] = apiKey
            result["anthropic-version"] = "2023-06-01"
            result["Content-Type"] = "application/json"

        case .gemini:
            // Gemini uses API key as query parameter, but include Content-Type
            result["Content-Type"] = "application/json"

        case .vertex:
            // Vertex uses Bearer token from service account
            if !apiKey.isEmpty {
                result["Authorization"] = "Bearer \(apiKey)"
            }
            result["Content-Type"] = "application/json"

        case .openai:
            if !apiKey.isEmpty {
                result["Authorization"] = "Bearer \(apiKey)"
            }
            result["Content-Type"] = "application/json"
        }

        // Add OpenRouter-specific headers if the provider URL matches
        if isOpenRouterProvider(provider) {
            result["HTTP-Referer"] = openRouterReferer
            result["X-OpenRouter-Title"] = openRouterTitle
            result["X-OpenRouter-Categories"] = openRouterCategories
        }

        // Merge custom headers from provider config (user-defined overrides)
        for (key, value) in customHeaders(from: provider) {
            result[key] = value
        }

        return result
    }

    // MARK: - Provider Detection

    /// Check whether a provider is an OpenRouter endpoint.
    static func isOpenRouterProvider(_ provider: ProviderConfig) -> Bool {
        let host = URL(string: provider.baseUrl)?.host?.lowercased() ?? ""
        return host.contains("openrouter.ai")
    }

    // MARK: - Custom Headers

    /// Parse custom headers stored as JSON in the provider config.
    static func customHeaders(from provider: ProviderConfig) -> [String: String] {
        guard let json = provider.customHeadersJson,
              !json.isEmpty,
              let data = json.data(using: .utf8),
              let array = try? JSONSerialization.jsonObject(with: data) as? [[String: String]]
        else {
            return [:]
        }

        var headers: [String: String] = [:]
        for entry in array {
            if let key = entry["key"], let value = entry["value"],
               !key.trimmingCharacters(in: .whitespaces).isEmpty
            {
                headers[key] = value
            }
        }
        return headers
    }
}
