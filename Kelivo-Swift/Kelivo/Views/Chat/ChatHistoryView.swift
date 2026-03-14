import SwiftUI
import SwiftData

// MARK: - ChatHistoryView

/// Searchable list of past conversations with message previews.
/// Supports filtering by date range. Tap a row to navigate to that conversation.
struct ChatHistoryView: View {
    @Query(sort: \Conversation.updatedAt, order: .reverse)
    private var conversations: [Conversation]

    @Environment(\.modelContext) private var modelContext

    @State private var searchText = ""
    @State private var startDate: Date = Calendar.current.date(
        byAdding: .month, value: -1, to: .now
    ) ?? .now
    @State private var endDate: Date = .now
    @State private var isFilteringByDate = false

    var onSelect: ((Conversation) -> Void)?

    // MARK: Body

    var body: some View {
        List {
            dateFilterSection
            conversationListSection
        }
        .searchable(
            text: $searchText,
            prompt: String(localized: "searchConversations")
        )
        .navigationTitle(String(localized: "chatHistory"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
    }

    // MARK: - Date Filter Section

    private var dateFilterSection: some View {
        Section {
            Toggle(String(localized: "filterByDate"), isOn: $isFilteringByDate)

            if isFilteringByDate {
                DatePicker(
                    String(localized: "startDate"),
                    selection: $startDate,
                    displayedComponents: .date
                )
                DatePicker(
                    String(localized: "endDate"),
                    selection: $endDate,
                    displayedComponents: .date
                )
            }
        }
    }

    // MARK: - Conversation List

    private var conversationListSection: some View {
        Section {
            if filteredConversations.isEmpty {
                ContentUnavailableView(
                    String(localized: "noResults"),
                    systemImage: "magnifyingglass",
                    description: Text(String(localized: "noConversationsFound"))
                )
            } else {
                ForEach(filteredConversations) { conversation in
                    Button {
                        onSelect?(conversation)
                    } label: {
                        conversationRow(conversation)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func conversationRow(_ conversation: Conversation) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(conversation.title)
                .font(.headline)
                .lineLimit(1)

            HStack {
                Text(conversation.updatedAt, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Text(
                    String(
                        localized: "\(conversation.messageIds.count) messages"
                    )
                )
                .font(.caption)
                .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }

    // MARK: - Filtering

    private var filteredConversations: [Conversation] {
        var result = conversations

        // Text search filter
        if !searchText.isEmpty {
            result = result.filter { conversation in
                conversation.title.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Date range filter
        if isFilteringByDate {
            result = result.filter { conversation in
                conversation.updatedAt >= startDate
                    && conversation.updatedAt <= endDate
            }
        }

        return result
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ChatHistoryView { conversation in
            print("Selected: \(conversation.title)")
        }
    }
    .modelContainer(for: Conversation.self, inMemory: true)
}
