import SwiftUI
import SwiftData

struct ModelSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ProviderConfig.sortOrder) private var providers: [ProviderConfig]
    @State private var searchText = ""

    private var filteredProviders: [ProviderConfig] {
        providers.filter { provider in
            !provider.models.isEmpty
        }
    }

    var body: some View {
        List {
            if filteredProviders.isEmpty {
                ContentUnavailableView {
                    Label(String(localized: "No Models"), systemImage: "cpu")
                } description: {
                    Text(String(localized: "Add a provider and fetch its models to see them here."))
                }
            } else {
                ForEach(filteredProviders) { provider in
                    Section {
                        ForEach(filteredModels(for: provider)) { model in
                            NavigationLink {
                                ModelEditView(model: model)
                            } label: {
                                modelRow(model)
                            }
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
        .navigationTitle(String(localized: "Models"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Row

    private func modelRow(_ model: ModelConfig) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(model.displayName.isEmpty ? model.modelId : model.displayName)
                        .font(.body)

                    if model.isDefault {
                        Text(String(localized: "Default"))
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.tint.opacity(0.15), in: Capsule())
                            .foregroundStyle(.tint)
                    }
                }

                HStack(spacing: 8) {
                    capabilityBadge(
                        icon: "eye",
                        label: String(localized: "Vision"),
                        active: model.supportsVision
                    )
                    capabilityBadge(
                        icon: "wrench",
                        label: String(localized: "Tools"),
                        active: model.supportsTools
                    )
                    capabilityBadge(
                        icon: "brain",
                        label: String(localized: "Reasoning"),
                        active: model.supportsReasoning
                    )
                }

                if let ctx = model.maxContextTokens {
                    Text(String(localized: "Context: \(formatTokenCount(ctx))"))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if model.isEnabled {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            } else {
                Image(systemName: "circle")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
        .contextMenu {
            Button {
                setAsDefault(model)
            } label: {
                Label(String(localized: "Set as Default"), systemImage: "star")
            }
            .disabled(model.isDefault)

            Button {
                model.isEnabled.toggle()
            } label: {
                Label(
                    model.isEnabled ? String(localized: "Disable") : String(localized: "Enable"),
                    systemImage: model.isEnabled ? "xmark.circle" : "checkmark.circle"
                )
            }
        }
    }

    private func capabilityBadge(icon: String, label: String, active: Bool) -> some View {
        HStack(spacing: 2) {
            Image(systemName: icon)
            Text(label)
        }
        .font(.caption2)
        .foregroundStyle(active ? .primary : .quaternary)
    }

    // MARK: - Filtering

    private func filteredModels(for provider: ProviderConfig) -> [ModelConfig] {
        let models = provider.models.sorted(by: { $0.sortOrder < $1.sortOrder })
        guard !searchText.isEmpty else { return models }
        return models.filter { model in
            model.modelId.localizedCaseInsensitiveContains(searchText) ||
            model.displayName.localizedCaseInsensitiveContains(searchText)
        }
    }

    // MARK: - Actions

    private func setAsDefault(_ model: ModelConfig) {
        // Clear existing defaults
        for provider in providers {
            for m in provider.models {
                m.isDefault = false
            }
        }
        model.isDefault = true
    }

    // MARK: - Helpers

    private func formatTokenCount(_ count: Int) -> String {
        if count >= 1_000_000 {
            return "\(count / 1_000_000)M"
        } else if count >= 1_000 {
            return "\(count / 1_000)K"
        }
        return "\(count)"
    }
}

#Preview {
    NavigationStack {
        ModelSelectionView()
    }
}
