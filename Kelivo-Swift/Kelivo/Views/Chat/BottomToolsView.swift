import SwiftUI

// MARK: - BottomToolsView

/// Horizontal toolbar below the chat input providing quick access to
/// model selection, attachments, quick phrases, web search, and MCP tools.
struct BottomToolsView: View {
    @Environment(ChatViewModel.self) private var chatVM

    var onAttachTapped: (() -> Void)?
    var onQuickPhraseTapped: (() -> Void)?
    var onModelSelectorTapped: (() -> Void)?
    var onMCPToolsTapped: (() -> Void)?

    // MARK: Body

    var body: some View {
        HStack(spacing: 16) {
            // Model selector
            toolButton(
                icon: "cpu",
                label: String(localized: "selectModel"),
                action: { onModelSelectorTapped?() }
            )

            // Attachment (images, documents)
            toolButton(
                icon: "paperclip",
                label: String(localized: "attach"),
                action: { onAttachTapped?() }
            )

            // Quick phrases
            toolButton(
                icon: "text.quote",
                label: String(localized: "quickPhrases"),
                action: { onQuickPhraseTapped?() }
            )

            // Web search toggle
            webSearchToggle

            // MCP tools
            toolButton(
                icon: "wrench.and.screwdriver",
                label: String(localized: "mcpTools"),
                action: { onMCPToolsTapped?() }
            )

            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .bottomToolsGlassBackground()
    }

    // MARK: - Tool Button

    private func toolButton(
        icon: String,
        label: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(.secondary)
                .frame(width: 32, height: 32)
        }
        .buttonStyle(.plain)
        .help(label)
        .accessibilityLabel(label)
    }

    // MARK: - Web Search Toggle

    private var webSearchToggle: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                chatVM.isWebSearchEnabled.toggle()
            }
        } label: {
            Image(systemName: "globe")
                .font(.body)
                .foregroundStyle(
                    chatVM.isWebSearchEnabled
                        ? Color.accentPrimary : .secondary
                )
                .frame(width: 32, height: 32)
        }
        .buttonStyle(.plain)
        .help(
            chatVM.isWebSearchEnabled
                ? String(localized: "disableWebSearch")
                : String(localized: "enableWebSearch")
        )
        .accessibilityLabel(String(localized: "webSearch"))
        .accessibilityAddTraits(
            chatVM.isWebSearchEnabled ? .isSelected : []
        )
    }
}

// MARK: - Glass Background

private extension View {
    @ViewBuilder
    func bottomToolsGlassBackground() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.glassEffect(.regular, in: .rect(cornerRadius: 0))
        } else {
            self.background(.bar)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        Spacer()
        BottomToolsView()
    }
}
