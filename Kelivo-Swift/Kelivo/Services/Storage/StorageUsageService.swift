import Foundation
import SwiftData

// MARK: - Storage Usage Info

/// Summary of storage space used by the app.
struct StorageUsageInfo: Sendable {
    /// Size of the SwiftData database file in bytes.
    let databaseSize: Int64

    /// Size of cached files (images, documents) in bytes.
    let cacheSize: Int64

    /// Size of temporary files in bytes.
    let tempSize: Int64

    /// Total storage used in bytes.
    var totalSize: Int64 {
        databaseSize + cacheSize + tempSize
    }

    /// Human-readable total size string.
    var formattedTotal: String {
        ByteCountFormatter.string(fromByteCount: totalSize, countStyle: .file)
    }

    /// Human-readable database size string.
    var formattedDatabaseSize: String {
        ByteCountFormatter.string(fromByteCount: databaseSize, countStyle: .file)
    }

    /// Human-readable cache size string.
    var formattedCacheSize: String {
        ByteCountFormatter.string(fromByteCount: cacheSize, countStyle: .file)
    }

    /// Human-readable temp size string.
    var formattedTempSize: String {
        ByteCountFormatter.string(fromByteCount: tempSize, countStyle: .file)
    }
}

// MARK: - Storage Usage Error

enum StorageUsageError: Error, LocalizedError {
    case directoryNotFound(String)
    case cleanupFailed(path: String, underlying: Error)

    var errorDescription: String? {
        switch self {
        case let .directoryNotFound(path):
            return "Directory not found: \(path)"
        case let .cleanupFailed(path, underlying):
            return "Failed to clean up \(path): \(underlying.localizedDescription)"
        }
    }
}

// MARK: - Storage Usage Service

/// Calculates and manages storage space used by the app, including the
/// SwiftData database, cached files, and temporary files.
actor StorageUsageService {
    static let shared = StorageUsageService()

    private let fileManager = FileManager.default

    private init() {}

    // MARK: - Calculate Usage

    /// Calculate the total storage usage across database, cache, and temp files.
    func calculateUsage() async -> StorageUsageInfo {
        async let dbSize = calculateDatabaseSize()
        async let cache = calculateCacheSize()
        async let temp = calculateTempSize()

        let (db, c, t) = await (dbSize, cache, temp)

        return StorageUsageInfo(
            databaseSize: db,
            cacheSize: c,
            tempSize: t
        )
    }

    // MARK: - Database Size

    /// Calculate the size of the SwiftData / Core Data store files.
    private func calculateDatabaseSize() -> Int64 {
        guard let appSupportURL = fileManager.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first else {
            return 0
        }

        // SwiftData stores its database as a SQLite file in Application Support.
        // The default file name follows the pattern "default.store".
        let storeExtensions = ["store", "store-shm", "store-wal", "sqlite", "sqlite-shm", "sqlite-wal"]

        var totalSize: Int64 = 0
        totalSize += sizeOfFilesMatching(in: appSupportURL, extensions: storeExtensions)

        return totalSize
    }

    // MARK: - Cache Size

    /// Calculate the size of the app's caches directory.
    private func calculateCacheSize() -> Int64 {
        guard let cacheURL = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first else {
            return 0
        }

        return sizeOfDirectory(at: cacheURL)
    }

    // MARK: - Temp Size

    /// Calculate the size of the app's temporary directory.
    private func calculateTempSize() -> Int64 {
        let tempURL = fileManager.temporaryDirectory
        return sizeOfDirectory(at: tempURL)
    }

    // MARK: - Cleanup Methods

    /// Clear cached files. Returns the number of bytes freed.
    func clearCache() throws -> Int64 {
        guard let cacheURL = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first else {
            return 0
        }

        return try clearDirectory(at: cacheURL)
    }

    /// Clear temporary files. Returns the number of bytes freed.
    func clearTempFiles() throws -> Int64 {
        let tempURL = fileManager.temporaryDirectory
        return try clearDirectory(at: tempURL)
    }

    /// Clear both cache and temporary files. Returns the total bytes freed.
    func clearAllNonEssential() throws -> Int64 {
        let cacheFreed = (try? clearCache()) ?? 0
        let tempFreed = (try? clearTempFiles()) ?? 0
        return cacheFreed + tempFreed
    }

    // MARK: - File System Helpers

    /// Calculate the total size of all files in a directory, recursively.
    private func sizeOfDirectory(at url: URL) -> Int64 {
        guard let enumerator = fileManager.enumerator(
            at: url,
            includingPropertiesForKeys: [.fileSizeKey, .isRegularFileKey],
            options: [.skipsHiddenFiles],
            errorHandler: nil
        ) else {
            return 0
        }

        var totalSize: Int64 = 0

        for case let fileURL as URL in enumerator {
            guard let resourceValues = try? fileURL.resourceValues(forKeys: [.fileSizeKey, .isRegularFileKey]),
                  resourceValues.isRegularFile == true,
                  let fileSize = resourceValues.fileSize
            else {
                continue
            }
            totalSize += Int64(fileSize)
        }

        return totalSize
    }

    /// Calculate the total size of files matching specific extensions in a directory.
    private func sizeOfFilesMatching(in directory: URL, extensions: [String]) -> Int64 {
        guard let contents = try? fileManager.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: [.fileSizeKey],
            options: [.skipsHiddenFiles]
        ) else {
            return 0
        }

        var totalSize: Int64 = 0

        for fileURL in contents {
            let ext = fileURL.pathExtension.lowercased()
            let nameWithoutExt = fileURL.deletingPathExtension().lastPathComponent

            // Match files with the given extensions, or files that contain "default" (SwiftData default store)
            let matches = extensions.contains(ext)
                || extensions.contains(where: { fileURL.lastPathComponent.hasSuffix(".\($0)") })
                || nameWithoutExt == "default"

            guard matches else { continue }

            if let values = try? fileURL.resourceValues(forKeys: [.fileSizeKey]),
               let size = values.fileSize
            {
                totalSize += Int64(size)
            }
        }

        return totalSize
    }

    /// Remove all contents of a directory without removing the directory itself.
    ///
    /// Returns the number of bytes freed.
    private func clearDirectory(at url: URL) throws -> Int64 {
        guard fileManager.fileExists(atPath: url.path) else {
            return 0
        }

        let sizeBefore = sizeOfDirectory(at: url)

        guard let contents = try? fileManager.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: nil,
            options: []
        ) else {
            return 0
        }

        var lastError: Error?
        for item in contents {
            do {
                try fileManager.removeItem(at: item)
            } catch {
                lastError = error
            }
        }

        if let lastError {
            throw StorageUsageError.cleanupFailed(path: url.path, underlying: lastError)
        }

        let sizeAfter = sizeOfDirectory(at: url)
        return max(0, sizeBefore - sizeAfter)
    }
}
