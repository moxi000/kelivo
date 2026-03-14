import SwiftUI
import SwiftData

struct ModelSelectSheet: View {
    @Binding var selectedModelId: String
    var onSelect: (ModelConfig) -> Void

    @Environment(\.dismiss) private var dismiss
    @Query(sort: \ProviderConfig.sortOrder) private var providers: [ProviderConfig]
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                if filteredProviders.isEmpty {
                    ContentUnavailableView {
                        Label(String(localized: "No Models"), systemImage: "cpu")
                    } description: {
                        Text(String(localized: "No models match your search, or no providers have been configured."))
                    }
                } else {
                    ForEach(filteredProviders) { provider in
                        Section {
                            ForEach(filteredModels(for: provider)) { model in
                                Button {
                                    selectedModelId = model.id
                                    onSelect(model)
                                    dismiss()
                                } label: {
                                    modelRow(model)
                                }
                                .buttonStyle(.plain)
                            }
                        } header: {
                            Label(provider.name, systemImage: "server.rack")
                        }
                    }
                }
            }
            .searchable(
                text: $searchText,
                prompt: String(localized: "Search models")
            )
            .navigationTitle(String(localized: "Select Model"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - Row

    private func modelRow(_ model: ModelConfig) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(model.displayName.isEmpty ? model.modelId : model.displayName)
                    .font(.body)
                    .foregroundStyle(.primary)

                HStack(spacing: 6) {
                    if model.supportsVision {
                        capabilityIcon("eye", color: .blue)
                    }
                    if model.supportsTools {
                        capabilityIcon("wrench", color: .orange)
                    }
                    if model.supportsReasoning {
                        capabilityIcon("brain", color: .purple)
                    }
                }
            }

            Spacer()

            if model.id == selectedModelId {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.tint)
            }
        }
        .padding(.vertical, 2)
        .contentShape(Rectangle())
    }

    private func capabilityIcon(_ icon: String, color: Color) -> some View {
        Image(systemName: icon)
            .font(.caption2)
            .foregroundStyle(color)
    }

    // MARK: - Filtering

    private var filteredProviders: [ProviderConfig] {
        providers.filter { provider in
            provider.isEnabled && !filteredModels(for: provider).isEmpty
        }
    }

    private func filteredModels(for provider: ProviderConfig) -> [ModelConfig] {
        let enabled = provider.models
            .filter { $0.isEnabled }
            .sorted { $0.sortOrder < $1.sortOrder }

        guard !searchText.isEmpty else { return enabled }
        return enabled.filter { model in
            model.modelId.localizedCaseInsensitiveContains(searchText) ||
            model.displayName.localizedCaseInsensitiveContains(searchText)
        }
    }
}

#Preview {
    ModelSelectSheet(
        selectedModelId: .constant("gpt-4o"),
        onSelect: { _ in }
    )
}
