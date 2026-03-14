#if os(macOS)
import SwiftUI
import Carbon.HIToolbox

// MARK: - HotkeyDefinition

/// Represents a single configurable hotkey with its current key combination.
struct HotkeyDefinition: Identifiable, Equatable {
    let id: String
    let title: String
    let defaultModifiers: NSEvent.ModifierFlags
    let defaultKeyCode: UInt16
    var currentModifiers: NSEvent.ModifierFlags
    var currentKeyCode: UInt16
    var isEnabled: Bool

    var displayString: String {
        var parts: [String] = []
        if currentModifiers.contains(.control) { parts.append("\u{2303}") }
        if currentModifiers.contains(.option) { parts.append("\u{2325}") }
        if currentModifiers.contains(.shift) { parts.append("\u{21E7}") }
        if currentModifiers.contains(.command) { parts.append("\u{2318}") }
        parts.append(keyCodeToString(currentKeyCode))
        return parts.joined()
    }

    private func keyCodeToString(_ keyCode: UInt16) -> String {
        switch Int(keyCode) {
        case kVK_Return: return "\u{21A9}"
        case kVK_Tab: return "\u{21E5}"
        case kVK_Space: return "\u{2423}"
        case kVK_Delete: return "\u{232B}"
        case kVK_Escape: return "\u{238B}"
        case kVK_ANSI_N: return "N"
        case kVK_ANSI_S: return "S"
        case kVK_ANSI_F: return "F"
        case kVK_ANSI_K: return "K"
        case kVK_ANSI_L: return "L"
        case kVK_ANSI_W: return "W"
        case kVK_ANSI_Period: return "."
        case kVK_ANSI_Comma: return ","
        case kVK_ANSI_Slash: return "/"
        default: return "Key(\(keyCode))"
        }
    }
}

extension NSEvent.ModifierFlags: @retroactive Equatable {
    public static func == (lhs: NSEvent.ModifierFlags, rhs: NSEvent.ModifierFlags) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

// MARK: - MacHotkeysView

/// Hotkey configuration view for macOS Settings.
/// Lists available hotkeys with their current key combinations,
/// allows enabling/disabling individual hotkeys, recording new
/// key combinations, and resetting to defaults.
struct MacHotkeysView: View {
    @State private var hotkeys: [HotkeyDefinition] = Self.defaultHotkeys
    @State private var recordingHotkeyId: String?

    var body: some View {
        Form {
            Section {
                ForEach($hotkeys) { $hotkey in
                    hotkeyRow(hotkey: $hotkey)
                }
            } header: {
                Text(String(localized: "hotkeys"))
            } footer: {
                Text(String(localized: "hotkeysDescription"))
                    .foregroundStyle(.secondary)
            }

            Section {
                Button {
                    resetToDefaults()
                } label: {
                    Text(String(localized: "resetToDefaults"))
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle(String(localized: "hotkeys"))
    }

    // MARK: - Row

    private func hotkeyRow(hotkey: Binding<HotkeyDefinition>) -> some View {
        HStack {
            Toggle(isOn: hotkey.isEnabled) {
                Text(hotkey.wrappedValue.title)
            }
            .toggleStyle(.switch)

            Spacer()

            keyCombinationButton(for: hotkey)
        }
    }

    // MARK: - Key Combination Button

    private func keyCombinationButton(for hotkey: Binding<HotkeyDefinition>) -> some View {
        let isRecording = recordingHotkeyId == hotkey.wrappedValue.id

        return Button {
            if isRecording {
                recordingHotkeyId = nil
            } else {
                recordingHotkeyId = hotkey.wrappedValue.id
            }
        } label: {
            Text(isRecording
                 ? String(localized: "pressKeyCombination")
                 : hotkey.wrappedValue.displayString)
                .font(.system(.body, design: .monospaced))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isRecording ? Color.accentColor.opacity(0.15) : Color.secondary.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isRecording ? Color.accentColor : Color.clear, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .disabled(!hotkey.wrappedValue.isEnabled)
    }

    // MARK: - Reset

    private func resetToDefaults() {
        hotkeys = Self.defaultHotkeys
        recordingHotkeyId = nil
    }

    // MARK: - Default Hotkeys

    static let defaultHotkeys: [HotkeyDefinition] = [
        HotkeyDefinition(
            id: "newChat",
            title: String(localized: "newChat"),
            defaultModifiers: .command,
            defaultKeyCode: UInt16(kVK_ANSI_N),
            currentModifiers: .command,
            currentKeyCode: UInt16(kVK_ANSI_N),
            isEnabled: true
        ),
        HotkeyDefinition(
            id: "toggleSidebar",
            title: String(localized: "toggleSidebar"),
            defaultModifiers: [.command, .control],
            defaultKeyCode: UInt16(kVK_ANSI_S),
            currentModifiers: [.command, .control],
            currentKeyCode: UInt16(kVK_ANSI_S),
            isEnabled: true
        ),
        HotkeyDefinition(
            id: "focusInput",
            title: String(localized: "focusInput"),
            defaultModifiers: .command,
            defaultKeyCode: UInt16(kVK_ANSI_L),
            currentModifiers: .command,
            currentKeyCode: UInt16(kVK_ANSI_L),
            isEnabled: true
        ),
        HotkeyDefinition(
            id: "sendMessage",
            title: String(localized: "sendMessage"),
            defaultModifiers: .command,
            defaultKeyCode: UInt16(kVK_Return),
            currentModifiers: .command,
            currentKeyCode: UInt16(kVK_Return),
            isEnabled: true
        ),
        HotkeyDefinition(
            id: "stopGeneration",
            title: String(localized: "stopGeneration"),
            defaultModifiers: .command,
            defaultKeyCode: UInt16(kVK_ANSI_Period),
            currentModifiers: .command,
            currentKeyCode: UInt16(kVK_ANSI_Period),
            isEnabled: true
        ),
        HotkeyDefinition(
            id: "clearChat",
            title: String(localized: "clearChat"),
            defaultModifiers: [.command, .shift],
            defaultKeyCode: UInt16(kVK_ANSI_K),
            currentModifiers: [.command, .shift],
            currentKeyCode: UInt16(kVK_ANSI_K),
            isEnabled: true
        ),
        HotkeyDefinition(
            id: "searchConversations",
            title: String(localized: "searchConversations"),
            defaultModifiers: .command,
            defaultKeyCode: UInt16(kVK_ANSI_F),
            currentModifiers: .command,
            currentKeyCode: UInt16(kVK_ANSI_F),
            isEnabled: true
        ),
        HotkeyDefinition(
            id: "closeWindow",
            title: String(localized: "closeWindow"),
            defaultModifiers: .command,
            defaultKeyCode: UInt16(kVK_ANSI_W),
            currentModifiers: .command,
            currentKeyCode: UInt16(kVK_ANSI_W),
            isEnabled: true
        ),
    ]
}

// MARK: - Preview

#Preview {
    MacHotkeysView()
        .frame(width: 500, height: 600)
}
#endif
