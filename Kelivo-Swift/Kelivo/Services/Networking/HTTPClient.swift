import Foundation

// MARK: - Proxy Configuration

enum ProxyType: String, Codable, Sendable {
    case socks5
    case http
}

struct ProxyConfig: Sendable, Codable {
    let type: ProxyType
    let host: String
    let port: Int
    let username: String?
    let password: String?
}

// MARK: - HTTP Errors

enum HTTPClientError: Error, LocalizedError {
    case invalidResponse
    case httpError(statusCode: Int, body: String?)
    case streamError(String)
    case requestFailed(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid HTTP response"
        case let .httpError(statusCode, body):
            let detail = body.map { ": \($0)" } ?? ""
            return "HTTP \(statusCode)\(detail)"
        case let .streamError(message):
            return "Stream error: \(message)"
        case let .requestFailed(underlying):
            return "Request failed: \(underlying.localizedDescription)"
        }
    }
}

// MARK: - HTTPClient

actor HTTPClient {
    static let shared = HTTPClient()

    private var session: URLSession
    private var proxyConfig: ProxyConfig?

    init(proxyConfig: ProxyConfig? = nil) {
        self.proxyConfig = proxyConfig
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 300
        if let proxy = proxyConfig {
            Self.applyProxy(proxy, to: configuration)
        }
        self.session = URLSession(configuration: configuration)
    }

    // MARK: - Proxy

    func configureProxy(_ config: ProxyConfig?) {
        self.proxyConfig = config
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 300
        if let proxy = config {
            Self.applyProxy(proxy, to: configuration)
        }
        self.session = URLSession(configuration: configuration)
    }

    private static func applyProxy(_ proxy: ProxyConfig, to config: URLSessionConfiguration) {
        var dict: [AnyHashable: Any] = [:]

        switch proxy.type {
        case .http:
            dict[kCFNetworkProxiesHTTPEnable] = true
            dict[kCFNetworkProxiesHTTPProxy] = proxy.host
            dict[kCFNetworkProxiesHTTPPort] = proxy.port
            dict["HTTPSEnable"] = true
            dict["HTTPSProxy"] = proxy.host
            dict["HTTPSPort"] = proxy.port
        case .socks5:
            dict[kCFStreamPropertySOCKSProxyHost] = proxy.host
            dict[kCFStreamPropertySOCKSProxyPort] = proxy.port
            if let username = proxy.username {
                dict[kCFStreamPropertySOCKSUser] = username
            }
            if let password = proxy.password {
                dict[kCFStreamPropertySOCKSPassword] = password
            }
        }

        config.connectionProxyDictionary = dict
    }

    // MARK: - Standard Request

    func request(
        _ url: URL,
        method: String = "GET",
        headers: [String: String] = [:],
        body: Data? = nil
    ) async throws -> (Data, HTTPURLResponse) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        urlRequest.httpBody = body

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw HTTPClientError.requestFailed(underlying: error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPClientError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let bodyString = String(data: data, encoding: .utf8)
            throw HTTPClientError.httpError(statusCode: httpResponse.statusCode, body: bodyString)
        }

        return (data, httpResponse)
    }

    // MARK: - Streaming Request (SSE)

    func stream(
        _ url: URL,
        method: String = "POST",
        headers: [String: String] = [:],
        body: Data? = nil
    ) -> AsyncThrowingStream<Data, Error> {
        // Capture session reference before leaving actor isolation
        let currentSession = self.session

        return AsyncThrowingStream { continuation in
            let task = Task {
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method
                for (key, value) in headers {
                    urlRequest.setValue(value, forHTTPHeaderField: key)
                }
                urlRequest.httpBody = body

                do {
                    let (bytes, response) = try await currentSession.bytes(for: urlRequest)

                    guard let httpResponse = response as? HTTPURLResponse else {
                        continuation.finish(throwing: HTTPClientError.invalidResponse)
                        return
                    }

                    guard (200...299).contains(httpResponse.statusCode) else {
                        // Collect error body
                        var errorBody = Data()
                        for try await byte in bytes {
                            errorBody.append(byte)
                            if errorBody.count > 4096 { break }
                        }
                        let bodyString = String(data: errorBody, encoding: .utf8)
                        continuation.finish(
                            throwing: HTTPClientError.httpError(
                                statusCode: httpResponse.statusCode, body: bodyString))
                        return
                    }

                    var buffer = Data()
                    for try await byte in bytes {
                        if Task.isCancelled {
                            continuation.finish()
                            return
                        }
                        buffer.append(byte)
                        // Yield on newline boundaries for SSE line-based parsing
                        if byte == UInt8(ascii: "\n") {
                            continuation.yield(buffer)
                            buffer = Data()
                        }
                    }
                    // Yield any remaining data
                    if !buffer.isEmpty {
                        continuation.yield(buffer)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
