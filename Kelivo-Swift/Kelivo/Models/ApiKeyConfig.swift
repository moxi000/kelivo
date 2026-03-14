import Foundation

// MARK: - Enums

enum ApiKeyStatus: String, Codable, CaseIterable {
    case active
    case disabled
    case error
    case rateLimited
}

enum LoadBalanceStrategy: String, Codable, CaseIterable {
    case roundRobin
    case priority
    case leastUsed
    case random
}

// MARK: - ApiKeyUsage

struct ApiKeyUsage: Codable, Equatable {
    var totalRequests: Int
    var successfulRequests: Int
    var failedRequests: Int
    var consecutiveFailures: Int
    var lastUsed: Int?

    init(
        totalRequests: Int = 0,
        successfulRequests: Int = 0,
        failedRequests: Int = 0,
        consecutiveFailures: Int = 0,
        lastUsed: Int? = nil
    ) {
        self.totalRequests = totalRequests
        self.successfulRequests = successfulRequests
        self.failedRequests = failedRequests
        self.consecutiveFailures = consecutiveFailures
        self.lastUsed = lastUsed
    }
}

// MARK: - ApiKeyConfig

struct ApiKeyConfig: Codable, Identifiable, Equatable {
    let id: String
    var key: String
    var name: String?
    var isEnabled: Bool
    var priority: Int  // 1-10, smaller means higher priority
    var maxRequestsPerMinute: Int?
    var usage: ApiKeyUsage
    var status: ApiKeyStatus
    var lastError: String?
    let createdAt: Int
    var updatedAt: Int

    init(
        id: String = Self.generateKeyId(),
        key: String,
        name: String? = nil,
        isEnabled: Bool = true,
        priority: Int = 5,
        maxRequestsPerMinute: Int? = nil,
        usage: ApiKeyUsage = ApiKeyUsage(),
        status: ApiKeyStatus = .active,
        lastError: String? = nil,
        createdAt: Int = Int(Date().timeIntervalSince1970 * 1000),
        updatedAt: Int = Int(Date().timeIntervalSince1970 * 1000)
    ) {
        self.id = id
        self.key = key
        self.name = name
        self.isEnabled = isEnabled
        self.priority = priority
        self.maxRequestsPerMinute = maxRequestsPerMinute
        self.usage = usage
        self.status = status
        self.lastError = lastError
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    /// Convenience factory matching the Flutter `ApiKeyConfig.create` method.
    static func create(key: String, name: String? = nil, priority: Int = 5) -> ApiKeyConfig {
        let now = Int(Date().timeIntervalSince1970 * 1000)
        return ApiKeyConfig(
            id: generateKeyId(),
            key: key,
            name: name,
            priority: priority,
            createdAt: now,
            updatedAt: now
        )
    }

    // MARK: - Key ID generation

    private static var counter: Int = 0

    /// Generates a unique key ID using timestamp, random value, and monotonic counter
    /// to ensure high probability of uniqueness even under fast batch inserts.
    static func generateKeyId() -> String {
        let ts = String(Int(Date().timeIntervalSince1970 * 1000), radix: 36)
        let r = String(Int.random(in: 0..<0x7FFFFFFF), radix: 36)
        counter = (counter + 1) & 0x7FFFFFFF
        let c = String(counter, radix: 36)
        return "key_\(ts)_\(r)_\(c)"
    }
}

// MARK: - KeyManagementConfig

struct KeyManagementConfig: Codable, Equatable {
    var strategy: LoadBalanceStrategy
    var maxFailuresBeforeDisable: Int
    var failureRecoveryTimeMinutes: Int
    var enableAutoRecovery: Bool
    var roundRobinIndex: Int?

    init(
        strategy: LoadBalanceStrategy = .roundRobin,
        maxFailuresBeforeDisable: Int = 3,
        failureRecoveryTimeMinutes: Int = 5,
        enableAutoRecovery: Bool = true,
        roundRobinIndex: Int? = nil
    ) {
        self.strategy = strategy
        self.maxFailuresBeforeDisable = maxFailuresBeforeDisable
        self.failureRecoveryTimeMinutes = failureRecoveryTimeMinutes
        self.enableAutoRecovery = enableAutoRecovery
        self.roundRobinIndex = roundRobinIndex
    }
}
