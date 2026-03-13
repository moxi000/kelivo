import Foundation
import Observation

// MARK: - Supporting Types

enum ThemeMode: String, CaseIterable, Codable, Sendable {
    case light
    case dark
    case system
}

enum ProxyType: String, CaseIterable, Codable, Sendable {
    case http
    case socks5
}

// MARK: - SettingsViewModel

@Observable
final class SettingsViewModel {

    // MARK: - Keys

    private enum Keys {
        static let themeMode = "settings.themeMode"
        static let accentColorHex = "settings.accentColorHex"
        static let usePureBackground = "settings.usePureBackground"
        static let appLocale = "settings.appLocale"
        static let appFontFamily = "settings.appFontFamily"
        static let codeFontFamily = "settings.codeFontFamily"
        static let fontSize = "settings.fontSize"
        static let showTokenCount = "settings.showTokenCount"
        static let showModelName = "settings.showModelName"
        static let userName = "settings.userName"
        static let userAvatarEmoji = "settings.userAvatarEmoji"
        static let proxyEnabled = "settings.proxyEnabled"
        static let proxyType = "settings.proxyType"
        static let proxyHost = "settings.proxyHost"
        static let proxyPort = "settings.proxyPort"
        static let desktopShowTray = "settings.desktopShowTray"
        static let desktopMinimizeToTrayOnClose = "settings.desktopMinimizeToTrayOnClose"
        static let showAppUpdates = "settings.showAppUpdates"
    }

    // MARK: - Theme

    var themeMode: ThemeMode = .system
    var accentColorHex: String = ""
    var usePureBackground: Bool = false

    // MARK: - Display

    var appLocale: String? = nil
    var appFontFamily: String? = nil
    var codeFontFamily: String? = nil
    var fontSize: Double = 16
    var showTokenCount: Bool = true
    var showModelName: Bool = true

    // MARK: - User

    var userName: String = ""
    var userAvatarEmoji: String = "😊"

    // MARK: - Network

    var proxyEnabled: Bool = false
    var proxyType: ProxyType = .http
    var proxyHost: String = ""
    var proxyPort: Int = 0

    // MARK: - Desktop (macOS)

    var desktopShowTray: Bool = true
    var desktopMinimizeToTrayOnClose: Bool = false

    // MARK: - App Updates

    var showAppUpdates: Bool = true

    // MARK: - Persistence

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }

    func load() {
        let d = defaults

        if let raw = d.string(forKey: Keys.themeMode),
           let mode = ThemeMode(rawValue: raw)
        {
            themeMode = mode
        }

        accentColorHex = d.string(forKey: Keys.accentColorHex) ?? ""
        usePureBackground = d.bool(forKey: Keys.usePureBackground)

        appLocale = d.string(forKey: Keys.appLocale)
        appFontFamily = d.string(forKey: Keys.appFontFamily)
        codeFontFamily = d.string(forKey: Keys.codeFontFamily)

        let storedFontSize = d.double(forKey: Keys.fontSize)
        fontSize = storedFontSize > 0 ? storedFontSize : 16

        showTokenCount = d.object(forKey: Keys.showTokenCount) != nil
            ? d.bool(forKey: Keys.showTokenCount)
            : true
        showModelName = d.object(forKey: Keys.showModelName) != nil
            ? d.bool(forKey: Keys.showModelName)
            : true

        userName = d.string(forKey: Keys.userName) ?? ""
        userAvatarEmoji = d.string(forKey: Keys.userAvatarEmoji) ?? "😊"

        proxyEnabled = d.bool(forKey: Keys.proxyEnabled)
        if let raw = d.string(forKey: Keys.proxyType),
           let type = ProxyType(rawValue: raw)
        {
            proxyType = type
        }
        proxyHost = d.string(forKey: Keys.proxyHost) ?? ""
        proxyPort = d.integer(forKey: Keys.proxyPort)

        desktopShowTray = d.object(forKey: Keys.desktopShowTray) != nil
            ? d.bool(forKey: Keys.desktopShowTray)
            : true
        desktopMinimizeToTrayOnClose = d.bool(forKey: Keys.desktopMinimizeToTrayOnClose)

        showAppUpdates = d.object(forKey: Keys.showAppUpdates) != nil
            ? d.bool(forKey: Keys.showAppUpdates)
            : true
    }

    func save() {
        let d = defaults

        d.set(themeMode.rawValue, forKey: Keys.themeMode)
        d.set(accentColorHex, forKey: Keys.accentColorHex)
        d.set(usePureBackground, forKey: Keys.usePureBackground)

        d.set(appLocale, forKey: Keys.appLocale)
        d.set(appFontFamily, forKey: Keys.appFontFamily)
        d.set(codeFontFamily, forKey: Keys.codeFontFamily)
        d.set(fontSize, forKey: Keys.fontSize)
        d.set(showTokenCount, forKey: Keys.showTokenCount)
        d.set(showModelName, forKey: Keys.showModelName)

        d.set(userName, forKey: Keys.userName)
        d.set(userAvatarEmoji, forKey: Keys.userAvatarEmoji)

        d.set(proxyEnabled, forKey: Keys.proxyEnabled)
        d.set(proxyType.rawValue, forKey: Keys.proxyType)
        d.set(proxyHost, forKey: Keys.proxyHost)
        d.set(proxyPort, forKey: Keys.proxyPort)

        d.set(desktopShowTray, forKey: Keys.desktopShowTray)
        d.set(desktopMinimizeToTrayOnClose, forKey: Keys.desktopMinimizeToTrayOnClose)

        d.set(showAppUpdates, forKey: Keys.showAppUpdates)
    }
}
