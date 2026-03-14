import SwiftUI
import SwiftData

struct AssistantSelectView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Assistant.name) private var assistants: [Assistant]

    @Binding var selectedId: String?
    let onSelect: (Assistant?) -> Void

    @State private var searchText = ""

    private var filteredAssistants: [Assistant] {
        guard !searchText.isEmpty else { return assistants }
        return assistants.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List {
            // MARK: - Default Option
            Section {
                Button {
                    selectedId = nil
                    onSelect(nil)
                    dismiss()
                } label: {
                    HStack(spacing: 12) {
                        Text("🤖")
                            .font(.title2)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(String(localized: "Default Assistant"))
                                .font(.body)
                            Text(String(localized: "Use global settings"))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        if selectedId == nil {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.tint)
                        }
                    }
                }
                .buttonStyle(.plain)
            }

            // MARK: - Assistant List
            Section {
                ForEach(filteredAssistants) { assistant in
                    Button {
                        selectedId = assistant.id
                        onSelect(assistant)
                        dismiss()
                    } label: {
                        HStack(spacing: 12) {
                            Text(assistant.avatar ?? "🤖")
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(assistant.name)
                                    .font(.body)

                                if !assistant.systemPrompt.isEmpty {
                                    Text(assistant.systemPrompt)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                }
                            }

                            Spacer()

                            if selectedId == assistant.id {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.tint)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            } header: {
                Text(String(localized: "Assistants"))
            }
        }
        .searchable(text: $searchText, prompt: String(localized: "Search assistants"))
        .navigationTitle(String(localized: "Select Assistant"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .overlay {
            if assistants.isEmpty {
                ContentUnavailableView {
                    Label(String(localized: "No Assistants"), systemImage: "person.2")
                } description: {
                    Text(String(localized: "Create an assistant first."))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AssistantSelectView(selectedId: .constant(nil)) { _ in }
    }
}
