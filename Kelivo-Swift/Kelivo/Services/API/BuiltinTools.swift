import Foundation

// MARK: - Built-in Tools

/// Defines built-in tool schemas that can be sent to LLM providers.
/// These tool definitions describe capabilities the app can execute locally
/// when the model requests a tool call.
struct BuiltinTools {

    // MARK: - Web Search

    static let webSearch = ToolDefinition(
        name: "web_search",
        description:
            "Search the web for current information. Use this when you need to find up-to-date information that may not be in your training data.",
        parameters: JSONSchema(
            type: "object",
            properties: [
                "query": JSONSchemaProperty(
                    type: "string",
                    description: "The search query to execute"
                ),
                "num_results": JSONSchemaProperty(
                    type: "integer",
                    description: "Maximum number of results to return (default: 5)"
                ),
            ],
            required: ["query"]
        )
    )

    // MARK: - URL Fetch

    static let urlFetch = ToolDefinition(
        name: "url_fetch",
        description:
            "Fetch the content of a web page at the given URL. Returns the page text content.",
        parameters: JSONSchema(
            type: "object",
            properties: [
                "url": JSONSchemaProperty(
                    type: "string",
                    description: "The URL to fetch content from"
                )
            ],
            required: ["url"]
        )
    )

    // MARK: - Code Execution

    static let codeExecution = ToolDefinition(
        name: "code_execution",
        description:
            "Execute a snippet of code in a sandboxed environment and return the output.",
        parameters: JSONSchema(
            type: "object",
            properties: [
                "language": JSONSchemaProperty(
                    type: "string",
                    description: "The programming language of the code",
                    enumValues: ["python", "javascript"]
                ),
                "code": JSONSchemaProperty(
                    type: "string",
                    description: "The code to execute"
                ),
            ],
            required: ["language", "code"]
        )
    )

    // MARK: - Image Generation

    static let imageGeneration = ToolDefinition(
        name: "image_generation",
        description:
            "Generate an image from a text description using an image generation model.",
        parameters: JSONSchema(
            type: "object",
            properties: [
                "prompt": JSONSchemaProperty(
                    type: "string",
                    description: "A detailed description of the image to generate"
                ),
                "size": JSONSchemaProperty(
                    type: "string",
                    description: "The size of the image to generate",
                    enumValues: ["256x256", "512x512", "1024x1024"]
                ),
            ],
            required: ["prompt"]
        )
    )

    // MARK: - All Tools

    /// Returns all built-in tool definitions.
    static var all: [ToolDefinition] {
        [webSearch, urlFetch, codeExecution, imageGeneration]
    }

    /// Returns a subset of built-in tools by name.
    static func tools(named names: Set<String>) -> [ToolDefinition] {
        all.filter { names.contains($0.name) }
    }
}
