import SwiftUI

struct ThemeSettingsView: View {
    @State private var selectedColorHex: String = ""
    @State private var showColorPicker = false

    private let presetColors: [(String, Color)] = [
        ("#007AFF", .blue),
        ("#34C759", .green),
        ("#FF9500", .orange),
        ("#FF2D55", .pink),
        ("#AF52DE", .purple),
        ("#FF3B30", .red),
        ("#5AC8FA", .cyan),
        ("#FFCC00", .yellow),
        ("#8E8E93", .gray),
        ("#5856D6", .indigo),
        ("#00C7BE", .teal),
        ("#A2845E", .brown),
    ]

    private let columns = [
        GridItem(.adaptive(minimum: 48, maximum: 64), spacing: 12),
    ]

    var body: some View {
        Form {
            // MARK: - Color Palette
            Section {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(presetColors, id: \.0) { hex, color in
                        Button {
                            selectedColorHex = hex
                        } label: {
                            Circle()
                                .fill(color)
                                .frame(width: 44, height: 44)
                                .overlay {
                                    if selectedColorHex == hex {
                                        Image(systemName: "checkmark")
                                            .font(.headline.bold())
                                            .foregroundStyle(.white)
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 8)
            } header: {
                Text(String(localized: "Color Palette"))
            }

            // MARK: - Custom Color
            Section {
                HStack {
                    TextField(String(localized: "Custom Hex Color"), text: $selectedColorHex)
                        #if os(iOS)
                        .textInputAutocapitalization(.never)
                        #endif
                        .autocorrectionDisabled()
                        .monospacedDigit()

                    ColorPicker(
                        String(localized: "Pick Color"),
                        selection: Binding(
                            get: { colorFromHex(selectedColorHex) },
                            set: { selectedColorHex = hexFromColor($0) }
                        )
                    )
                    .labelsHidden()
                }
            } header: {
                Text(String(localized: "Custom Color"))
            }

            // MARK: - Preview
            Section {
                VStack(spacing: 16) {
                    GlassCard(cornerRadius: 12) {
                        HStack {
                            Image(systemName: "paintbrush.pointed")
                                .font(.title2)
                                .foregroundStyle(colorFromHex(selectedColorHex))
                            VStack(alignment: .leading) {
                                Text(String(localized: "Theme Preview"))
                                    .font(.headline)
                                Text(String(localized: "This is how your accent color looks."))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                    }

                    HStack(spacing: 12) {
                        if #available(iOS 26.0, macOS 26.0, *) {
                            Button(String(localized: "Primary")) {}
                                .buttonStyle(.glassProminent)
                                .tint(colorFromHex(selectedColorHex))

                            Button(String(localized: "Secondary")) {}
                                .buttonStyle(.glass)
                        } else {
                            Button(String(localized: "Primary")) {}
                                .buttonStyle(.borderedProminent)
                                .tint(colorFromHex(selectedColorHex))

                            Button(String(localized: "Secondary")) {}
                                .buttonStyle(.bordered)
                        }
                    }
                }
                .padding(.vertical, 8)
            } header: {
                Text(String(localized: "Preview"))
            }
        }
        .formStyle(.grouped)
        .navigationTitle(String(localized: "Theme"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Color Helpers

    private func colorFromHex(_ hex: String) -> Color {
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        guard cleaned.count == 6,
              let value = UInt64(cleaned, radix: 16) else {
            return .accentColor
        }
        let r = Double((value >> 16) & 0xFF) / 255.0
        let g = Double((value >> 8) & 0xFF) / 255.0
        let b = Double(value & 0xFF) / 255.0
        return Color(red: r, green: g, blue: b)
    }

    private func hexFromColor(_ color: Color) -> String {
        #if os(iOS)
        let uiColor = UIColor(color)
        var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: nil)
        #elseif os(macOS)
        let nsColor = NSColor(color).usingColorSpace(.deviceRGB) ?? NSColor(color)
        var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0
        nsColor.getRed(&r, green: &g, blue: &b, alpha: nil)
        #endif
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}

#Preview {
    NavigationStack {
        ThemeSettingsView()
    }
}
