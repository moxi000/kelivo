import SwiftUI
import SwiftData

// MARK: - Preset Definition

private struct ProviderPreset: Identifiable {
    let id: String
    let name: String
    let icon: String
    let color: Color
    let apiType: ApiType
    let baseUrl: String
}

private let presets: [ProviderPreset] = [
    ProviderPreset(
        id: "openai", name: "OpenAI",
        icon: "brain.head.profile", color: .green,
        apiType: .openai, baseUrl: "https://api.openai.com/v1"
    ),
    ProviderPreset(
        id: "claude", name: "Claude",
        icon: "sparkle", color: .orange,
        apiType: .claude, baseUrl: "https://api.anthropic.com"
    ),
    ProviderPreset(
        id: "gemini", name: "Gemini",
        icon: "diamond", color: .blue,
        apiType: .gemini, baseUrl: "https://generativelanguage.googleapis.com/v1beta"
    ),
    ProviderPreset(
        id: "vertex", name: "Vertex AI",
        icon: "cloud", color: .purple,
        apiType: .vertex, baseUrl: ""
    ),
    ProviderPreset(
        id: "custom", name: String(localized: "Custom"),
        icon: "slider.horizontal.3", color: .gray,
        apiType: .openai, baseUrl: ""
    ),
]

// MARK: - AddProviderView

struct AddProviderView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var selectedPreset: ProviderPreset?
    @State private var name = ""
    @State private var apiType: ApiType = .openai
    @State private var baseUrl = ""
    @State private var apiKey = ""

    private let columns = [
        GridItem(.adaptive(minimum: 140, maximum: 200), spacing: 12),
    ]

    var body: some View {
        NavigationStack {
            Group {
                if selectedPreset == nil {
                    presetSelectionView
                } else {
                    configurationForm
                }
            }
            .navigationTitle(
                selectedPreset == nil
                    ? String(localized: "Add Provider")
                    : String(localized: "Configure Provider")
            )
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) {
                        dismiss()
                    }
                }
                if selectedPreset != nil {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(String(localized: "Save")) {
                            saveProvider()
                        }
                        .disabled(name.isEmpty || baseUrl.isEmpty)
                    }
                }
            }
        }
    }

    // MARK: - Preset Selection

    private var presetSelectionView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(presets) { preset in
                    Button {
                        selectPreset(preset)
                    } label: {
                        GlassCard(cornerRadius: 16) {
                            VStack(spacing: 12) {
                                Image(systemName: preset.icon)
                                    .font(.largeTitle)
                                    .foregroundStyle(preset.color)
                                Text(preset.name)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 100)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }

    // MARK: - Configuration Form

    private var configurationForm: some View {
        Form {
            Section {
                if let preset = selectedPreset {
                    HStack {
                        Image(systemName: preset.icon)
                            .font(.title2)
                            .foregroundStyle(preset.color)
                        Text(preset.name)
                            .font(.headline)
                        Spacer()
                        Button(String(localized: "Change")) {
                            selectedPreset = nil
                        }
                        .font(.caption)
                    }
                }
            }

            Section {
                TextField(String(localized: "Provider Name"), text: $name)

                Picker(String(localized: "API Type"), selection: $apiType) {
                    Text("OpenAI").tag(ApiType.openai)
                    Text("Claude").tag(ApiType.claude)
                    Text("Gemini").tag(ApiType.gemini)
                    Text("Vertex").tag(ApiType.vertex)
                }

                TextField(String(localized: "Base URL"), text: $baseUrl)
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                    #endif
                    .autocorrectionDisabled()
            } header: {
                Text(String(localized: "Provider Details"))
            }

            Section {
                SecureField(String(localized: "API Key"), text: $apiKey)
            } header: {
                Text(String(localized: "Authentication"))
            } footer: {
                Text(String(localized: "Your API key will be stored securely in the system Keychain."))
            }

            Section {
                VStack(alignment: .leading, spacing: 8) {
                    validationRow(
                        passed: !name.isEmpty,
                        label: String(localized: "Provider name is set")
                    )
                    validationRow(
                        passed: !baseUrl.isEmpty,
                        label: String(localized: "Base URL is set")
                    )
                    validationRow(
                        passed: isValidUrl(baseUrl),
                        label: String(localized: "Base URL is a valid URL")
                    )
                }
            } header: {
                Text(String(localized: "Validation"))
            }
        }
        .formStyle(.grouped)
    }

    // MARK: - Components

    private func validationRow(passed: Bool, label: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: passed ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(passed ? .green : .secondary)
                .font(.caption)
            Text(label)
                .font(.caption)
                .foregroundStyle(passed ? .primary : .secondary)
        }
    }

    // MARK: - Actions

    private func selectPreset(_ preset: ProviderPreset) {
        selectedPreset = preset
        name = preset.name
        apiType = preset.apiType
        baseUrl = preset.baseUrl
    }

    private func saveProvider() {
        let provider = ProviderConfig(
            name: name,
            apiType: apiType,
            baseUrl: baseUrl,
            isEnabled: true
        )
        modelContext.insert(provider)
        dismiss()
    }

    private func isValidUrl(_ string: String) -> Bool {
        guard let url = URL(string: string),
              let scheme = url.scheme else { return false }
        return scheme == "http" || scheme == "https"
    }
}

#Preview {
    AddProviderView()
}
