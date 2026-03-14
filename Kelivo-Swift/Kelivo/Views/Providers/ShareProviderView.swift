import SwiftUI

struct ShareProviderView: View {
    let provider: ProviderConfig

    @Environment(\.dismiss) private var dismiss

    @State private var includeName = true
    @State private var includeBaseUrl = true
    @State private var includeApiType = true
    @State private var includeApiKey = false
    @State private var includeCustomHeaders = false
    @State private var includeModels = true
    @State private var copied = false

    private var exportJson: String {
        var dict: [String: Any] = [:]

        if includeName {
            dict["name"] = provider.name
        }
        if includeApiType {
            dict["apiType"] = provider.apiType.rawValue
        }
        if includeBaseUrl {
            dict["baseUrl"] = provider.baseUrl
        }
        if includeApiKey, let ref = provider.apiKeyRef {
            dict["apiKeyRef"] = ref
        }
        if includeCustomHeaders, let headers = provider.customHeadersJson {
            dict["customHeaders"] = headers
        }
        if includeModels {
            let models: [[String: Any]] = provider.models.map { model in
                var m: [String: Any] = [
                    "modelId": model.modelId,
                    "displayName": model.displayName,
                    "isEnabled": model.isEnabled,
                ]
                if let ctx = model.maxContextTokens { m["maxContextTokens"] = ctx }
                if let max = model.maxOutputTokens { m["maxOutputTokens"] = max }
                if model.supportsVision { m["supportsVision"] = true }
                if model.supportsTools { m["supportsTools"] = true }
                if model.supportsReasoning { m["supportsReasoning"] = true }
                return m
            }
            dict["models"] = models
        }

        guard let data = try? JSONSerialization.data(
            withJSONObject: dict,
            options: [.prettyPrinted, .sortedKeys]
        ),
              let json = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return json
    }

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Field Selection
                Section {
                    Toggle(String(localized: "Name"), isOn: $includeName)
                    Toggle(String(localized: "API Type"), isOn: $includeApiType)
                    Toggle(String(localized: "Base URL"), isOn: $includeBaseUrl)
                    Toggle(String(localized: "API Key Reference"), isOn: $includeApiKey)
                    Toggle(String(localized: "Custom Headers"), isOn: $includeCustomHeaders)
                    Toggle(String(localized: "Models"), isOn: $includeModels)
                } header: {
                    Text(String(localized: "Include Fields"))
                } footer: {
                    Text(String(localized: "API key references are excluded by default for security."))
                }

                // MARK: - Preview
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(exportJson)
                            .font(.caption.monospaced())
                            .textSelection(.enabled)
                    }
                    .frame(minHeight: 120)
                } header: {
                    Text(String(localized: "JSON Preview"))
                }

                // MARK: - Actions
                Section {
                    Button {
                        copyToClipboard()
                    } label: {
                        Label(
                            copied ? String(localized: "Copied!") : String(localized: "Copy to Clipboard"),
                            systemImage: copied ? "checkmark" : "doc.on.doc"
                        )
                    }

                    ShareLink(
                        item: exportJson,
                        subject: Text(provider.name),
                        message: Text(String(localized: "Kelivo Provider Configuration"))
                    ) {
                        Label(String(localized: "Share"), systemImage: "square.and.arrow.up")
                    }
                }
            }
            .formStyle(.grouped)
            .navigationTitle(String(localized: "Share Provider"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Done")) {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - Actions

    private func copyToClipboard() {
        #if os(iOS)
        UIPasteboard.general.string = exportJson
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(exportJson, forType: .string)
        #endif
        copied = true
        Task {
            try? await Task.sleep(for: .seconds(2))
            copied = false
        }
    }
}

#Preview {
    ShareProviderView(
        provider: ProviderConfig(
            name: "OpenAI",
            apiType: .openai,
            baseUrl: "https://api.openai.com/v1"
        )
    )
}
