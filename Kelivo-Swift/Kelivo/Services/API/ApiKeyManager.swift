import Foundation

// MARK: - Provider Key Pool

/// A provider's key pool snapshot for key selection.
struct ProviderKeyPool: Sendable {
    let providerId: String
    let keys: [ApiKeyConfig]
    let management: KeyManagementConfig
}

/// Result of a key selection attempt.
struct KeySelectionResult: Sendable {
    let key: ApiKeyConfig?
    let reason: String
}

// MARK: - API Key Manager

/// Singleton actor that selects API keys using configurable load-balance
/// strategies and tracks per-key usage / failure state.
///
/// Uses the `ApiKeyConfig`, `KeyManagementConfig`, `LoadBalanceStrategy`,
/// and `ApiKeyStatus` types defined in `Models/ApiKeyConfig.swift`.
actor ApiKeyManager {
    static let shared = ApiKeyManager()

    /// Round-robin index per provider.
    private var roundRobinIndexMap: [String: Int] = [:]

    /// Ephemeral usage counter per key (not persisted).
    private var ephemeralUsageMap: [String: Int] = [:]

    private init() {}

    // MARK: - Key Selection

    /// Select the best available key for a provider based on its load-balance
    /// strategy and current key health.
    func selectKey(for pool: ProviderKeyPool) -> KeySelectionResult {
        let enabledKeys = pool.keys.filter(\.isEnabled)
        guard !enabledKeys.isEmpty else {
            return KeySelectionResult(key: nil, reason: "no_keys")
        }

        // Filter by status and cooldown
        let nowMs = Int(Date().timeIntervalSince1970 * 1000)
        let cooldownMs = pool.management.failureRecoveryTimeMinutes * 60 * 1000

        let available = enabledKeys.filter { key in
            switch key.status {
            case .disabled:
                return false
            case .error:
                // Allow error keys back in after cooldown expires
                guard pool.management.enableAutoRecovery else { return false }
                let elapsed = nowMs - key.updatedAt
                return elapsed >= cooldownMs
            case .active, .rateLimited:
                return true
            }
        }

        guard !available.isEmpty else {
            return KeySelectionResult(key: nil, reason: "no_available_keys")
        }

        let chosen: ApiKeyConfig

        switch pool.management.strategy {
        case .priority:
            chosen = available.sorted { $0.priority < $1.priority }.first!

        case .leastUsed:
            chosen = available.sorted { $0.usage.totalRequests < $1.usage.totalRequests }.first!

        case .random:
            chosen = available.randomElement()!

        case .roundRobin:
            let sorted = available.sorted { $0.id < $1.id }
            let currentIndex = roundRobinIndexMap[pool.providerId]
                ?? (pool.management.roundRobinIndex ?? 0)
            let idx = currentIndex % sorted.count
            chosen = sorted[idx]
            let next = (idx + 1) % sorted.count
            roundRobinIndexMap[pool.providerId] = next
        }

        return KeySelectionResult(key: chosen, reason: "strategy_\(pool.management.strategy.rawValue)")
    }

    // MARK: - Usage Recording

    /// Record a successful API call for the given key.
    ///
    /// Returns an updated copy of the key config with refreshed usage stats.
    func recordSuccess(key: ApiKeyConfig) -> ApiKeyConfig {
        let nowMs = Int(Date().timeIntervalSince1970 * 1000)

        var updated = key
        updated.usage.totalRequests += 1
        updated.usage.successfulRequests += 1
        updated.usage.consecutiveFailures = 0
        updated.usage.lastUsed = nowMs
        updated.status = .active
        updated.lastError = nil
        updated.updatedAt = nowMs

        ephemeralUsageMap[key.id, default: 0] += 1
        return updated
    }

    /// Record a failed API call for the given key.
    ///
    /// When consecutive failures reach the provider's threshold, the key's
    /// status is set to `.error` so it is excluded from future selection
    /// until the cooldown elapses.
    ///
    /// Returns an updated copy of the key config.
    func recordFailure(
        key: ApiKeyConfig,
        management: KeyManagementConfig,
        error: String? = nil
    ) -> ApiKeyConfig {
        let nowMs = Int(Date().timeIntervalSince1970 * 1000)

        var updated = key
        updated.usage.totalRequests += 1
        updated.usage.failedRequests += 1
        updated.usage.consecutiveFailures += 1
        updated.usage.lastUsed = nowMs
        updated.lastError = error
        updated.updatedAt = nowMs

        if updated.usage.consecutiveFailures >= management.maxFailuresBeforeDisable {
            updated.status = .error
        }

        ephemeralUsageMap[key.id, default: 0] += 1
        return updated
    }

    // MARK: - State Management

    /// Reset the round-robin index for a provider.
    func resetRoundRobinIndex(for providerId: String) {
        roundRobinIndexMap.removeValue(forKey: providerId)
    }

    /// Clear all ephemeral usage counters.
    func resetEphemeralUsage() {
        ephemeralUsageMap.removeAll()
    }
}
