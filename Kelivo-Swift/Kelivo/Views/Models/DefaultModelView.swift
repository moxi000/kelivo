import SwiftUI
import SwiftData

struct DefaultModelView: View {
    @Query(sort: \ProviderConfig.sortOrder) private var providers: [ProviderConfig]

    @State private var showChatModelPicker = false
    @State private var showEmbeddingModelPicker = false
    @State private var defaultChatModelId = ""
    @State private var defaultEmbeddingModelId = ""

    private var allEnabledModels: [ModelConfig] {
        providers
            .filter { $0.isEnabled }
            .flatMap { $0.models.filter { $0.isEnabled } }
            .sorted { $0.sortOrder < $1.sortOrder }
    }

    private var defaultChatModel: ModelConfig? {
        allEnabledModels.first { $0.id == defaultChatModelId }
    }

    private var defaultEmbeddingModel: ModelConfig? {
        allEnabledModels.first { $0.id == defaultEmbeddingModelId }
    }

    var body: some View {
        Form {
            // MARK: - Default Chat Model
            Section {
                Button {
                    showChatModelPicker = true
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(String(localized: "Default Chat Model"))
                                .font(.body)
                                .foregroundStyle(.primary)
                            if let model = defaultChatModel {
                                Text(model.displayName.isEmpty ? model.modelId : model.displayName)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text(String(localized: "Not Selected"))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
            } header: {
                Text(String(localized: "Chat"))
            } footer: {
                Text(String(localized: "The model used for new conversations by default."))
            }

            // MARK: - Default Embedding Model
            Section {
                Button {
                    showEmbeddingModelPicker = true
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(String(localized: "Default Embedding Model"))
                                .font(.body)
                                .foregroundStyle(.primary)
                            if let model = defaultEmbeddingModel {
                                Text(model.displayName.isEmpty ? model.modelId : model.displayName)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text(String(localized: "Not Selected"))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
            } header: {
                Text(String(localized: "Embedding"))
            } footer: {
                Text(String(localized: "The model used for text embeddings and similarity search."))
            }

            // MARK: - Info
            Section {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.tint)
                        .font(.body)
                    Text(String(localized: "Individual assistants can override the default model in their settings. The defaults here apply only when no per-assistant override is set."))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            } header: {
                Text(String(localized: "Per-Assistant Override"))
            }
        }
        .formStyle(.grouped)
        .navigationTitle(String(localized: "Default Models"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            loadDefaults()
        }
        .sheet(isPresented: $showChatModelPicker) {
            ModelSelectSheet(
                selectedModelId: $defaultChatModelId,
                onSelect: { model in
                    setDefaultChat(model)
                }
            )
        }
        .sheet(isPresented: $showEmbeddingModelPicker) {
            ModelSelectSheet(
                selectedModelId: $defaultEmbeddingModelId,
                onSelect: { model in
                    setDefaultEmbedding(model)
                }
            )
        }
    }

    // MARK: - Actions

    private func loadDefaults() {
        if let existing = allEnabledModels.first(where: { $0.isDefault }) {
            defaultChatModelId = existing.id
        }
    }

    private func setDefaultChat(_ model: ModelConfig) {
        // Clear existing chat defaults
        for provider in providers {
            for m in provider.models {
                m.isDefault = false
            }
        }
        model.isDefault = true
        defaultChatModelId = model.id
    }

    private func setDefaultEmbedding(_ model: ModelConfig) {
        defaultEmbeddingModelId = model.id
    }
}

#Preview {
    NavigationStack {
        DefaultModelView()
    }
}
