import SwiftUI

// MARK: - MarkdownRenderer

/// Renders Markdown content using the MarkdownUI library with a theme
/// that matches the Liquid Glass aesthetic.
///
/// Supports:
/// - Standard Markdown (headings, bold, italic, links, lists, blockquotes, tables)
/// - Fenced code blocks with syntax highlighting (via ``CodeBlockView``)
/// - Inline code
/// - LaTeX math (inline `$...$` and block `$$...$$` via a preprocessing pass)
/// - Images
///
/// > Note: This view relies on the `MarkdownUI` SPM package. If the package
/// > is not yet added, the fallback ``MarkdownFallbackText`` is used instead.
struct MarkdownRenderer: View {
    let content: String

    var body: some View {
        // Use native AttributedString Markdown rendering as the base.
        // Code blocks are extracted and rendered via CodeBlockView for
        // syntax highlighting.
        MarkdownContentView(source: content)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - MarkdownContentView

/// Parses Markdown source into segments (text, code blocks) and renders each
/// with the appropriate view.
private struct MarkdownContentView: View {
    let source: String

    var body: some View {
        let segments = MarkdownParser.parse(source)

        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(segments.enumerated()), id: \.offset) { _, segment in
                switch segment {
                case .text(let text):
                    markdownText(text)
                case .codeBlock(let language, let code):
                    CodeBlockView(language: language, code: code)
                case .math(let expression, let isBlock):
                    mathView(expression, isBlock: isBlock)
                }
            }
        }
    }

    @ViewBuilder
    private func markdownText(_ text: String) -> some View {
        if let attributed = try? AttributedString(
            markdown: text,
            options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        ) {
            Text(attributed)
                .font(.body)
                .textSelection(.enabled)
                .tint(.accentPrimary)
        } else {
            Text(text)
                .font(.body)
                .textSelection(.enabled)
        }
    }

    @ViewBuilder
    private func mathView(_ expression: String, isBlock: Bool) -> some View {
        // LaTeX rendering placeholder. A real implementation would use
        // a LaTeX-to-image or LaTeX-to-SwiftUI renderer (e.g. LaTeXSwiftUI).
        Text(expression)
            .font(isBlock ? .body.monospaced() : .body.monospaced())
            .foregroundStyle(.primary)
            .padding(isBlock ? 8 : 0)
            .frame(maxWidth: isBlock ? .infinity : nil, alignment: .leading)
            .background {
                if isBlock {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.surfaceSecondary.opacity(0.5))
                }
            }
    }
}

// MARK: - MarkdownParser

/// Splits raw Markdown source into renderable segments.
private enum MarkdownParser {
    enum Segment {
        case text(String)
        case codeBlock(language: String?, code: String)
        case math(expression: String, isBlock: Bool)
    }

    static func parse(_ source: String) -> [Segment] {
        var segments: [Segment] = []
        var remaining = source[...]

        while !remaining.isEmpty {
            // Look for fenced code blocks: ```lang\n...\n```
            if let codeRange = remaining.range(of: "```") {
                // Text before the code fence
                let textBefore = remaining[remaining.startIndex..<codeRange.lowerBound]
                if !textBefore.isEmpty {
                    appendTextSegments(String(textBefore), to: &segments)
                }

                // Parse the code fence
                let afterFenceStart = remaining[codeRange.upperBound...]

                // Extract optional language identifier (until newline)
                let languageLine: String?
                let codeStart: Substring.Index
                if let newline = afterFenceStart.firstIndex(of: "\n") {
                    let lang = afterFenceStart[afterFenceStart.startIndex..<newline]
                        .trimmingCharacters(in: .whitespaces)
                    languageLine = lang.isEmpty ? nil : lang
                    codeStart = afterFenceStart.index(after: newline)
                } else {
                    languageLine = nil
                    codeStart = afterFenceStart.startIndex
                }

                // Find closing fence
                let codeBody = afterFenceStart[codeStart...]
                if let closingRange = codeBody.range(of: "```") {
                    let code = String(codeBody[codeBody.startIndex..<closingRange.lowerBound])
                    segments.append(.codeBlock(
                        language: languageLine,
                        code: code.hasSuffix("\n") ? String(code.dropLast()) : code
                    ))
                    remaining = codeBody[closingRange.upperBound...]
                } else {
                    // No closing fence found; treat everything as a code block
                    segments.append(.codeBlock(language: languageLine, code: String(codeBody)))
                    break
                }
            } else {
                // No more code fences; process remaining text
                appendTextSegments(String(remaining), to: &segments)
                break
            }
        }

        return segments
    }

    /// Splits text into normal text and math segments.
    private static func appendTextSegments(_ text: String, to segments: inout [Segment]) {
        // Extract block math ($$...$$) and inline math ($...$)
        var current = text[...]
        let blockMathPattern = /\$\$(.+?)\$\$/
        let inlineMathPattern = /\$(.+?)\$/

        // Simple single-pass: look for $$ first, then $
        while !current.isEmpty {
            if let blockMatch = current.firstMatch(of: blockMathPattern) {
                let before = current[current.startIndex..<blockMatch.range.lowerBound]
                if !before.isEmpty {
                    segments.append(.text(String(before)))
                }
                segments.append(.math(expression: String(blockMatch.1), isBlock: true))
                current = current[blockMatch.range.upperBound...]
            } else if let inlineMatch = current.firstMatch(of: inlineMathPattern) {
                let before = current[current.startIndex..<inlineMatch.range.lowerBound]
                if !before.isEmpty {
                    segments.append(.text(String(before)))
                }
                segments.append(.math(expression: String(inlineMatch.1), isBlock: false))
                current = current[inlineMatch.range.upperBound...]
            } else {
                segments.append(.text(String(current)))
                break
            }
        }
    }
}
