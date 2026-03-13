import SwiftUI

struct DisplaySettingsView: View {
    @State private var settings = SettingsViewModel()

    @State private var selectedThemeMode: ThemeMode = .system
    @State private var accentColorHex: String = ""
    @State private var usePureBackground: Bool = false
    @State private var fontFamily: String = ""
    @State private var fontSize: Double = 16
    @State private var codeFontFamily: String = ""
    @State private var showTokenCount: Bool = true
    @State private var showModelName: Bool = true

    private let availableFonts = [
        "", "System Default",
        "SF Pro", "SF Pro",
        "New York", "New York",
        "Menlo", "Menlo",
        "Helvetica Neue", "Helvetica Neue",
    ]

    var body: some View {
        Form {
            // MARK: - Theme Mode
            Section {
                Picker(String(localized: "Appearance"), selection: $selectedThemeMode) {
                    Label(String(localized: "Light"), systemImage: "sun.max")
                        .tag(ThemeMode.light)
                    Label(String(localized: "Dark"), systemImage: "moon")
                        .tag(ThemeMode.dark)
                    Label(String(localized: "System"), systemImage: "circle.lefthalf.filled")
                        .tag(ThemeMode.system)
                }
                #if os(iOS)
                .pickerStyle(.segmented)
                #endif
            } header: {
                Text(String(localized: "Theme"))
            }

            // MARK: - Accent Color
            Section {
                TextField(String(localized: "Accent Color Hex"), text: $accentColorHex)
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    #endif
                    .autocorrectionDisabled()

                Toggle(String(localized: "Pure Background"), isOn: $usePureBackground)
            } header: {
                Text(String(localized: "Colors"))
            } footer: {
                Text(String(localized: "Enter a hex color code (e.g. #3478F6) for the accent color. Pure background removes transparency effects."))
            }

            // MARK: - Typography
            Section {
                Picker(String(localized: "Font Family"), selection: $fontFamily) {
                    Text(String(localized: "System Default")).tag("")
                    Text("SF Pro").tag("SF Pro")
                    Text("New York").tag("New York")
                    Text("Helvetica Neue").tag("Helvetica Neue")
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(String(localized: "Font Size"))
                        Spacer()
                        Text("\(Int(fontSize)) pt")
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                    Slider(value: $fontSize, in: 12...24, step: 1)
                }

                Picker(String(localized: "Code Font"), selection: $codeFontFamily) {
                    Text(String(localized: "System Default")).tag("")
                    Text("Menlo").tag("Menlo")
                    Text("SF Mono").tag("SF Mono")
                    Text("Courier New").tag("Courier New")
                }
            } header: {
                Text(String(localized: "Typography"))
            }

            // MARK: - Display Options
            Section {
                Toggle(String(localized: "Show Token Count"), isOn: $showTokenCount)
                Toggle(String(localized: "Show Model Name"), isOn: $showModelName)
            } header: {
                Text(String(localized: "Display Options"))
            }
        }
        .formStyle(.grouped)
        .navigationTitle(String(localized: "Display"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear(perform: loadSettings)
        .onDisappear(perform: saveSettings)
    }

    // MARK: - Persistence

    private func loadSettings() {
        settings.load()
        selectedThemeMode = settings.themeMode
        accentColorHex = settings.accentColorHex
        usePureBackground = settings.usePureBackground
        fontFamily = settings.appFontFamily ?? ""
        fontSize = settings.fontSize
        codeFontFamily = settings.codeFontFamily ?? ""
        showTokenCount = settings.showTokenCount
        showModelName = settings.showModelName
    }

    private func saveSettings() {
        settings.themeMode = selectedThemeMode
        settings.accentColorHex = accentColorHex
        settings.usePureBackground = usePureBackground
        settings.appFontFamily = fontFamily.isEmpty ? nil : fontFamily
        settings.fontSize = fontSize
        settings.codeFontFamily = codeFontFamily.isEmpty ? nil : codeFontFamily
        settings.showTokenCount = showTokenCount
        settings.showModelName = showModelName
        settings.save()
    }
}

#Preview {
    NavigationStack {
        DisplaySettingsView()
    }
}
