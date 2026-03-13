import SwiftUI
import SwiftData

struct AssistantListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Assistant.name) private var assistants: [Assistant]
    @State private var showAddAssistant = false
    @State private var searchText = ""

    private let columns = [
        GridItem(.adaptive(minimum: 160, maximum: 220), spacing: 16),
    ]

    private var filteredAssistants: [Assistant] {
        guard !searchText.isEmpty else { return assistants }
        return assistants.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(filteredAssistants) { assistant in
                    NavigationLink {
                        AssistantEditView(assistant: assistant)
                    } label: {
                        assistantCard(assistant)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        if assistant.deletable {
                            Button(role: .destructive) {
                                modelContext.delete(assistant)
                            } label: {
                                Label(String(localized: "Delete"), systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .searchable(text: $searchText, prompt: String(localized: "Search assistants"))
        .navigationTitle(String(localized: "Assistants"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddAssistant = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddAssistant) {
            NavigationStack {
                AssistantEditView(assistant: nil)
            }
        }
        .overlay {
            if assistants.isEmpty {
                ContentUnavailableView {
                    Label(String(localized: "No Assistants"), systemImage: "person.2")
                } description: {
                    Text(String(localized: "Create an assistant to customize your chat experience."))
                } actions: {
                    Button(String(localized: "Create Assistant")) {
                        showAddAssistant = true
                    }
                    .applyGlassProminentStyle()
                }
            }
        }
    }

    // MARK: - Card

    private func assistantCard(_ assistant: Assistant) -> some View {
        GlassCard(cornerRadius: 16) {
            VStack(spacing: 8) {
                Text(assistant.avatar ?? "🤖")
                    .font(.system(size: 40))

                Text(assistant.name)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundStyle(.primary)

                if !assistant.systemPrompt.isEmpty {
                    Text(assistant.systemPrompt)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }

                if !assistant.deletable {
                    Text(String(localized: "Default"))
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(.tint.opacity(0.15), in: Capsule())
                        .foregroundStyle(.tint)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 120)
        }
    }
}

// MARK: - Glass Button Style Extension

private extension View {
    @ViewBuilder
    func applyGlassProminentStyle() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.buttonStyle(.glassProminent)
        } else {
            self.buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    NavigationStack {
        AssistantListView()
    }
}
