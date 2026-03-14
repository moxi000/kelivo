import SwiftUI

struct ModelDetailView: View {
    let model: ModelConfig

    var body: some View {
        Form {
            // MARK: - Identity
            Section {
                LabeledContent(String(localized: "Model ID")) {
                    Text(model.modelId)
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                }

                if !model.displayName.isEmpty {
                    LabeledContent(String(localized: "Display Name")) {
                        Text(model.displayName)
                    }
                }

                LabeledContent(String(localized: "Status")) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(model.isEnabled ? .green : .gray)
                            .frame(width: 8, height: 8)
                        Text(model.isEnabled ? String(localized: "Enabled") : String(localized: "Disabled"))
                            .foregroundStyle(.secondary)
                    }
                }

                if model.isDefault {
                    LabeledContent(String(localized: "Default")) {
                        Text(String(localized: "Yes"))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(.tint.opacity(0.15), in: Capsule())
                            .foregroundStyle(.tint)
                    }
                }
            } header: {
                Text(String(localized: "Model Info"))
            }

            // MARK: - Modalities
            Section {
                LabeledContent(String(localized: "Input")) {
                    HStack(spacing: 8) {
                        modalityBadge(icon: "text.alignleft", label: String(localized: "Text"), active: true)
                        modalityBadge(icon: "photo", label: String(localized: "Image"), active: model.supportsVision)
                    }
                }

                LabeledContent(String(localized: "Output")) {
                    modalityBadge(icon: "text.alignleft", label: String(localized: "Text"), active: true)
                }
            } header: {
                Text(String(localized: "Modalities"))
            }

            // MARK: - Abilities
            Section {
                abilityRow(
                    icon: "eye",
                    title: String(localized: "Vision"),
                    description: String(localized: "Can process image inputs."),
                    active: model.supportsVision,
                    color: .blue
                )
                abilityRow(
                    icon: "wrench",
                    title: String(localized: "Tool Use"),
                    description: String(localized: "Can call external tools and functions."),
                    active: model.supportsTools,
                    color: .orange
                )
                abilityRow(
                    icon: "brain",
                    title: String(localized: "Reasoning"),
                    description: String(localized: "Extended thinking and chain-of-thought."),
                    active: model.supportsReasoning,
                    color: .purple
                )
            } header: {
                Text(String(localized: "Abilities"))
            }

            // MARK: - Context & Limits
            Section {
                if let ctx = model.maxContextTokens {
                    LabeledContent(String(localized: "Context Window")) {
                        Text(formatTokenCount(ctx))
                            .monospacedDigit()
                    }
                }
                if let max = model.maxOutputTokens {
                    LabeledContent(String(localized: "Max Output Tokens")) {
                        Text(formatTokenCount(max))
                            .monospacedDigit()
                    }
                }
                if model.maxContextTokens == nil && model.maxOutputTokens == nil {
                    Text(String(localized: "No token limit information available."))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text(String(localized: "Token Limits"))
            }

            // MARK: - Provider
            if let provider = model.provider {
                Section {
                    LabeledContent(String(localized: "Provider")) {
                        Text(provider.name)
                    }
                    LabeledContent(String(localized: "API Type")) {
                        Text(provider.apiType.rawValue.capitalized)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text(String(localized: "Provider"))
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle(model.displayName.isEmpty ? model.modelId : model.displayName)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Components

    private func modalityBadge(icon: String, label: String, active: Bool) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(label)
        }
        .font(.caption)
        .foregroundStyle(active ? .primary : .quaternary)
    }

    private func abilityRow(
        icon: String,
        title: String,
        description: String,
        active: Bool,
        color: Color
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(active ? color : .quaternary)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundStyle(active ? .primary : .secondary)
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: active ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(active ? .green : .quaternary)
        }
        .padding(.vertical, 2)
    }

    // MARK: - Helpers

    private func formatTokenCount(_ count: Int) -> String {
        if count >= 1_000_000 {
            return String(format: "%.1fM tokens", Double(count) / 1_000_000)
        } else if count >= 1_000 {
            return "\(count / 1_000)K tokens"
        }
        return "\(count) tokens"
    }
}

#Preview {
    NavigationStack {
        ModelDetailView(
            model: ModelConfig(
                providerId: "test",
                modelId: "gpt-4o",
                displayName: "GPT-4o",
                maxContextTokens: 128_000,
                maxOutputTokens: 16_384,
                supportsVision: true,
                supportsTools: true,
                supportsReasoning: false
            )
        )
    }
}
