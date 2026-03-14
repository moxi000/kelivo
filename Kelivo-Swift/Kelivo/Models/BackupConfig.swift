import Foundation
import SwiftData

enum BackupType: String, Codable, CaseIterable {
    case webdav
    case s3
}

@Model
final class BackupConfig {
    @Attribute(.unique) var id: String
    var backupTypeRaw: String

    // WebDAV fields
    var url: String
    var username: String
    var path: String

    // S3 fields
    var s3Bucket: String
    var s3Region: String
    var s3Endpoint: String
    var s3PathStyle: Bool

    // Common options
    var includeChats: Bool
    var includeFiles: Bool
    var autoBackup: Bool
    var autoBackupInterval: Int
    var lastBackupAt: Date?

    /// Typed access to backup type.
    var backupType: BackupType {
        get { BackupType(rawValue: backupTypeRaw) ?? .webdav }
        set { backupTypeRaw = newValue.rawValue }
    }

    init(
        id: String = UUID().uuidString,
        backupType: BackupType = .webdav,
        url: String = "",
        username: String = "",
        path: String = "kelivo_backups",
        s3Bucket: String = "",
        s3Region: String = "us-east-1",
        s3Endpoint: String = "",
        s3PathStyle: Bool = true,
        includeChats: Bool = true,
        includeFiles: Bool = true,
        autoBackup: Bool = false,
        autoBackupInterval: Int = 86400,
        lastBackupAt: Date? = nil
    ) {
        self.id = id
        self.backupTypeRaw = backupType.rawValue
        self.url = url
        self.username = username
        self.path = path
        self.s3Bucket = s3Bucket
        self.s3Region = s3Region
        self.s3Endpoint = s3Endpoint
        self.s3PathStyle = s3PathStyle
        self.includeChats = includeChats
        self.includeFiles = includeFiles
        self.autoBackup = autoBackup
        self.autoBackupInterval = autoBackupInterval
        self.lastBackupAt = lastBackupAt
    }
}

// MARK: - Cross-platform Compatibility

extension BackupConfig {
    /// Creates a `BackupConfig` from Flutter's `WebDavConfig` JSON format.
    ///
    /// Expected Flutter keys: `url`, `username`, `password`, `path`,
    /// `includeChats`, `includeFiles`, `autoBackup`, `autoBackupInterval`,
    /// `lastBackupAt`.
    static func fromWebDavJson(_ json: [String: Any]) -> BackupConfig {
        BackupConfig(
            id: json["id"] as? String ?? UUID().uuidString,
            backupType: .webdav,
            url: json["url"] as? String ?? "",
            username: json["username"] as? String ?? "",
            path: json["path"] as? String ?? "kelivo_backups",
            includeChats: json["includeChats"] as? Bool ?? true,
            includeFiles: json["includeFiles"] as? Bool ?? true,
            autoBackup: json["autoBackup"] as? Bool ?? false,
            autoBackupInterval: json["autoBackupInterval"] as? Int ?? 86400
        )
    }

    /// Creates a `BackupConfig` from Flutter's `S3Config` JSON format.
    ///
    /// Expected Flutter keys: `bucket`, `region`, `endpoint`, `pathStyle`,
    /// `includeChats`, `includeFiles`, `autoBackup`, `autoBackupInterval`,
    /// `lastBackupAt`.
    static func fromS3Json(_ json: [String: Any]) -> BackupConfig {
        BackupConfig(
            id: json["id"] as? String ?? UUID().uuidString,
            backupType: .s3,
            s3Bucket: json["bucket"] as? String ?? "",
            s3Region: json["region"] as? String ?? "us-east-1",
            s3Endpoint: json["endpoint"] as? String ?? "",
            s3PathStyle: json["pathStyle"] as? Bool ?? true,
            includeChats: json["includeChats"] as? Bool ?? true,
            includeFiles: json["includeFiles"] as? Bool ?? true,
            autoBackup: json["autoBackup"] as? Bool ?? false,
            autoBackupInterval: json["autoBackupInterval"] as? Int ?? 86400
        )
    }
}

/// Portable representation for cross-platform JSON import/export.
struct BackupConfigDTO: Codable {
    let id: String
    let backupType: String
    let url: String
    let username: String
    let path: String
    let s3Bucket: String
    let s3Region: String
    let s3Endpoint: String
    let s3PathStyle: Bool
    let includeChats: Bool
    let includeFiles: Bool
    let autoBackup: Bool
    let autoBackupInterval: Int
    let lastBackupAt: Date?

    init(from model: BackupConfig) {
        self.id = model.id
        self.backupType = model.backupTypeRaw
        self.url = model.url
        self.username = model.username
        self.path = model.path
        self.s3Bucket = model.s3Bucket
        self.s3Region = model.s3Region
        self.s3Endpoint = model.s3Endpoint
        self.s3PathStyle = model.s3PathStyle
        self.includeChats = model.includeChats
        self.includeFiles = model.includeFiles
        self.autoBackup = model.autoBackup
        self.autoBackupInterval = model.autoBackupInterval
        self.lastBackupAt = model.lastBackupAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        backupType = try container.decodeIfPresent(String.self, forKey: .backupType) ?? BackupType.webdav.rawValue
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        username = try container.decodeIfPresent(String.self, forKey: .username) ?? ""
        path = try container.decodeIfPresent(String.self, forKey: .path) ?? "kelivo_backups"
        s3Bucket = try container.decodeIfPresent(String.self, forKey: .s3Bucket) ?? ""
        s3Region = try container.decodeIfPresent(String.self, forKey: .s3Region) ?? "us-east-1"
        s3Endpoint = try container.decodeIfPresent(String.self, forKey: .s3Endpoint) ?? ""
        s3PathStyle = try container.decodeIfPresent(Bool.self, forKey: .s3PathStyle) ?? true
        includeChats = try container.decodeIfPresent(Bool.self, forKey: .includeChats) ?? true
        includeFiles = try container.decodeIfPresent(Bool.self, forKey: .includeFiles) ?? true
        autoBackup = try container.decodeIfPresent(Bool.self, forKey: .autoBackup) ?? false
        autoBackupInterval = try container.decodeIfPresent(Int.self, forKey: .autoBackupInterval) ?? 86400
        lastBackupAt = try container.decodeIfPresent(Date.self, forKey: .lastBackupAt)
    }

    func toModel() -> BackupConfig {
        BackupConfig(
            id: id,
            backupType: BackupType(rawValue: backupType) ?? .webdav,
            url: url,
            username: username,
            path: path,
            s3Bucket: s3Bucket,
            s3Region: s3Region,
            s3Endpoint: s3Endpoint,
            s3PathStyle: s3PathStyle,
            includeChats: includeChats,
            includeFiles: includeFiles,
            autoBackup: autoBackup,
            autoBackupInterval: autoBackupInterval,
            lastBackupAt: lastBackupAt
        )
    }
}
