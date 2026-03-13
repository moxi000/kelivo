import Foundation

// MARK: - ProxyManager

/// Manages proxy settings for the application.
/// Persists configuration to UserDefaults and applies it to the shared HTTPClient.
final class ProxyManager: Sendable {
    static let shared = ProxyManager()

    private static let proxyEnabledKey = "proxy_enabled"
    private static let proxyConfigKey = "proxy_config"

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // MARK: - Persistence

    var isProxyEnabled: Bool {
        get { defaults.bool(forKey: Self.proxyEnabledKey) }
        set { defaults.set(newValue, forKey: Self.proxyEnabledKey) }
    }

    var savedConfig: ProxyConfig? {
        get {
            guard let data = defaults.data(forKey: Self.proxyConfigKey) else { return nil }
            return try? JSONDecoder().decode(ProxyConfig.self, from: data)
        }
        set {
            if let config = newValue,
                let data = try? JSONEncoder().encode(config)
            {
                defaults.set(data, forKey: Self.proxyConfigKey)
            } else {
                defaults.removeObject(forKey: Self.proxyConfigKey)
            }
        }
    }

    // MARK: - Active Configuration

    /// Returns the currently active proxy config, or nil if proxy is disabled.
    var activeConfig: ProxyConfig? {
        isProxyEnabled ? savedConfig : nil
    }

    // MARK: - Apply

    /// Saves the proxy configuration and applies it to the shared HTTPClient.
    func applyProxy(_ config: ProxyConfig?, enabled: Bool) async {
        savedConfig = config
        isProxyEnabled = enabled
        let effectiveConfig = enabled ? config : nil
        await HTTPClient.shared.configureProxy(effectiveConfig)
    }

    /// Disables proxy and clears the HTTPClient proxy configuration.
    func disableProxy() async {
        isProxyEnabled = false
        await HTTPClient.shared.configureProxy(nil)
    }

    /// Restores the saved proxy configuration on app launch.
    func restoreFromDefaults() async {
        let config = activeConfig
        await HTTPClient.shared.configureProxy(config)
    }
}
