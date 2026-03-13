import SwiftUI

// MARK: - Settings Section Definition

private struct SettingsSection: Identifiable {
    let id: String
    let title: String
    let icon: String
    let iconColor: Color
}

private let settingsSections: [SettingsSection] = [
    SettingsSection(id: "display", title: String(localized: "Display"), icon: "paintbrush", iconColor: .purple),
    SettingsSection(id: "providers", title: String(localized: "Providers"), icon: "server.rack", iconColor: .blue),
    SettingsSection(id: "models", title: String(localized: "Models"), icon: "cpu", iconColor: .cyan),
    SettingsSection(id: "assistants", title: String(localized: "Assistants"), icon: "person.2", iconColor: .green),
    SettingsSection(id: "mcp", title: String(localized: "MCP Servers"), icon: "point.3.connected.trianglepath.dotted", iconColor: .orange),
    SettingsSection(id: "search", title: String(localized: "Search Services"), icon: "magnifyingglass", iconColor: .indigo),
    SettingsSection(id: "quickPhrases", title: String(localized: "Quick Phrases"), icon: "text.bubble", iconColor: .mint),
    SettingsSection(id: "injection", title: String(localized: "Instruction Injection"), icon: "syringe", iconColor: .red),
    SettingsSection(id: "worldBook", title: String(localized: "World Book"), icon: "book.closed", iconColor: .brown),
    SettingsSection(id: "backup", title: String(localized: "Backup & Sync"), icon: "icloud.and.arrow.up", iconColor: .teal),
    SettingsSection(id: "tts", title: String(localized: "Text to Speech"), icon: "speaker.wave.3", iconColor: .pink),
    SettingsSection(id: "proxy", title: String(localized: "Network Proxy"), icon: "network", iconColor: .gray),
    SettingsSection(id: "storage", title: String(localized: "Storage Space"), icon: "externaldrive", iconColor: .orange),
    SettingsSection(id: "about", title: String(localized: "About"), icon: "info.circle", iconColor: .secondary),
]

// MARK: - SettingsView

struct SettingsView: View {
    @State private var selectedSection: String? = "display"

    var body: some View {
        #if os(macOS)
        macOSSettings
        #else
        iOSSettings
        #endif
    }

    // MARK: - macOS: NavigationSplitView

    #if os(macOS)
    private var macOSSettings: some View {
        NavigationSplitView {
            List(settingsSections, selection: $selectedSection) { section in
                Label {
                    Text(section.title)
                } icon: {
                    Image(systemName: section.icon)
                        .foregroundStyle(section.iconColor)
                }
                .tag(section.id)
            }
            .navigationTitle(String(localized: "Settings"))
            .listStyle(.sidebar)
        } detail: {
            detailView(for: selectedSection)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationSplitViewStyle(.balanced)
    }
    #endif

    // MARK: - iOS: Grouped List

    #if os(iOS)
    private var iOSSettings: some View {
        NavigationStack {
            List {
                Section {
                    settingsRow(settingsSections[0]) // Display
                }

                Section(header: Text(String(localized: "AI Configuration"))) {
                    settingsRow(settingsSections[1]) // Providers
                    settingsRow(settingsSections[2]) // Models
                    settingsRow(settingsSections[3]) // Assistants
                }

                Section(header: Text(String(localized: "Tools"))) {
                    settingsRow(settingsSections[4]) // MCP
                    settingsRow(settingsSections[5]) // Search
                }

                Section(header: Text(String(localized: "Content"))) {
                    settingsRow(settingsSections[6]) // Quick Phrases
                    settingsRow(settingsSections[7]) // Injection
                    settingsRow(settingsSections[8]) // World Book
                }

                Section(header: Text(String(localized: "Data"))) {
                    settingsRow(settingsSections[9])  // Backup
                    settingsRow(settingsSections[10]) // TTS
                    settingsRow(settingsSections[11]) // Proxy
                    settingsRow(settingsSections[12]) // Storage
                }

                Section {
                    settingsRow(settingsSections[13]) // About
                }
            }
            .navigationTitle(String(localized: "Settings"))
            .listStyle(.insetGrouped)
        }
    }

    private func settingsRow(_ section: SettingsSection) -> some View {
        NavigationLink {
            detailView(for: section.id)
        } label: {
            Label {
                Text(section.title)
            } icon: {
                Image(systemName: section.icon)
                    .foregroundStyle(section.iconColor)
            }
        }
    }
    #endif

    // MARK: - Detail View Router

    @ViewBuilder
    private func detailView(for sectionId: String?) -> some View {
        switch sectionId {
        case "display":
            DisplaySettingsView()
        case "providers":
            ProvidersListView()
        case "models":
            ModelSelectionView()
        case "assistants":
            AssistantListView()
        case "mcp":
            MCPServersView()
        case "search":
            SearchServicesView()
        case "quickPhrases":
            QuickPhrasesView()
        case "injection":
            InstructionInjectionView()
        case "worldBook":
            WorldBookView()
        case "backup":
            BackupView()
        case "tts":
            Text(String(localized: "Text to Speech"))
                .foregroundStyle(.secondary)
        case "proxy":
            NetworkProxyView()
        case "storage":
            StorageSpaceView()
        case "about":
            AboutView()
        default:
            ContentUnavailableView(
                String(localized: "Select a Section"),
                systemImage: "sidebar.left",
                description: Text(String(localized: "Choose a settings category from the sidebar."))
            )
        }
    }
}

#Preview {
    SettingsView()
}
