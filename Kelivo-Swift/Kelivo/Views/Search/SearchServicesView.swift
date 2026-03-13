import SwiftUI

// MARK: - Search Service Entry

private struct SearchServiceEntry: Identifiable {
    let id: String
    let name: String
    let icon: String
    var isEnabled: Bool
    var apiKey: String
    var baseUrl: String
    var isActive: Bool
}

struct SearchServicesView: View {
    @State private var services: [SearchServiceEntry] = [
        SearchServiceEntry(id: "duckduckgo", name: "DuckDuckGo", icon: "magnifyingglass", isEnabled: true, apiKey: "", baseUrl: "", isActive: true),
        SearchServiceEntry(id: "google", name: "Google", icon: "globe", isEnabled: false, apiKey: "", baseUrl: "", isActive: false),
        SearchServiceEntry(id: "bing", name: "Bing", icon: "globe.americas", isEnabled: false, apiKey: "", baseUrl: "", isActive: false),
        SearchServiceEntry(id: "brave", name: "Brave", icon: "shield", isEnabled: false, apiKey: "", baseUrl: "", isActive: false),
        SearchServiceEntry(id: "tavily", name: "Tavily", icon: "doc.text.magnifyingglass", isEnabled: false, apiKey: "", baseUrl: "", isActive: false),
        SearchServiceEntry(id: "jina", name: "Jina", icon: "doc.richtext", isEnabled: false, apiKey: "", baseUrl: "", isActive: false),
        SearchServiceEntry(id: "perplexity", name: "Perplexity", icon: "sparkle.magnifyingglass", isEnabled: false, apiKey: "", baseUrl: "", isActive: false),
        SearchServiceEntry(id: "searxng", name: "SearXNG", icon: "server.rack", isEnabled: false, apiKey: "", baseUrl: "http://localhost:8080", isActive: false),
    ]

    @State private var testQuery = ""
    @State private var isTesting = false

    var body: some View {
        List {
            // MARK: - Active Provider
            Section {
                Picker(String(localized: "Active Provider"), selection: activeProviderBinding) {
                    ForEach(services.filter(\.isEnabled)) { service in
                        Text(service.name).tag(service.id)
                    }
                }
            } header: {
                Text(String(localized: "Active Search Provider"))
            }

            // MARK: - Providers
            ForEach($services) { $service in
                Section {
                    Toggle(service.name, isOn: $service.isEnabled)

                    if service.isEnabled {
                        if service.id != "duckduckgo" {
                            SecureField(String(localized: "API Key"), text: $service.apiKey)
                        }

                        if service.id == "searxng" || service.id == "google" {
                            TextField(String(localized: "Base URL"), text: $service.baseUrl)
                                .autocorrectionDisabled()
                                #if os(iOS)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.URL)
                                #endif
                        }
                    }
                } header: {
                    Label(service.name, systemImage: service.icon)
                }
            }

            // MARK: - Test Search
            Section {
                TextField(String(localized: "Test query"), text: $testQuery)

                Button {
                    testSearch()
                } label: {
                    HStack {
                        if isTesting {
                            ProgressView()
                                .controlSize(.small)
                        }
                        Text(String(localized: "Test Search"))
                    }
                }
                .disabled(testQuery.isEmpty || isTesting)
            } header: {
                Text(String(localized: "Test"))
            }
        }
        .navigationTitle(String(localized: "Search Services"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Bindings

    private var activeProviderBinding: Binding<String> {
        Binding(
            get: { services.first(where: \.isActive)?.id ?? "" },
            set: { newId in
                for i in services.indices {
                    services[i].isActive = (services[i].id == newId)
                }
            }
        )
    }

    // MARK: - Actions

    private func testSearch() {
        isTesting = true
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            isTesting = false
        }
    }
}

#Preview {
    NavigationStack {
        SearchServicesView()
    }
}
