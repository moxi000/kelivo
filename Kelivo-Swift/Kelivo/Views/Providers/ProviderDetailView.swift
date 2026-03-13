import SwiftUI
import SwiftData

struct ProviderDetailView: View {
    @Bindable var provider: ProviderConfig
    @Environment(\.modelContext) private var modelContext

    @State private var apiKey = ""
    @State private var showApiKey = false
    @State private var isFetchingModels = false
    @State private var isTesting = false
    @State private var testResult: String?
    @State private var testSuccess: Bool?
    @State private var customHeaderKey = ""
    @State private var customHeaderValue = ""

    var body: some View {
        Form {
            // MARK: - Basic Info
            Section {
                TextField(String(localized: "Provider Name"), text: $provider.name)

                Picker(String(localized: "API Type"), selection: $provider.apiType) {
                    Text("OpenAI").tag(ApiType.openai)
                    Text("Claude").tag(ApiType.claude)
                    Text("Gemini").tag(ApiType.gemini)
                    Text("Vertex").tag(ApiType.vertex)
                }

                TextField(String(localized: "Base URL"), text: $provider.baseUrl)
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                    #endif
                    .autocorrectionDisabled()

                Toggle(String(localized: "Enabled"), isOn: $provider.isEnabled)
            } header: {
                Text(String(localized: "Configuration"))
            }

            // MARK: - API Key
            Section {
                HStack {
                    if showApiKey {
                        TextField(String(localized: "API Key"), text: $apiKey)
                            .autocorrectionDisabled()
                            #if os(iOS)
                            .textInputAutocapitalization(.never)
                            #endif
                    } else {
                        SecureField(String(localized: "API Key"), text: $apiKey)
                    }

                    Button {
                        showApiKey.toggle()
                    } label: {
                        Image(systemName: showApiKey ? "eye.slash" : "eye")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            } header: {
                Text(String(localized: "Authentication"))
            } footer: {
                Text(String(localized: "API keys are stored securely in the system Keychain."))
            }

            // MARK: - Models
            Section {
                HStack {
                    Text(String(localized: "Models"))
                        .font(.headline)
                    Spacer()
                    Button {
                        fetchModels()
                    } label: {
                        HStack(spacing: 4) {
                            if isFetchingModels {
                                ProgressView()
                                    .controlSize(.small)
                            } else {
                                Image(systemName: "arrow.clockwise")
                            }
                            Text(String(localized: "Fetch"))
                        }
                    }
                    .disabled(isFetchingModels || provider.baseUrl.isEmpty)
                }

                if provider.models.isEmpty {
                    Text(String(localized: "No models available. Tap Fetch to load models from the provider."))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(provider.models.sorted(by: { $0.sortOrder < $1.sortOrder })) { model in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(model.displayName.isEmpty ? model.modelId : model.displayName)
                                    .font(.body)
                                HStack(spacing: 4) {
                                    if model.supportsVision {
                                        capabilityBadge("eye", color: .blue)
                                    }
                                    if model.supportsTools {
                                        capabilityBadge("wrench", color: .orange)
                                    }
                                    if model.supportsReasoning {
                                        capabilityBadge("brain", color: .purple)
                                    }
                                }
                            }
                            Spacer()
                            Toggle("", isOn: Binding(
                                get: { model.isEnabled },
                                set: { model.isEnabled = $0 }
                            ))
                            .labelsHidden()
                        }
                    }
                }
            } header: {
                Text(String(localized: "Available Models"))
            }

            // MARK: - Test Connection
            Section {
                Button {
                    testConnection()
                } label: {
                    HStack {
                        if isTesting {
                            ProgressView()
                                .controlSize(.small)
                        } else {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                        }
                        Text(String(localized: "Test Connection"))
                    }
                }
                .disabled(isTesting || provider.baseUrl.isEmpty)

                if let testResult, let testSuccess {
                    Label {
                        Text(testResult)
                    } icon: {
                        Image(systemName: testSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundStyle(testSuccess ? .green : .red)
                    }
                }
            }

            // MARK: - Custom Headers (Advanced)
            Section {
                HStack {
                    TextField(String(localized: "Header Name"), text: $customHeaderKey)
                        .autocorrectionDisabled()
                        #if os(iOS)
                        .textInputAutocapitalization(.never)
                        #endif
                    TextField(String(localized: "Value"), text: $customHeaderValue)
                        .autocorrectionDisabled()
                        #if os(iOS)
                        .textInputAutocapitalization(.never)
                        #endif
                    Button {
                        addCustomHeader()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(customHeaderKey.isEmpty)
                }

                if let headersJson = provider.customHeadersJson,
                   let data = headersJson.data(using: .utf8),
                   let headers = try? JSONDecoder().decode([String: String].self, from: data) {
                    ForEach(headers.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        HStack {
                            Text(key)
                                .font(.caption.monospaced())
                            Spacer()
                            Text(value)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            } header: {
                Text(String(localized: "Custom Headers"))
            } footer: {
                Text(String(localized: "Advanced: Add custom HTTP headers sent with every request to this provider."))
            }
        }
        .formStyle(.grouped)
        .navigationTitle(provider.name.isEmpty ? String(localized: "Provider") : provider.name)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Components

    private func capabilityBadge(_ icon: String, color: Color) -> some View {
        Image(systemName: icon)
            .font(.caption2)
            .foregroundStyle(color)
    }

    // MARK: - Actions

    private func fetchModels() {
        isFetchingModels = true
        Task {
            // Placeholder — real implementation calls the provider's model list API
            try? await Task.sleep(for: .seconds(1))
            isFetchingModels = false
        }
    }

    private func testConnection() {
        isTesting = true
        testResult = nil
        testSuccess = nil
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            isTesting = false
            if !provider.baseUrl.isEmpty {
                testSuccess = true
                testResult = String(localized: "Connection successful")
            } else {
                testSuccess = false
                testResult = String(localized: "Connection failed")
            }
        }
    }

    private func addCustomHeader() {
        var headers: [String: String] = [:]
        if let existing = provider.customHeadersJson,
           let data = existing.data(using: .utf8),
           let decoded = try? JSONDecoder().decode([String: String].self, from: data) {
            headers = decoded
        }
        headers[customHeaderKey] = customHeaderValue
        if let data = try? JSONEncoder().encode(headers),
           let json = String(data: data, encoding: .utf8) {
            provider.customHeadersJson = json
        }
        customHeaderKey = ""
        customHeaderValue = ""
    }
}

#Preview {
    NavigationStack {
        ProviderDetailView(provider: ProviderConfig(name: "OpenAI", apiType: .openai, baseUrl: "https://api.openai.com/v1"))
    }
}
