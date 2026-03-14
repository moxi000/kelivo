import SwiftUI
import UniformTypeIdentifiers

struct ImportProviderView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var jsonText = ""
    @State private var parsedConfig: ParsedProviderPreview?
    @State private var parseError: String?
    @State private var showFilePicker = false
    @State private var didImport = false

    var onImport: (String) -> Void = { _ in }

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Input
                Section {
                    TextEditor(text: $jsonText)
                        .font(.caption.monospaced())
                        .frame(minHeight: 120)
                        .scrollContentBackground(.hidden)
                        .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 8))
                        .onChange(of: jsonText) {
                            parseJson()
                        }

                    Button {
                        showFilePicker = true
                    } label: {
                        Label(String(localized: "Choose JSON File"), systemImage: "doc")
                    }
                } header: {
                    Text(String(localized: "Paste or Import JSON"))
                } footer: {
                    if let parseError {
                        Label(parseError, systemImage: "exclamationmark.triangle.fill")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }

                // MARK: - Preview
                if let config = parsedConfig {
                    Section {
                        LabeledContent(String(localized: "Name")) {
                            Text(config.name)
                        }
                        LabeledContent(String(localized: "API Type")) {
                            Text(config.apiType)
                        }
                        LabeledContent(String(localized: "Base URL")) {
                            Text(config.baseUrl)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        if config.modelCount > 0 {
                            LabeledContent(String(localized: "Models")) {
                                Text("\(config.modelCount)")
                                    .monospacedDigit()
                            }
                        }
                    } header: {
                        Text(String(localized: "Preview"))
                    }
                }
            }
            .formStyle(.grouped)
            .navigationTitle(String(localized: "Import Provider"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Import")) {
                        onImport(jsonText)
                        didImport = true
                        dismiss()
                    }
                    .disabled(parsedConfig == nil)
                }
            }
            .fileImporter(
                isPresented: $showFilePicker,
                allowedContentTypes: [UTType.json],
                allowsMultipleSelection: false
            ) { result in
                handleFileImport(result)
            }
        }
    }

    // MARK: - Parsing

    private func parseJson() {
        parsedConfig = nil
        parseError = nil

        guard !jsonText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        guard let data = jsonText.data(using: .utf8),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            parseError = String(localized: "Invalid JSON format.")
            return
        }

        guard let name = dict["name"] as? String else {
            parseError = String(localized: "Missing required field: name")
            return
        }

        let apiType = dict["apiType"] as? String ?? dict["apiTypeRaw"] as? String ?? "unknown"
        let baseUrl = dict["baseUrl"] as? String ?? ""
        let models = dict["models"] as? [[String: Any]]

        parsedConfig = ParsedProviderPreview(
            name: name,
            apiType: apiType,
            baseUrl: baseUrl,
            modelCount: models?.count ?? 0
        )
    }

    private func handleFileImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            guard url.startAccessingSecurityScopedResource() else { return }
            defer { url.stopAccessingSecurityScopedResource() }

            if let data = try? Data(contentsOf: url),
               let text = String(data: data, encoding: .utf8) {
                jsonText = text
            } else {
                parseError = String(localized: "Failed to read file.")
            }
        case .failure(let error):
            parseError = error.localizedDescription
        }
    }
}

// MARK: - Preview Model

private struct ParsedProviderPreview {
    let name: String
    let apiType: String
    let baseUrl: String
    let modelCount: Int
}

#Preview {
    ImportProviderView()
}
