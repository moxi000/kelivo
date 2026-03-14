#if os(macOS)
import SwiftUI

// MARK: - Settings Pane Definition

private enum SettingsPane: String, CaseIterable, Identifiable {
    case general
    case display
    case providers
    case assistants
    case mcp
    case search
    case tts
    case quickPhrases
    case injection
    case worldBook
    case backup
    case network
    case hotkeys
    case about

    var id: String { rawValue }

    var title: String {
        switch self {
        case .general: String(localized: "general")
        case .display: String(localized: "Display")
        case .providers: String(localized: "Providers")
        case .assistants: String(localized: "Assistants")
        case .mcp: String(localized: "MCP Servers")
        case .search: String(localized: "Search Services")
        case .tts: String(localized: "Text to Speech")
        case .quickPhrases: String(localized: "Quick Phrases")
        case .injection: String(localized: "Instruction Injection")
        case .worldBook: String(localized: "World Book")
        case .backup: String(localized: "Backup & Sync")
        case .network: String(localized: "Network Proxy")
        case .hotkeys: String(localized: "hotkeys")
        case .about: String(localized: "About")
        }
    }

    var icon: String {
        switch self {
        case .general: "gearshape"
        case .display: "paintbrush"
        case .providers: "server.rack"
        case .assistants: "person.2"
        case .mcp: "point.3.connected.trianglepath.dotted"
        case .search: "magnifyingglass"
        case .tts: "speaker.wave.3"
        case .quickPhrases: "text.bubble"
        case .injection: "syringe"
        case .worldBook: "book.closed"
        case .backup: "icloud.and.arrow.up"
        case .network: "network"
        case .hotkeys: "keyboard"
        case .about: "info.circle"
        }
    }

    var iconColor: Color {
        switch self {
        case .general: .gray
        case .display: .purple
        case .providers: .blue
        case .assistants: .green
        case .mcp: .orange
        case .search: .indigo
        case .tts: .pink
        case .quickPhrases: .mint
        case .injection: .red
        case .worldBook: .brown
        case .backup: .teal
        case .network: .gray
        case .hotkeys: .cyan
        case .about: .secondary
        }
    }
}

// MARK: - MacSettingsView

/// macOS Settings window using NavigationSplitView with sidebar panes.
/// Intended to be used with a `.settings` WindowGroup scene on macOS.
struct MacSettingsView: View {
    @State private var selectedPane: SettingsPane? = .general

    var body: some View {
        NavigationSplitView {
            List(SettingsPane.allCases, selection: $selectedPane) { pane in
                Label {
                    Text(pane.title)
                } icon: {
                    Image(systemName: pane.icon)
                        .foregroundStyle(pane.iconColor)
                }
                .tag(pane)
            }
            .navigationTitle(String(localized: "Settings"))
            .listStyle(.sidebar)
        } detail: {
            detailView(for: selectedPane)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationSplitViewStyle(.balanced)
        .frame(minWidth: 700, minHeight: 500)
    }

    // MARK: - Detail Router

    @ViewBuilder
    private func detailView(for pane: SettingsPane?) -> some View {
        switch pane {
        case .general:
            generalPane
        case .display:
            DisplaySettingsView()
        case .providers:
            ProvidersListView()
        case .assistants:
            AssistantListView()
        case .mcp:
            MCPServersView()
        case .search:
            SearchServicesView()
        case .tts:
            TTSSettingsView()
        case .quickPhrases:
            QuickPhrasesView()
        case .injection:
            InstructionInjectionView()
        case .worldBook:
            WorldBookView()
        case .backup:
            BackupView()
        case .network:
            NetworkProxyView()
        case .hotkeys:
            MacHotkeysView()
        case .about:
            AboutView()
        case nil:
            ContentUnavailableView(
                String(localized: "Select a Section"),
                systemImage: "sidebar.left",
                description: Text(String(localized: "Choose a settings category from the sidebar."))
            )
        }
    }

    // MARK: - General Pane

    private var generalPane: some View {
        Form {
            Section(String(localized: "general")) {
                // Placeholder for general settings such as launch behavior,
                // language, appearance mode, etc.
                Text(String(localized: "generalSettingsDescription"))
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .navigationTitle(String(localized: "general"))
    }
}

// MARK: - Preview

#Preview {
    MacSettingsView()
        .frame(width: 800, height: 600)
}
#endif
