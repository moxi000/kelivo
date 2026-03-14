import SwiftUI

// MARK: - Search Engine Option

/// Represents a search engine that can be selected as the active provider.
private struct SearchEngineOption: Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String
    var requiresApiKey: Bool
    var requiresBaseUrl: Bool
}

private let availableEngines: [SearchEngineOption] = [
    SearchEngineOption(id: "duckduckgo", name: "DuckDuckGo", icon: "magnifyingglass", requiresApiKey: false, requiresBaseUrl: false),
    SearchEngineOption(id: "bing", name: "Bing", icon: "globe.americas", requiresApiKey: true, requiresBaseUrl: false),
    SearchEngineOption(id: "brave", name: "Brave", icon: "shield", requiresApiKey: true, requiresBaseUrl: false),
    SearchEngineOption(id: "tavily", name: "Tavily", icon: "doc.text.magnifyingglass", requiresApiKey: true, requiresBaseUrl: false),
    SearchEngineOption(id: "jina", name: "Jina", icon: "doc.richtext", requiresApiKey: true, requiresBaseUrl: false),
    SearchEngineOption(id: "perplexity", name: "Perplexity", icon: "sparkle.magnifyingglass", requiresApiKey: true, requiresBaseUrl: false),
    SearchEngineOption(id: "searxng", name: "SearXNG", icon: "server.rack", requiresApiKey: false, requiresBaseUrl: true),
    SearchEngineOption(id: "exa", name: "Exa", icon: "magnifyingglass.circle", requiresApiKey: true, requiresBaseUrl: false),
]

// MARK: - SearchSettingsView

/// Configures which search service is active, its API key, and search parameters.
/// Corresponds to Flutter: `lib/features/search/widgets/search_settings_sheet.dart`
struct SearchSettingsView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var isSearchEnabled: Bool = true
    @State private var isBuiltInSearchEnabled: Bool = false
    @State private var selectedEngineId: String = "duckduckgo"
    @State private var apiKey: String = ""
    @State private var baseUrl: String = ""
    @State private var maxResults: Int = 5

    /// Whether the current model supports built-in search (e.g. Gemini grounding).
    var supportsBuiltInSearch: Bool = false

    /// Called when settings are saved.
    var onSave: ((_ engineId: String, _ apiKey: String, _ baseUrl: String, _ maxResults: Int, _ enabled: Bool, _ builtIn: Bool) -> Void)?

    private var selectedEngine: SearchEngineOption? {
        availableEngines.first { $0.id == selectedEngineId }
    }

    var body: some View {
        NavigationStack {
            Form {
                // Built-in search toggle (only if model supports it)
                if supportsBuiltInSearch {
                    Section {
                        Toggle(isOn: $isBuiltInSearchEnabled) {
                            Label(String(localized: "Built-in Search"), systemImage: "magnifyingglass")
                        }
                        .onChange(of: isBuiltInSearchEnabled) { _, newValue in
                            if newValue {
                                isSearchEnabled = false
                            }
                        }
                    } header: {
                        Text(String(localized: "Model Search"))
                    } footer: {
                        Text(String(localized: "Use the model's native search capability (e.g. Gemini grounding). When enabled, external search is disabled."))
                    }
                }

                // External search toggle
                if !isBuiltInSearchEnabled {
                    Section {
                        Toggle(isOn: $isSearchEnabled) {
                            Label(String(localized: "Web Search"), systemImage: "globe")
                        }
                    } header: {
                        Text(String(localized: "External Search"))
                    }

                    if isSearchEnabled {
                        // Engine selection
                        Section {
                            Picker(String(localized: "Search Engine"), selection: $selectedEngineId) {
                                ForEach(availableEngines) { engine in
                                    Label(engine.name, systemImage: engine.icon)
                                        .tag(engine.id)
                                }
                            }
                        } header: {
                            Text(String(localized: "Provider"))
                        }

                        // API Key (if required)
                        if let engine = selectedEngine, engine.requiresApiKey {
                            Section {
                                SecureField(String(localized: "API Key"), text: $apiKey)
                            } header: {
                                Text(String(localized: "Authentication"))
                            } footer: {
                                Text(String(localized: "Your API key for \(engine.name). Stored securely in the system Keychain."))
                            }
                        }

                        // Base URL (if required, e.g. SearXNG)
                        if let engine = selectedEngine, engine.requiresBaseUrl {
                            Section {
                                TextField(String(localized: "Base URL"), text: $baseUrl)
                                    .autocorrectionDisabled()
                                    #if os(iOS)
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.URL)
                                    #endif
                            } header: {
                                Text(String(localized: "Server"))
                            } footer: {
                                Text(String(localized: "The URL of your self-hosted \(engine.name) instance."))
                            }
                        }

                        // Max results
                        Section {
                            Stepper(
                                String(localized: "Max Results: \(maxResults)"),
                                value: $maxResults,
                                in: 1...20
                            )
                        } header: {
                            Text(String(localized: "Parameters"))
                        } footer: {
                            Text(String(localized: "Maximum number of search results to include in context."))
                        }

                        // Navigation to full search services config
                        Section {
                            NavigationLink {
                                SearchServicesView()
                            } label: {
                                Label(String(localized: "Manage Search Services"), systemImage: "gearshape")
                            }
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .navigationTitle(String(localized: "Search Settings"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Done")) { handleSave() }
                }
            }
        }
    }

    // MARK: - Actions

    private func handleSave() {
        onSave?(selectedEngineId, apiKey, baseUrl, maxResults, isSearchEnabled, isBuiltInSearchEnabled)
        dismiss()
    }
}

#Preview {
    SearchSettingsView(
        supportsBuiltInSearch: true,
        onSave: { engineId, apiKey, baseUrl, maxResults, enabled, builtIn in
            print("Engine: \(engineId), enabled: \(enabled), builtIn: \(builtIn), maxResults: \(maxResults)")
        }
    )
}
