import Foundation
import Security

// MARK: - Google Service Account Auth Errors

enum GoogleAuthError: Error, LocalizedError {
    case invalidServiceAccountJSON(String)
    case jwtSigningFailed(String)
    case tokenExchangeFailed(String)
    case privateKeyParseFailed(String)
    case missingRequiredField(String)

    var errorDescription: String? {
        switch self {
        case let .invalidServiceAccountJSON(detail):
            return "Invalid service account JSON: \(detail)"
        case let .jwtSigningFailed(detail):
            return "JWT signing failed: \(detail)"
        case let .tokenExchangeFailed(detail):
            return "Token exchange failed: \(detail)"
        case let .privateKeyParseFailed(detail):
            return "Private key parse failed: \(detail)"
        case let .missingRequiredField(field):
            return "Missing required field in service account JSON: \(field)"
        }
    }
}

// MARK: - Cached Token

private struct CachedToken {
    let accessToken: String
    let expiresAt: Date

    /// Token is considered valid if it has more than 5 minutes of life remaining.
    var isValid: Bool {
        Date.now.addingTimeInterval(5 * 60) < expiresAt
    }
}

// MARK: - Google Service Account Auth

/// Provides OAuth2 access tokens for Google service accounts using JWT-based
/// authentication (RS256).
///
/// Tokens are cached in memory and reused until they are within 5 minutes
/// of expiration.
///
/// Usage:
/// ```swift
/// let token = try await GoogleServiceAccountAuth.getAccessToken(
///     from: serviceAccountJSON,
///     scopes: ["https://www.googleapis.com/auth/cloud-platform"]
/// )
/// ```
enum GoogleServiceAccountAuth {

    // MARK: - Token Cache

    /// Actor-isolated cache keyed by `clientEmail + scopes`.
    private actor TokenCache {
        static let shared = TokenCache()
        private var cache: [String: CachedToken] = [:]

        func get(key: String) -> CachedToken? {
            guard let token = cache[key], token.isValid else {
                cache.removeValue(forKey: key)
                return nil
            }
            return token
        }

        func set(key: String, token: CachedToken) {
            cache[key] = token
        }
    }

    // MARK: - Public API

    /// Obtain an OAuth2 access token for the given service account.
    ///
    /// - Parameters:
    ///   - jsonString: The raw JSON content of a Google service account key file.
    ///   - scopes: OAuth2 scopes to request.
    /// - Returns: A bearer access token string.
    static func getAccessToken(from jsonString: String, scopes: [String]) async throws -> String {
        guard let jsonData = jsonString.data(using: .utf8) else {
            throw GoogleAuthError.invalidServiceAccountJSON("Not valid UTF-8")
        }

        guard let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            throw GoogleAuthError.invalidServiceAccountJSON("Cannot parse JSON")
        }

        guard let clientEmail = json["client_email"] as? String else {
            throw GoogleAuthError.missingRequiredField("client_email")
        }
        guard let privateKeyPEM = json["private_key"] as? String else {
            throw GoogleAuthError.missingRequiredField("private_key")
        }
        guard let tokenUri = json["token_uri"] as? String else {
            throw GoogleAuthError.missingRequiredField("token_uri")
        }

        // Check cache
        let cacheKey = clientEmail + scopes.sorted().joined()
        if let cached = await TokenCache.shared.get(key: cacheKey) {
            return cached.accessToken
        }

        // Build and sign JWT
        let now = Date.now
        let expiry = now.addingTimeInterval(3600) // 1 hour

        let header: [String: Any] = [
            "alg": "RS256",
            "typ": "JWT",
        ]

        let claims: [String: Any] = [
            "iss": clientEmail,
            "scope": scopes.joined(separator: " "),
            "aud": tokenUri,
            "iat": Int(now.timeIntervalSince1970),
            "exp": Int(expiry.timeIntervalSince1970),
        ]

        let headerData = try JSONSerialization.data(withJSONObject: header)
        let claimsData = try JSONSerialization.data(withJSONObject: claims)

        let headerB64 = headerData.base64URLEncoded()
        let claimsB64 = claimsData.base64URLEncoded()

        let signingInput = "\(headerB64).\(claimsB64)"

        guard let signingInputData = signingInput.data(using: .utf8) else {
            throw GoogleAuthError.jwtSigningFailed("Cannot encode signing input")
        }

        let privateKey = try parseRSAPrivateKey(pem: privateKeyPEM)
        let signature = try sign(data: signingInputData, with: privateKey)
        let signatureB64 = signature.base64URLEncoded()

        let jwt = "\(signingInput).\(signatureB64)"

        // Exchange JWT for access token
        let accessToken = try await exchangeToken(jwt: jwt, tokenUri: tokenUri)

        // Cache the token
        let cached = CachedToken(accessToken: accessToken, expiresAt: expiry)
        await TokenCache.shared.set(key: cacheKey, token: cached)

        return accessToken
    }

    // MARK: - JWT Signing

    /// Parse a PEM-encoded RSA private key into a `SecKey`.
    private static func parseRSAPrivateKey(pem: String) throws -> SecKey {
        // Strip PEM headers and whitespace
        let stripped = pem
            .replacingOccurrences(of: "-----BEGIN PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "-----END PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "-----BEGIN RSA PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "-----END RSA PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .trimmingCharacters(in: .whitespaces)

        guard let keyData = Data(base64Encoded: stripped) else {
            throw GoogleAuthError.privateKeyParseFailed("Invalid base64 encoding")
        }

        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrKeySizeInBits as String: 2048,
        ]

        var error: Unmanaged<CFError>?
        guard let secKey = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, &error) else {
            let desc = error?.takeRetainedValue().localizedDescription ?? "unknown error"
            throw GoogleAuthError.privateKeyParseFailed(desc)
        }

        return secKey
    }

    /// Sign data with an RSA private key using SHA-256.
    private static func sign(data: Data, with key: SecKey) throws -> Data {
        guard SecKeyIsAlgorithmSupported(key, .sign, .rsaSignatureMessagePKCS1v15SHA256) else {
            throw GoogleAuthError.jwtSigningFailed("RS256 signing not supported for this key")
        }

        var error: Unmanaged<CFError>?
        guard let signature = SecKeyCreateSignature(
            key,
            .rsaSignatureMessagePKCS1v15SHA256,
            data as CFData,
            &error
        ) as Data? else {
            let desc = error?.takeRetainedValue().localizedDescription ?? "unknown error"
            throw GoogleAuthError.jwtSigningFailed(desc)
        }

        return signature
    }

    // MARK: - Token Exchange

    /// Exchange a signed JWT for an OAuth2 access token.
    private static func exchangeToken(jwt: String, tokenUri: String) async throws -> String {
        guard let url = URL(string: tokenUri) else {
            throw GoogleAuthError.tokenExchangeFailed("Invalid token URI: \(tokenUri)")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=\(jwt)"
        request.httpBody = body.data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw GoogleAuthError.tokenExchangeFailed("Invalid HTTP response")
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let bodyStr = String(data: data, encoding: .utf8) ?? ""
            throw GoogleAuthError.tokenExchangeFailed("HTTP \(httpResponse.statusCode): \(bodyStr)")
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let accessToken = json["access_token"] as? String
        else {
            throw GoogleAuthError.tokenExchangeFailed("Response missing access_token field")
        }

        return accessToken
    }
}

// MARK: - Base64URL Extension

private extension Data {
    /// Encode data as base64url (RFC 4648 Section 5), without padding.
    func base64URLEncoded() -> String {
        base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
