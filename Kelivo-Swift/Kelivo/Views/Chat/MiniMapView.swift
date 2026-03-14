import SwiftUI
import SwiftData

// MARK: - Q&A Pair

/// Groups a user message with its corresponding assistant reply for display in the mini map.
private struct QAPair: Identifiable {
    let id: String
    let user: ChatMessage?
    let assistant: ChatMessage?

    init(user: ChatMessage?, assistant: ChatMessage?) {
        self.user = user
        self.assistant = assistant
        self.id = user?.id ?? assistant?.id ?? UUID().uuidString
    }
}

// MARK: - MiniMapView

/// Displays a compact overview of all messages in a conversation, allowing the user
/// to tap a message to scroll to it in the main chat view.
/// Corresponds to Flutter: `lib/features/home/widgets/mini_map_sheet.dart` and
/// `lib/desktop/mini_map_popover.dart`
struct MiniMapView: View {
    @Environment(\.dismiss) private var dismiss

    /// All messages in the current conversation.
    let messages: [ChatMessage]

    /// Called when the user taps a message row; passes the message ID.
    var onSelectMessage: ((String) -> Void)?

    @State private var searchText: String = ""
    @State private var isSearching: Bool = false

    var body: some View {
        NavigationStack {
            Group {
                if messages.isEmpty {
                    ContentUnavailableView {
                        Label(String(localized: "No Messages"), systemImage: "bubble.left.and.bubble.right")
                    } description: {
                        Text(String(localized: "Start a conversation to see the message map."))
                    }
                } else {
                    ScrollViewReader { proxy in
                        List {
                            ForEach(filteredPairs) { pair in
                                pairRow(pair)
                                    .id(pair.id)
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                            }
                        }
                        .listStyle(.plain)
                        .onAppear {
                            // Scroll to the last pair on appear.
                            if let lastId = filteredPairs.last?.id {
                                proxy.scrollTo(lastId, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            .navigationTitle(String(localized: "Message Map"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Close")) { dismiss() }
                }

                ToolbarItem(placement: .primaryAction) {
                    Button {
                        withAnimation { isSearching.toggle() }
                    } label: {
                        Image(systemName: isSearching ? "xmark" : "magnifyingglass")
                    }
                }
            }
            .if(isSearching) { view in
                view.searchable(text: $searchText, prompt: String(localized: "Search messages"))
            }
        }
        .presentationDetents([.medium, .large])
    }

    // MARK: - Data

    private var allPairs: [QAPair] {
        buildPairs(from: messages)
    }

    private var filteredPairs: [QAPair] {
        let needle = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !needle.isEmpty else { return allPairs }
        return allPairs.filter { pair in
            let userMatch = pair.user?.content.lowercased().contains(needle) ?? false
            let assistantMatch = pair.assistant?.content.lowercased().contains(needle) ?? false
            return userMatch || assistantMatch
        }
    }

    private func buildPairs(from items: [ChatMessage]) -> [QAPair] {
        var pairs: [QAPair] = []
        var pendingUser: ChatMessage?
        for message in items {
            if message.role == "user" {
                if let pending = pendingUser {
                    pairs.append(QAPair(user: pending, assistant: nil))
                }
                pendingUser = message
            } else if message.role == "assistant" {
                pairs.append(QAPair(user: pendingUser, assistant: message))
                pendingUser = nil
            }
        }
        if let pending = pendingUser {
            pairs.append(QAPair(user: pending, assistant: nil))
        }
        return pairs
    }

    // MARK: - Row

    private func pairRow(_ pair: QAPair) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            // User bubble (right-aligned, tinted)
            if let user = pair.user {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                        onSelectMessage?(user.id)
                    } label: {
                        Text(oneLine(user.content))
                            .font(.callout)
                            .lineLimit(1)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.accentColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 16))
                            .foregroundStyle(.primary)
                    }
                    .buttonStyle(.plain)
                }
            }

            // Assistant bubble (left-aligned, subtle)
            if let assistant = pair.assistant {
                HStack {
                    Button {
                        dismiss()
                        onSelectMessage?(assistant.id)
                    } label: {
                        Text(oneLine(assistant.content))
                            .font(.callout)
                            .lineLimit(1)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
                            .foregroundStyle(.primary)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
            }
        }
    }

    // MARK: - Helpers

    /// Strips inline markers, thinking blocks, and collapses whitespace to produce a single-line preview.
    private func oneLine(_ text: String) -> String {
        var result = text
        // Remove <think>...</think> blocks
        result = result.replacingOccurrences(
            of: "<think>[\\s\\S]*?</think>",
            with: "",
            options: .regularExpression
        )
        // Remove inline image/file markers
        result = result.replacingOccurrences(of: "\\[image:[^\\]]+\\]", with: "", options: .regularExpression)
        result = result.replacingOccurrences(of: "\\[file:[^\\]]+\\]", with: "", options: .regularExpression)
        // Collapse whitespace
        result = result.replacingOccurrences(of: "\n", with: " ")
        result = result.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Conditional Modifier

private extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

#Preview {
    MiniMapView(
        messages: [
            ChatMessage(role: "user", content: "What is SwiftUI?"),
            ChatMessage(role: "assistant", content: "SwiftUI is Apple's declarative UI framework for building apps across all Apple platforms."),
            ChatMessage(role: "user", content: "How does it compare to UIKit?"),
            ChatMessage(role: "assistant", content: "SwiftUI uses a declarative approach while UIKit is imperative. SwiftUI manages state and updates views automatically."),
        ],
        onSelectMessage: { id in
            print("Navigate to message: \(id)")
        }
    )
}
