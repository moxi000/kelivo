import SwiftUI

struct LanguageSelectView: View {

    // MARK: - Language Definition

    private struct AppLanguage: Identifiable {
        let id: String       // locale identifier or empty for system
        let name: String     // display name
        let nativeName: String
    }

    private let languages: [AppLanguage] = [
        AppLanguage(
            id: "",
            name: String(localized: "System Language"),
            nativeName: ""
        ),
        AppLanguage(
            id: "en",
            name: String(localized: "English"),
            nativeName: "English"
        ),
        AppLanguage(
            id: "zh-Hans",
            name: String(localized: "Chinese Simplified"),
            nativeName: "\u{7B80}\u{4F53}\u{4E2D}\u{6587}"
        ),
        AppLanguage(
            id: "zh-Hant",
            name: String(localized: "Chinese Traditional"),
            nativeName: "\u{7E41}\u{9AD4}\u{4E2D}\u{6587}"
        ),
    ]

    @State private var selectedLocale: String = ""
    @State private var showRestartHint: Bool = false

    var body: some View {
        Form {
            Section {
                ForEach(languages) { language in
                    Button {
                        selectLanguage(language.id)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(language.name)
                                    .foregroundStyle(.primary)
                                if !language.nativeName.isEmpty
                                    && language.nativeName != language.name
                                {
                                    Text(language.nativeName)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Spacer()

                            if selectedLocale == language.id {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.tint)
                                    .fontWeight(.semibold)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            } header: {
                Text(String(localized: "Language"))
            } footer: {
                Text(
                    String(
                        localized:
                            "Selecting \"System Language\" follows your device language settings."
                    )
                )
            }

            if showRestartHint {
                Section {
                    Label {
                        Text(
                            String(
                                localized:
                                    "Please restart the app for the language change to take full effect."
                            )
                        )
                        .font(.subheadline)
                    } icon: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundStyle(.orange)
                    }
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle(String(localized: "Language"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear(perform: loadSettings)
    }

    // MARK: - Actions

    private func selectLanguage(_ localeId: String) {
        guard localeId != selectedLocale else { return }
        selectedLocale = localeId
        showRestartHint = true

        let defaults = UserDefaults.standard
        if localeId.isEmpty {
            defaults.removeObject(forKey: "settings.appLocale")
        } else {
            defaults.set(localeId, forKey: "settings.appLocale")
        }
    }

    private func loadSettings() {
        selectedLocale = UserDefaults.standard.string(forKey: "settings.appLocale") ?? ""
    }
}

#Preview {
    NavigationStack {
        LanguageSelectView()
    }
}
