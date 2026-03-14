import Foundation

/// Handles OpenAI Responses API format (distinct from Chat Completions API).
/// The Responses API uses a flattened tool format and different message structure.
enum OpenAIResponsesFormat {
    /// Convert standard OpenAI Chat Completions tool format to Responses API format.
    ///
    /// Chat Completions:
    /// ```json
    /// { "type": "function", "function": { "name": "...", "description": "...", "parameters": {...} } }
    /// ```
    ///
    /// Responses API:
    /// ```json
    /// { "type": "function", "name": "...", "description": "...", "parameters": {...} }
    /// ```
    static func convertTools(_ tools: [[String: Any]]) -> [[String: Any]] {
        tools.map { tool in
            let type = (tool["type"] as? String) ?? ""

            // Keep non-function tools unchanged (e.g., web_search)
            guard type == "function" else {
                return tool
            }

            // If already flattened, return as-is
            guard let function = tool["function"] as? [String: Any] else {
                return tool
            }

            var out: [String: Any] = ["type": "function"]
            if let name = function["name"] {
                out["name"] = name
            }
            if let description = function["description"] {
                out["description"] = description
            }
            if let parameters = function["parameters"] {
                out["parameters"] = parameters
            }

            // Preserve strict flag
            if let strict = (tool["strict"] ?? function["strict"]) as? Bool {
                out["strict"] = strict
            }

            return out
        }
    }

    /// Build a Responses API request body from standard parameters.
    static func buildRequestBody(
        model: String,
        messages: [[String: Any]],
        tools: [[String: Any]]? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        maxTokens: Int? = nil,
        stream: Bool = true,
        extraBody: [String: Any]? = nil
    ) -> [String: Any] {
        var body: [String: Any] = [
            "model": model,
            "input": messages,
            "stream": stream,
        ]

        if let tools, !tools.isEmpty {
            body["tools"] = convertTools(tools)
        }
        if let temperature {
            body["temperature"] = temperature
        }
        if let topP {
            body["top_p"] = topP
        }
        if let maxTokens {
            body["max_output_tokens"] = maxTokens
        }

        // Merge extra body parameters
        if let extraBody {
            for (key, value) in extraBody {
                body[key] = value
            }
        }

        return body
    }

    /// Parse a Responses API streaming event delta.
    static func parseDelta(_ data: [String: Any]) -> ResponsesDelta? {
        guard let type = data["type"] as? String else { return nil }

        switch type {
        case "response.output_item.added":
            return .itemAdded
        case "response.content_part.added":
            return .contentPartAdded
        case "response.output_text.delta":
            let delta = data["delta"] as? String ?? ""
            return .textDelta(delta)
        case "response.output_text.done":
            let text = data["text"] as? String ?? ""
            return .textDone(text)
        case "response.function_call_arguments.delta":
            let delta = data["delta"] as? String ?? ""
            return .functionArgumentsDelta(delta)
        case "response.function_call_arguments.done":
            let args = data["arguments"] as? String ?? ""
            let name = data["name"] as? String
            return .functionCallDone(name: name, arguments: args)
        case "response.completed":
            return .completed
        case "error":
            let message = (data["error"] as? [String: Any])?["message"] as? String ?? "Unknown error"
            return .error(message)
        default:
            return nil
        }
    }

    enum ResponsesDelta {
        case itemAdded
        case contentPartAdded
        case textDelta(String)
        case textDone(String)
        case functionArgumentsDelta(String)
        case functionCallDone(name: String?, arguments: String)
        case completed
        case error(String)
    }
}
