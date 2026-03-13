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
