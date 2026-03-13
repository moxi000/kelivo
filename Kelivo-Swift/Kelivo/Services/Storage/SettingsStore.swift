import Foundation
import SwiftUI

// MARK: - Theme Mode

enum AppThemeMode: String, CaseIterable, Codable {
    case system
    case light
    case dark
}

// MARK: - Settings Store

/// Observable settings store backed by UserDefaults.
@Observable
final class SettingsStore {
    static let shared = SettingsStore()

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // MARK: - Appearance

    var themeMode: AppThemeMode {
        get { AppThemeMode(rawValue: defaults.string(forKey: Keys.themeMode) ?? "") ?? .system }
        set { defaults.set(newValue.rawValue, forKey: Keys.themeMode) }
    }

    var accentColorHex: String? {
        get { defaults.string(forKey: Keys.accentColorHex) }
        set { defaults.set(newValue, forKey: Keys.accentColorHex) }
    }

    var usePureBackground: Bool {
        get { defaults.bool(forKey: Keys.usePureBackground) }
        set { defaults.set(newValue, forKey: Keys.usePureBackground) }
    }

    var appFontFamily: String? {
        get { defaults.string(forKey: Keys.appFontFamily) }
        set { defaults.set(newValue, forKey: Keys.appFontFamily) }
    }

    var appFontSize: Double {
        get {
            let value = defaults.double(forKey: Keys.appFontSize)
            return value > 0 ? value : 16.0
        }
        set { defaults.set(newValue, forKey: Keys.appFontSize) }
    }

    // MARK: - Locale

    var appLocale: String? {
        get { defaults.string(forKey: Keys.appLocale) }
        set { defaults.set(newValue, forKey: Keys.appLocale) }
    }

    // MARK: - Default Provider & Model

    var defaultProviderId: String? {
        get { defaults.string(forKey: Keys.defaultProviderId) }
        set { defaults.set(newValue, forKey: Keys.defaultProviderId) }
    }

    var defaultModelId: String? {
        get { defaults.string(forKey: Keys.defaultModelId) }
        set { defaults.set(newValue, forKey: Keys.defaultModelId) }
    }

    // MARK: - Chat Settings

    var sendWithEnter: Bool {
        get { defaults.object(forKey: Keys.sendWithEnter) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Keys.sendWithEnter) }
    }

    var showModelName: Bool {
        get { defaults.object(forKey: Keys.showModelName) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Keys.showModelName) }
    }

    var enableMarkdown: Bool {
        get { defaults.object(forKey: Keys.enableMarkdown) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Keys.enableMarkdown) }
    }

    var enableCodeHighlighting: Bool {
        get { defaults.object(forKey: Keys.enableCodeHighlighting) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Keys.enableCodeHighlighting) }
    }

    var messageTextSize: Double {
        get {
            let value = defaults.double(forKey: Keys.messageTextSize)
            return value > 0 ? value : 15.0
        }
        set { defaults.set(newValue, forKey: Keys.messageTextSize) }
    }

    // MARK: - Proxy

    var proxyEnabled: Bool {
        get { defaults.bool(forKey: Keys.proxyEnabled) }
        set { defaults.set(newValue, forKey: Keys.proxyEnabled) }
    }

    var proxyType: String {
        get { defaults.string(forKey: Keys.proxyType) ?? "http" }
        set { defaults.set(newValue, forKey: Keys.proxyType) }
    }

    var proxyHost: String {
        get { defaults.string(forKey: Keys.proxyHost) ?? "" }
        set { defaults.set(newValue, forKey: Keys.proxyHost) }
    }

    var proxyPort: Int {
        get { defaults.integer(forKey: Keys.proxyPort) }
        set { defaults.set(newValue, forKey: Keys.proxyPort) }
    }

    // MARK: - Desktop Settings

    var desktopShowTray: Bool {
        get { defaults.object(forKey: Keys.desktopShowTray) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Keys.desktopShowTray) }
    }

    var desktopMinimizeToTrayOnClose: Bool {
        get { defaults.object(forKey: Keys.desktopMinimizeToTrayOnClose) as? Bool ?? false }
        set { defaults.set(newValue, forKey: Keys.desktopMinimizeToTrayOnClose) }
    }

    var desktopLaunchAtLogin: Bool {
        get { defaults.bool(forKey: Keys.desktopLaunchAtLogin) }
        set { defaults.set(newValue, forKey: Keys.desktopLaunchAtLogin) }
    }

    var desktopGlobalHotkey: String? {
        get { defaults.string(forKey: Keys.desktopGlobalHotkey) }
        set { defaults.set(newValue, forKey: Keys.desktopGlobalHotkey) }
    }

    // MARK: - Backup: WebDAV

    var webDavURL: String {
        get { defaults.string(forKey: Keys.webDavURL) ?? "" }
        set { defaults.set(newValue, forKey: Keys.webDavURL) }
    }

    var webDavUsername: String {
        get { defaults.string(forKey: Keys.webDavUsername) ?? "" }
        set { defaults.set(newValue, forKey: Keys.webDavUsername) }
    }

    var webDavBasePath: String {
        get { defaults.string(forKey: Keys.webDavBasePath) ?? "/kelivo/" }
        set { defaults.set(newValue, forKey: Keys.webDavBasePath) }
    }

    // MARK: - Backup: S3

    var s3Endpoint: String {
        get { defaults.string(forKey: Keys.s3Endpoint) ?? "" }
        set { defaults.set(newValue, forKey: Keys.s3Endpoint) }
    }

    var s3Region: String {
        get { defaults.string(forKey: Keys.s3Region) ?? "us-east-1" }
        set { defaults.set(newValue, forKey: Keys.s3Region) }
    }

    var s3Bucket: String {
        get { defaults.string(forKey: Keys.s3Bucket) ?? "" }
        set { defaults.set(newValue, forKey: Keys.s3Bucket) }
    }

    var s3PathPrefix: String {
        get { defaults.string(forKey: Keys.s3PathPrefix) ?? "kelivo/" }
        set { defaults.set(newValue, forKey: Keys.s3PathPrefix) }
    }

    var s3ForcePathStyle: Bool {
        get { defaults.bool(forKey: Keys.s3ForcePathStyle) }
        set { defaults.set(newValue, forKey: Keys.s3ForcePathStyle) }
    }

    // MARK: - TTS

    var ttsVoiceIdentifier: String? {
        get { defaults.string(forKey: Keys.ttsVoiceIdentifier) }
        set { defaults.set(newValue, forKey: Keys.ttsVoiceIdentifier) }
    }

    var ttsRate: Float {
        get {
            let value = defaults.float(forKey: Keys.ttsRate)
            return value > 0 ? value : 0.5
        }
        set { defaults.set(newValue, forKey: Keys.ttsRate) }
    }

    var ttsPitch: Float {
        get {
            let value = defaults.float(forKey: Keys.ttsPitch)
            return value > 0 ? value : 1.0
        }
        set { defaults.set(newValue, forKey: Keys.ttsPitch) }
    }

    // MARK: - Search

    var searchProviderId: String {
        get { defaults.string(forKey: Keys.searchProviderId) ?? "duckduckgo" }
        set { defaults.set(newValue, forKey: Keys.searchProviderId) }
    }

    var searchMaxResults: Int {
        get {
            let value = defaults.integer(forKey: Keys.searchMaxResults)
            return value > 0 ? value : 5
        }
        set { defaults.set(newValue, forKey: Keys.searchMaxResults) }
    }

    // MARK: - Notification

    var notifyOnChatComplete: Bool {
        get { defaults.bool(forKey: Keys.notifyOnChatComplete) }
        set { defaults.set(newValue, forKey: Keys.notifyOnChatComplete) }
    }

    // MARK: - Logging

    var fileLoggingEnabled: Bool {
        get { defaults.bool(forKey: Keys.fileLoggingEnabled) }
        set { defaults.set(newValue, forKey: Keys.fileLoggingEnabled) }
    }

    // MARK: - First Launch

    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: Keys.hasCompletedOnboarding) }
        set { defaults.set(newValue, forKey: Keys.hasCompletedOnboarding) }
    }
}

// MARK: - Keys

private extension SettingsStore {
    enum Keys {
        // Appearance
        static let themeMode = "settings.themeMode"
        static let accentColorHex = "settings.accentColorHex"
        static let usePureBackground = "settings.usePureBackground"
        static let appFontFamily = "settings.appFontFamily"
        static let appFontSize = "settings.appFontSize"

        // Locale
        static let appLocale = "settings.appLocale"

        // Provider
        static let defaultProviderId = "settings.defaultProviderId"
        static let defaultModelId = "settings.defaultModelId"

        // Chat
        static let sendWithEnter = "settings.sendWithEnter"
        static let showModelName = "settings.showModelName"
        static let enableMarkdown = "settings.enableMarkdown"
        static let enableCodeHighlighting = "settings.enableCodeHighlighting"
        static let messageTextSize = "settings.messageTextSize"

        // Proxy
        static let proxyEnabled = "settings.proxyEnabled"
        static let proxyType = "settings.proxyType"
        static let proxyHost = "settings.proxyHost"
        static let proxyPort = "settings.proxyPort"

        // Desktop
        static let desktopShowTray = "settings.desktopShowTray"
        static let desktopMinimizeToTrayOnClose = "settings.desktopMinimizeToTrayOnClose"
        static let desktopLaunchAtLogin = "settings.desktopLaunchAtLogin"
        static let desktopGlobalHotkey = "settings.desktopGlobalHotkey"

        // WebDAV
        static let webDavURL = "settings.webDavURL"
        static let webDavUsername = "settings.webDavUsername"
        static let webDavBasePath = "settings.webDavBasePath"

        // S3
        static let s3Endpoint = "settings.s3Endpoint"
        static let s3Region = "settings.s3Region"
        static let s3Bucket = "settings.s3Bucket"
        static let s3PathPrefix = "settings.s3PathPrefix"
        static let s3ForcePathStyle = "settings.s3ForcePathStyle"

        // TTS
        static let ttsVoiceIdentifier = "settings.ttsVoiceIdentifier"
        static let ttsRate = "settings.ttsRate"
        static let ttsPitch = "settings.ttsPitch"

        // Search
        static let searchProviderId = "settings.searchProviderId"
        static let searchMaxResults = "settings.searchMaxResults"

        // Notification
        static let notifyOnChatComplete = "settings.notifyOnChatComplete"

        // Logging
        static let fileLoggingEnabled = "settings.fileLoggingEnabled"

        // Onboarding
        static let hasCompletedOnboarding = "settings.hasCompletedOnboarding"
    }
}
