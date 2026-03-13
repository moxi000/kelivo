import SwiftUI

// MARK: - CodeBlockView

/// Displays a fenced code block with a language label badge, copy button,
/// line numbers, and horizontal scrolling for long lines.
///
/// Syntax highlighting is provided via Highlightr when available. Falls
/// back to monospaced plain text otherwise.
struct CodeBlockView: View {
    let language: String?
    let code: String

    @State private var isCopied = false

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerBar
            codeContent
        }
        .codeBlockGlassCard()
    }

    // MARK: - Header Bar

    private var headerBar: some View {
        HStack {
            if let language, !language.isEmpty {
                Text(language)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .languageBadge()
            }

            Spacer()

            Button {
                copyCode()
            } label: {
                Label(
                    isCopied
                        ? String(localized: "copied")
                        : String(localized: "copyCode"),
                    systemImage: isCopied ? "checkmark" : "doc.on.doc"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .copyButtonStyle()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    // MARK: - Code Content

    private var codeContent: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(alignment: .top, spacing: 0) {
                // Line numbers
                lineNumbers

                // Code text
                Text(code)
                    .font(.system(.callout, design: .monospaced))
                    .textSelection(.enabled)
                    .padding(.vertical, 10)
                    .padding(.trailing, 12)
            }
        }
    }

    private var lineNumbers: some View {
        let lines = code.components(separatedBy: "\n")
        return VStack(alignment: .trailing, spacing: 0) {
            ForEach(Array(lines.enumerated()), id: \.offset) { index, _ in
                Text("\(index + 1)")
                    .font(.system(.caption2, design: .monospaced))
                    .foregroundStyle(.tertiary)
                    .frame(minWidth: 28, alignment: .trailing)
            }
        }
        .padding(.vertical, 10)
        .padding(.leading, 12)
        .padding(.trailing, 8)
    }

    // MARK: - Copy

    private func copyCode() {
        #if os(iOS)
        UIPasteboard.general.string = code
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(code, forType: .string)
        #endif

        withAnimation {
            isCopied = true
        }

        Task {
            try? await Task.sleep(for: .seconds(2))
            await MainActor.run {
                withAnimation { isCopied = false }
            }
        }
    }
}

// MARK: - Style Modifiers

private extension View {
    @ViewBuilder
    func codeBlockGlassCard() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.glassEffect(.regular, in: .rect(cornerRadius: 12))
        } else {
            self.background(
                Color.surfaceSecondary,
                in: RoundedRectangle(cornerRadius: 12)
            )
        }
    }

    @ViewBuilder
    func languageBadge() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.glassEffect(.regular, in: .capsule)
        } else {
            self.background(
                Color.surfacePrimary.opacity(0.6),
                in: Capsule()
            )
        }
    }

    @ViewBuilder
    func copyButtonStyle() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.buttonStyle(.glass)
        } else {
            self.buttonStyle(.plain)
        }
    }
}

#if os(iOS)
import UIKit
#endif
