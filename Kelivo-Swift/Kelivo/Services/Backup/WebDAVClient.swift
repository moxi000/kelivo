import Foundation

// MARK: - WebDAV Configuration

struct WebDAVConfig: Sendable, Codable {
    let url: String
    let username: String
    let password: String
    let basePath: String

    init(url: String, username: String, password: String, basePath: String = "/kelivo/") {
        self.url = url.hasSuffix("/") ? String(url.dropLast()) : url
        self.username = username
        self.password = password
        self.basePath = basePath.hasSuffix("/") ? basePath : basePath + "/"
    }
}

// MARK: - WebDAV Error

enum WebDAVError: Error, LocalizedError {
    case invalidConfiguration(String)
    case authenticationFailed
    case resourceNotFound(String)
    case conflict(String)
    case serverError(Int, String?)
    case requestFailed(Error)

    var errorDescription: String? {
        switch self {
        case let .invalidConfiguration(detail):
            return "WebDAV configuration error: \(detail)"
        case .authenticationFailed:
            return "WebDAV authentication failed"
        case let .resourceNotFound(path):
            return "WebDAV resource not found: \(path)"
        case let .conflict(detail):
            return "WebDAV conflict: \(detail)"
        case let .serverError(code, body):
            let detail = body.map { ": \($0)" } ?? ""
            return "WebDAV server error \(code)\(detail)"
        case let .requestFailed(error):
            return "WebDAV request failed: \(error.localizedDescription)"
        }
    }
}

// MARK: - WebDAV Item

struct WebDAVItem: Sendable {
    let path: String
    let isDirectory: Bool
    let contentLength: Int?
    let lastModified: Date?
    let etag: String?
}

// MARK: - WebDAV Client

actor WebDAVClient {
    private let config: WebDAVConfig
    private let session: URLSession

    init(config: WebDAVConfig) {
        self.config = config
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 60
        self.session = URLSession(configuration: sessionConfig)
    }

    // MARK: - Authentication

    private func authHeaders() -> [String: String] {
        let credentials = "\(config.username):\(config.password)"
        let encoded = Data(credentials.utf8).base64EncodedString()
        return ["Authorization": "Basic \(encoded)"]
    }

    private func buildURL(path: String) throws -> URL {
        let fullPath = config.basePath + path
        guard let url = URL(string: config.url + fullPath) else {
            throw WebDAVError.invalidConfiguration("Invalid URL: \(config.url)\(fullPath)")
        }
        return url
    }

    // MARK: - PROPFIND (List)

    func list(path: String = "", depth: Int = 1) async throws -> [WebDAVItem] {
        let url = try buildURL(path: path)

        var request = URLRequest(url: url)
        request.httpMethod = "PROPFIND"
        for (key, value) in authHeaders() {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.setValue(String(depth), forHTTPHeaderField: "Depth")
        request.setValue("application/xml", forHTTPHeaderField: "Content-Type")

        let propfindBody = """
            <?xml version="1.0" encoding="UTF-8"?>
            <d:propfind xmlns:d="DAV:">
                <d:prop>
                    <d:resourcetype/>
                    <d:getcontentlength/>
                    <d:getlastmodified/>
                    <d:getetag/>
                </d:prop>
            </d:propfind>
            """
        request.httpBody = propfindBody.data(using: .utf8)

        let (data, response) = try await session.data(for: request)
        let httpResponse = response as! HTTPURLResponse

        try checkResponse(httpResponse, statusCodes: [207, 200])

        return parseMultiStatus(data)
    }

    // MARK: - GET (Download)

    func download(path: String) async throws -> Data {
        let url = try buildURL(path: path)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        for (key, value) in authHeaders() {
            request.setValue(value, forHTTPHeaderField: key)
        }

        let (data, response) = try await session.data(for: request)
        let httpResponse = response as! HTTPURLResponse

        try checkResponse(httpResponse, statusCodes: [200])

        return data
    }

    // MARK: - PUT (Upload)

    func upload(path: String, data: Data, contentType: String = "application/octet-stream") async throws {
        let url = try buildURL(path: path)

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        for (key, value) in authHeaders() {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        let (_, response) = try await session.data(for: request)
        let httpResponse = response as! HTTPURLResponse

        try checkResponse(httpResponse, statusCodes: [200, 201, 204])
    }

    // MARK: - DELETE

    func delete(path: String) async throws {
        let url = try buildURL(path: path)

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        for (key, value) in authHeaders() {
            request.setValue(value, forHTTPHeaderField: key)
        }

        let (_, response) = try await session.data(for: request)
        let httpResponse = response as! HTTPURLResponse

        try checkResponse(httpResponse, statusCodes: [200, 204])
    }

    // MARK: - MKCOL (Create Directory)

    func createDirectory(path: String) async throws {
        let url = try buildURL(path: path)

        var request = URLRequest(url: url)
        request.httpMethod = "MKCOL"
        for (key, value) in authHeaders() {
            request.setValue(value, forHTTPHeaderField: key)
        }

        let (_, response) = try await session.data(for: request)
        let httpResponse = response as! HTTPURLResponse

        try checkResponse(httpResponse, statusCodes: [200, 201])
    }

    // MARK: - Helpers

    private func checkResponse(_ response: HTTPURLResponse, statusCodes: Set<Int>) throws {
        guard statusCodes.contains(response.statusCode) else {
            switch response.statusCode {
            case 401:
                throw WebDAVError.authenticationFailed
            case 404:
                throw WebDAVError.resourceNotFound(response.url?.path ?? "unknown")
            case 409:
                throw WebDAVError.conflict("Parent directory may not exist")
            default:
                throw WebDAVError.serverError(response.statusCode, nil)
            }
        }
    }

    /// Basic XML parsing for PROPFIND multistatus responses.
    private func parseMultiStatus(_ data: Data) -> [WebDAVItem] {
        // Simple regex-based extraction for common WebDAV properties.
        // A full XML parser (XMLParser) could be used for more robust parsing.
        guard let xml = String(data: data, encoding: .utf8) else { return [] }

        var items: [WebDAVItem] = []
        let responsePattern = #"<d:response>(.*?)</d:response>"#

        guard let regex = try? NSRegularExpression(pattern: responsePattern, options: .dotMatchesLineSeparators) else {
            return []
        }

        let matches = regex.matches(in: xml, range: NSRange(xml.startIndex..., in: xml))

        for match in matches {
            guard let range = Range(match.range(at: 1), in: xml) else { continue }
            let block = String(xml[range])

            // Extract href
            let href = extractTag("d:href", from: block) ?? ""

            // Check if collection
            let isDirectory = block.contains("<d:collection")

            // Content length
            let lengthStr = extractTag("d:getcontentlength", from: block)
            let contentLength = lengthStr.flatMap { Int($0) }

            // Last modified
            let modifiedStr = extractTag("d:getlastmodified", from: block)
            let lastModified = modifiedStr.flatMap { parseHTTPDate($0) }

            // ETag
            let etag = extractTag("d:getetag", from: block)

            items.append(WebDAVItem(
                path: href,
                isDirectory: isDirectory,
                contentLength: contentLength,
                lastModified: lastModified,
                etag: etag
            ))
        }

        return items
    }

    private func extractTag(_ tag: String, from xml: String) -> String? {
        let pattern = "<\(tag)>(.*?)</\(tag)>"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators),
              let match = regex.firstMatch(in: xml, range: NSRange(xml.startIndex..., in: xml)),
              let range = Range(match.range(at: 1), in: xml)
        else { return nil }
        return String(xml[range])
    }

    private func parseHTTPDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return formatter.date(from: string)
    }
}
