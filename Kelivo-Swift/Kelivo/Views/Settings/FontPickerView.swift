import SwiftUI

struct FontPickerView: View {
    @State private var searchText: String = ""
    @State private var selectedFont: String = ""
    @State private var fontSize: Double = 16
    @State private var previewText: String = "The quick brown fox jumps over the lazy dog. 0123456789"

    private var availableFonts: [String] {
        #if os(iOS)
        UIFont.familyNames.sorted()
        #elseif os(macOS)
        NSFontManager.shared.availableFontFamilies.sorted()
        #endif
    }

    private var filteredFonts: [String] {
        if searchText.isEmpty {
            return availableFonts
        }
        return availableFonts.filter {
            $0.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        Form {
            // MARK: - Preview

            Section {
                Text(previewText)
                    .font(
                        selectedFont.isEmpty
                            ? .system(size: fontSize)
                            : .custom(selectedFont, size: fontSize)
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)

                TextField(String(localized: "Preview Text"), text: $previewText)
                    .font(.subheadline)
            } header: {
                Text(String(localized: "Preview"))
            }

            // MARK: - Font Size

            Section {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(String(localized: "Font Size"))
                        Spacer()
                        Text("\(Int(fontSize)) pt")
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                    Slider(value: $fontSize, in: 10...36, step: 1)
                }
            } header: {
                Text(String(localized: "Size"))
            }

            // MARK: - Font List

            Section {
                // System Default row
                Button {
                    selectedFont = ""
                } label: {
                    HStack {
                        Text(String(localized: "System Default"))
                            .foregroundStyle(.primary)
                        Spacer()
                        if selectedFont.isEmpty {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.tint)
                                .fontWeight(.semibold)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                // Available fonts
                ForEach(filteredFonts, id: \.self) { fontName in
                    Button {
                        selectedFont = fontName
                    } label: {
                        HStack {
                            Text(fontName)
                                .font(.custom(fontName, size: 17))
                                .foregroundStyle(.primary)
                            Spacer()
                            if selectedFont == fontName {
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
                Text(String(localized: "Fonts"))
            }
        }
        .formStyle(.grouped)
        .searchable(
            text: $searchText,
            prompt: Text(String(localized: "Search Fonts"))
        )
        .navigationTitle(String(localized: "Font"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear(perform: loadSettings)
        .onDisappear(perform: saveSettings)
    }

    // MARK: - Persistence

    private func loadSettings() {
        let defaults = UserDefaults.standard
        selectedFont = defaults.string(forKey: "settings.appFontFamily") ?? ""
        let stored = defaults.double(forKey: "settings.fontSize")
        fontSize = stored > 0 ? stored : 16
    }

    private func saveSettings() {
        let defaults = UserDefaults.standard
        defaults.set(selectedFont.isEmpty ? nil : selectedFont, forKey: "settings.appFontFamily")
        defaults.set(fontSize, forKey: "settings.fontSize")
    }
}

#Preview {
    NavigationStack {
        FontPickerView()
    }
}
