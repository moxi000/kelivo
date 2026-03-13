import Foundation

// MARK: - SSE Event

struct SSEEvent: Sendable {
    let event: String?
    let data: String
    let id: String?
}

// MARK: - SSE Parser

struct SSEParser: Sendable {

    /// Parses a raw byte stream (line-delimited Data chunks) into typed SSE events.
    ///
    /// Each chunk from the input stream is expected to be a single line (ending with `\n`).
    /// The parser accumulates fields across lines and emits an `SSEEvent` on each blank line,
    /// following the W3C Server-Sent Events specification.
    ///
    /// Lines containing only `data: [DONE]` cause the stream to terminate cleanly.
    static func parse(
        _ stream: AsyncThrowingStream<Data, Error>
    ) -> AsyncThrowingStream<SSEEvent, Error> {
        AsyncThrowingStream { continuation in
            let task = Task {
                var currentEvent: String?
                var dataLines: [String] = []
                var currentId: String?

                do {
                    for try await chunk in stream {
                        if Task.isCancelled {
                            continuation.finish()
                            return
                        }

                        guard let line = String(data: chunk, encoding: .utf8) else { continue }
                        let trimmed = line.trimmingCharacters(in: .newlines)

                        // Blank line: dispatch accumulated event
                        if trimmed.isEmpty {
                            if !dataLines.isEmpty {
                                let joinedData = dataLines.joined(separator: "\n")
                                let event = SSEEvent(
                                    event: currentEvent,
                                    data: joinedData,
                                    id: currentId
                                )
                                continuation.yield(event)
                            }
                            // Reset accumulators
                            currentEvent = nil
                            dataLines = []
                            currentId = nil
                            continue
                        }

                        // Skip SSE comments
                        if trimmed.hasPrefix(":") {
                            continue
                        }

                        // Parse field: value
                        let field: String
                        let value: String
                        if let colonIndex = trimmed.firstIndex(of: ":") {
                            field = String(trimmed[trimmed.startIndex..<colonIndex])
                            let afterColon = trimmed.index(after: colonIndex)
                            let rawValue = String(trimmed[afterColon...])
                            // Remove single leading space per SSE spec
                            value =
                                rawValue.hasPrefix(" ")
                                ? String(rawValue.dropFirst())
                                : rawValue
                        } else {
                            field = trimmed
                            value = ""
                        }

                        switch field {
                        case "data":
                            // Check for [DONE] termination signal
                            if value == "[DONE]" {
                                continuation.finish()
                                return
                            }
                            dataLines.append(value)
                        case "event":
                            currentEvent = value
                        case "id":
                            currentId = value
                        case "retry":
                            // Retry is acknowledged but not acted upon in this parser
                            break
                        default:
                            // Unknown fields are ignored per spec
                            break
                        }
                    }

                    // Stream ended; flush any remaining buffered event
                    if !dataLines.isEmpty {
                        let joinedData = dataLines.joined(separator: "\n")
                        let event = SSEEvent(
                            event: currentEvent,
                            data: joinedData,
                            id: currentId
                        )
                        continuation.yield(event)
                    }

                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
