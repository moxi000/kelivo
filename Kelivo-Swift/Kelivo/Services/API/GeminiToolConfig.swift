import Foundation

/// Converts standard OpenAI-format tool definitions to Gemini's tool format.
enum GeminiToolConfig {
    /// Convert an array of OpenAI-format tool definitions to Gemini format.
    ///
    /// OpenAI format:
    /// ```json
    /// { "type": "function", "function": { "name": "...", "description": "...", "parameters": {...} } }
    /// ```
    ///
    /// Gemini format:
    /// ```json
    /// { "functionDeclarations": [{ "name": "...", "description": "...", "parameters": {...} }] }
    /// ```
    static func convertTools(_ tools: [[String: Any]]) -> [[String: Any]] {
        var declarations: [[String: Any]] = []

        for tool in tools {
            guard let type = tool["type"] as? String, type == "function" else {
                continue
            }

            if let function = tool["function"] as? [String: Any] {
                var decl: [String: Any] = [:]
                if let name = function["name"] {
                    decl["name"] = name
                }
                if let description = function["description"] {
                    decl["description"] = description
                }
                if let parameters = function["parameters"] {
                    decl["parameters"] = sanitizeSchema(parameters as? [String: Any] ?? [:])
                }
                declarations.append(decl)
            }
        }

        guard !declarations.isEmpty else { return [] }
        return [["functionDeclarations": declarations]]
    }

    /// Convert a Gemini function call response to the standard format.
    static func convertFunctionCall(_ part: [String: Any]) -> (name: String, arguments: [String: Any])? {
        guard let functionCall = part["functionCall"] as? [String: Any],
              let name = functionCall["name"] as? String else {
            return nil
        }
        let args = functionCall["args"] as? [String: Any] ?? [:]
        return (name, args)
    }

    /// Build a function response part for Gemini.
    static func functionResponsePart(name: String, response: Any) -> [String: Any] {
        return [
            "functionResponse": [
                "name": name,
                "response": ["result": response]
            ]
        ]
    }

    /// Sanitize JSON Schema for Gemini compatibility.
    /// Gemini doesn't support some JSON Schema features like `additionalProperties`.
    private static func sanitizeSchema(_ schema: [String: Any]) -> [String: Any] {
        var result = schema
        result.removeValue(forKey: "additionalProperties")
        result.removeValue(forKey: "$schema")

        if let properties = result["properties"] as? [String: Any] {
            var sanitized: [String: Any] = [:]
            for (key, value) in properties {
                if let prop = value as? [String: Any] {
                    sanitized[key] = sanitizeSchema(prop)
                } else {
                    sanitized[key] = value
                }
            }
            result["properties"] = sanitized
        }

        if let items = result["items"] as? [String: Any] {
            result["items"] = sanitizeSchema(items)
        }

        return result
    }
}
