import Foundation
import CommonCrypto

// MARK: - S3 Configuration

struct S3Config: Sendable, Codable {
    let endpoint: String
    let region: String
    let bucket: String
    let accessKeyId: String
    let secretAccessKey: String
    let pathPrefix: String
    let forcePathStyle: Bool

    init(
        endpoint: String = "https://s3.amazonaws.com",
        region: String = "us-east-1",
        bucket: String,
        accessKeyId: String,
        secretAccessKey: String,
        pathPrefix: String = "kelivo/",
        forcePathStyle: Bool = false
    ) {
        self.endpoint = endpoint.hasSuffix("/") ? String(endpoint.dropLast()) : endpoint
        self.region = region
        self.bucket = bucket
        self.accessKeyId = accessKeyId
        self.secretAccessKey = secretAccessKey
        self.pathPrefix = pathPrefix
        self.forcePathStyle = forcePathStyle
    }
}

// MARK: - S3 Error

enum S3Error: Error, LocalizedError {
    case invalidConfiguration(String)
    case authenticationFailed
    case notFound(String)
    case serverError(Int, String?)
    case requestFailed(Error)

    var errorDescription: String? {
        switch self {
        case let .invalidConfiguration(detail):
            return "S3 configuration error: \(detail)"
        case .authenticationFailed:
            return "S3 authentication failed"
        case let .notFound(key):
            return "S3 object not found: \(key)"
        case let .serverError(code, body):
            let detail = body.map { ": \($0)" } ?? ""
            return "S3 error \(code)\(detail)"
        case let .requestFailed(error):
            return "S3 request failed: \(error.localizedDescription)"
        }
    }
}

// MARK: - S3 Object

struct S3Object: Sendable {
    let key: String
    let size: Int
    let lastModified: Date?
    let etag: String?
}

// MARK: - S3 Client

actor S3Client {
    private let config: S3Config
    private let session: URLSession

    init(config: S3Config) {
        self.config = config
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 120
        self.session = URLSession(configuration: sessionConfig)
    }

    // MARK: - PutObject

    func putObject(key: String, data: Data, contentType: String = "application/octet-stream") async throws {
        let fullKey = config.pathPrefix + key
        let url = try buildURL(key: fullKey)

        let headers = try signRequest(
            method: "PUT",
            url: url,
            headers: ["Content-Type": contentType],
            payloadHash: sha256Hex(data)
        )

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        for (k, v) in headers { request.setValue(v, forHTTPHeaderField: k) }
        request.httpBody = data

        let (_, response) = try await session.data(for: request)
        let httpResponse = response as! HTTPURLResponse

        try checkResponse(httpResponse)
    }

    // MARK: - GetObject

    func getObject(key: String) async throws -> Data {
        let fullKey = config.pathPrefix + key
        let url = try buildURL(key: fullKey)

        let headers = try signRequest(
            method: "GET",
            url: url,
            headers: [:],
            payloadHash: sha256Hex(Data())
        )

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        for (k, v) in headers { request.setValue(v, forHTTPHeaderField: k) }

        let (data, response) = try await session.data(for: request)
        let httpResponse = response as! HTTPURLResponse

        try checkResponse(httpResponse)
        return data
    }

    // MARK: - DeleteObject

    func deleteObject(key: String) async throws {
        let fullKey = config.pathPrefix + key
        let url = try buildURL(key: fullKey)

        let headers = try signRequest(
            method: "DELETE",
            url: url,
            headers: [:],
            payloadHash: sha256Hex(Data())
        )

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        for (k, v) in headers { request.setValue(v, forHTTPHeaderField: k) }

        let (_, response) = try await session.data(for: request)
        let httpResponse = response as! HTTPURLResponse

        try checkResponse(httpResponse)
    }

    // MARK: - ListObjects

    func listObjects(prefix: String? = nil, maxKeys: Int = 1000) async throws -> [S3Object] {
        let listPrefix = config.pathPrefix + (prefix ?? "")
        var components = URLComponents(string: config.endpoint)!

        if config.forcePathStyle {
            components.path = "/\(config.bucket)"
        }

        components.queryItems = [
            URLQueryItem(name: "list-type", value: "2"),
            URLQueryItem(name: "prefix", value: listPrefix),
            URLQueryItem(name: "max-keys", value: String(maxKeys)),
        ]

        guard let url = components.url else {
            throw S3Error.invalidConfiguration("Failed to construct list URL")
        }

        let headers = try signRequest(
            method: "GET",
            url: url,
            headers: [:],
            payloadHash: sha256Hex(Data())
        )

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        for (k, v) in headers { request.setValue(v, forHTTPHeaderField: k) }

        let (data, response) = try await session.data(for: request)
        let httpResponse = response as! HTTPURLResponse

        try checkResponse(httpResponse)
        return parseListResponse(data)
    }

    // MARK: - URL Building

    private func buildURL(key: String) throws -> URL {
        if config.forcePathStyle {
            // Path-style: endpoint/bucket/key
            guard let url = URL(string: "\(config.endpoint)/\(config.bucket)/\(key)") else {
                throw S3Error.invalidConfiguration("Failed to construct URL for key: \(key)")
            }
            return url
        } else {
            // Virtual-hosted style: bucket.endpoint/key
            let host = config.endpoint
                .replacingOccurrences(of: "https://", with: "https://\(config.bucket).")
                .replacingOccurrences(of: "http://", with: "http://\(config.bucket).")
            guard let url = URL(string: "\(host)/\(key)") else {
                throw S3Error.invalidConfiguration("Failed to construct URL for key: \(key)")
            }
            return url
        }
    }

    // MARK: - AWS Signature V4

    private func signRequest(
        method: String,
        url: URL,
        headers: [String: String],
        payloadHash: String
    ) throws -> [String: String] {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        let amzDate = dateFormatter.string(from: now)

        dateFormatter.dateFormat = "yyyyMMdd"
        let dateStamp = dateFormatter.string(from: now)

        let host = url.host ?? ""
        let path = url.path.isEmpty ? "/" : url.path
        let query = url.query ?? ""

        var signedHeaders = headers
        signedHeaders["Host"] = host
        signedHeaders["x-amz-date"] = amzDate
        signedHeaders["x-amz-content-sha256"] = payloadHash

        // Canonical request
        let sortedHeaderKeys = signedHeaders.keys.map { $0.lowercased() }.sorted()
        let canonicalHeaders = sortedHeaderKeys
            .map { "\($0):\(signedHeaders.first { $0.key.lowercased() == $0.key.lowercased() }?.value ?? signedHeaders[$0] ?? "")" }
            .joined(separator: "\n") + "\n"

        // Fix: rebuild canonical headers properly
        let headerPairs = signedHeaders.map { (key: $0.key.lowercased(), value: $0.value) }.sorted { $0.key < $1.key }
        let canonicalHeadersFixed = headerPairs.map { "\($0.key):\($0.value)" }.joined(separator: "\n") + "\n"
        let signedHeaderList = headerPairs.map(\.key).joined(separator: ";")

        let canonicalQueryString = query
            .split(separator: "&")
            .map { String($0) }
            .sorted()
            .joined(separator: "&")

        let canonicalRequest = [
            method,
            path,
            canonicalQueryString,
            canonicalHeadersFixed,
            signedHeaderList,
            payloadHash,
        ].joined(separator: "\n")

        // String to sign
        let scope = "\(dateStamp)/\(config.region)/s3/aws4_request"
        let stringToSign = [
            "AWS4-HMAC-SHA256",
            amzDate,
            scope,
            sha256Hex(canonicalRequest.data(using: .utf8)!),
        ].joined(separator: "\n")

        // Signing key
        let kDate = hmacSHA256(key: "AWS4\(config.secretAccessKey)".data(using: .utf8)!, data: dateStamp.data(using: .utf8)!)
        let kRegion = hmacSHA256(key: kDate, data: config.region.data(using: .utf8)!)
        let kService = hmacSHA256(key: kRegion, data: "s3".data(using: .utf8)!)
        let kSigning = hmacSHA256(key: kService, data: "aws4_request".data(using: .utf8)!)

        let signature = hmacSHA256(key: kSigning, data: stringToSign.data(using: .utf8)!)
            .map { String(format: "%02x", $0) }
            .joined()

        let authorization = "AWS4-HMAC-SHA256 Credential=\(config.accessKeyId)/\(scope), SignedHeaders=\(signedHeaderList), Signature=\(signature)"

        var result = signedHeaders
        result["Authorization"] = authorization
        // Remove Host header as URLSession sets it
        result.removeValue(forKey: "Host")

        return result
    }

    // MARK: - Crypto Helpers

    private func sha256Hex(_ data: Data) -> String {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }

    private func hmacSHA256(key: Data, data: Data) -> Data {
        var result = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        key.withUnsafeBytes { keyPtr in
            data.withUnsafeBytes { dataPtr in
                CCHmac(
                    CCHmacAlgorithm(kCCHmacAlgSHA256),
                    keyPtr.baseAddress, key.count,
                    dataPtr.baseAddress, data.count,
                    &result
                )
            }
        }
        return Data(result)
    }

    // MARK: - Response Handling

    private func checkResponse(_ response: HTTPURLResponse) throws {
        guard (200...299).contains(response.statusCode) else {
            switch response.statusCode {
            case 403:
                throw S3Error.authenticationFailed
            case 404:
                throw S3Error.notFound(response.url?.path ?? "")
            default:
                throw S3Error.serverError(response.statusCode, nil)
            }
        }
    }

    private func parseListResponse(_ data: Data) -> [S3Object] {
        guard let xml = String(data: data, encoding: .utf8) else { return [] }

        var objects: [S3Object] = []
        let contentsPattern = #"<Contents>(.*?)</Contents>"#
        guard let regex = try? NSRegularExpression(pattern: contentsPattern, options: .dotMatchesLineSeparators) else {
            return []
        }

        let matches = regex.matches(in: xml, range: NSRange(xml.startIndex..., in: xml))

        for match in matches {
            guard let range = Range(match.range(at: 1), in: xml) else { continue }
            let block = String(xml[range])

            let key = extractXMLTag("Key", from: block) ?? ""
            let size = extractXMLTag("Size", from: block).flatMap { Int($0) } ?? 0
            let etag = extractXMLTag("ETag", from: block)

            let lastModified: Date?
            if let dateStr = extractXMLTag("LastModified", from: block) {
                let formatter = ISO8601DateFormatter()
                lastModified = formatter.date(from: dateStr)
            } else {
                lastModified = nil
            }

            objects.append(S3Object(
                key: key,
                size: size,
                lastModified: lastModified,
                etag: etag
            ))
        }

        return objects
    }

    private func extractXMLTag(_ tag: String, from xml: String) -> String? {
        let pattern = "<\(tag)>(.*?)</\(tag)>"
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: xml, range: NSRange(xml.startIndex..., in: xml)),
              let range = Range(match.range(at: 1), in: xml)
        else { return nil }
        return String(xml[range])
    }
}
