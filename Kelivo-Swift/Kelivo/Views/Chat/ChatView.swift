import SwiftUI
import SwiftData

// MARK: - ChatView

/// Main chat view displaying a scrollable message list and input bar.
struct ChatView: View {
    @Environment(ChatViewModel.self) private var chatVM
    @Environment(\.modelContext) private var modelContext
    let conversationId: String?

    // MARK: Body

    var body: some View {
        VStack(spacing: 0) {
            messageList
            MessageInputBar()
        }
        .background(Color.chatBackground)
        .navigationTitle(chatVM.currentConversation?.title ?? String(localized: "newChat"))
        #if os(macOS)
        .navigationSubtitle(subtitleText)
        #endif
        .toolbar { toolbarContent }
        .onAppear {
            chatVM.configure(modelContext: modelContext)
            if let id = conversationId {
                chatVM.loadConversation(id)
            }
        }
    }

    // MARK: - Message List

    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(chatVM.messages) { message in
                        MessageBubble(message: message)
                            .id(message.id)
                    }
                    if chatVM.isStreaming {
                        StreamingIndicator(partialContent: chatVM.streamingContent)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .scrollEdgeEffectModifier()
            .onChange(of: chatVM.messages.count) { _, _ in
                scrollToBottom(proxy: proxy)
            }
            .onChange(of: chatVM.streamingContent) { _, _ in
                scrollToBottom(proxy: proxy)
            }
        }
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            if chatVM.isStreaming {
                Button {
                    chatVM.stopStreaming()
                } label: {
                    Image(systemName: "stop.circle")
                }
                .help(String(localized: "stopGeneration"))
            }

            Menu {
                Button(role: .destructive) {
                    chatVM.clearConversation()
                } label: {
                    Label(String(localized: "clearChat"), systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }

    // MARK: - Helpers

    #if os(macOS)
    private var subtitleText: String {
        guard chatVM.currentConversation != nil else { return "" }
        let count = chatVM.messages.count
        return String(localized: "\(count) messages")
    }
    #endif

    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let lastMessage = chatVM.messages.last else { return }
        withAnimation(.easeOut(duration: 0.2)) {
            proxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
}

// MARK: - Scroll Edge Effect Modifier

private extension View {
    @ViewBuilder
    func scrollEdgeEffectModifier() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self
                .scrollEdgeEffectStyle(.soft, for: .top)
        } else {
            self
        }
    }
}
