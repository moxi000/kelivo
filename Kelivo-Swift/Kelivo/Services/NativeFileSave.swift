import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Utility for saving files to the user's file system.
enum NativeFileSave {
    /// Save data to a file, presenting a save dialog on macOS or sharing on iOS.
    static func save(data: Data, filename: String, mimeType: String = "application/octet-stream") async throws -> URL? {
        #if os(macOS)
        return await saveOnMac(data: data, filename: filename)
        #else
        return try saveToDocuments(data: data, filename: filename)
        #endif
    }

    /// Save text content to a file.
    static func saveText(_ text: String, filename: String) async throws -> URL? {
        guard let data = text.data(using: .utf8) else {
            throw NativeFileSaveError.encodingFailed
        }
        return try await save(data: data, filename: filename, mimeType: "text/plain")
    }

    /// Save JSON data to a file.
    static func saveJSON(_ json: Any, filename: String) async throws -> URL? {
        let data = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys])
        return try await save(data: data, filename: filename, mimeType: "application/json")
    }

    #if os(macOS)
    @MainActor
    private static func saveOnMac(data: Data, filename: String) -> URL? {
        let panel = NSSavePanel()
        panel.nameFieldStringValue = filename
        panel.canCreateDirectories = true

        guard panel.runModal() == .OK, let url = panel.url else {
            return nil
        }

        do {
            try data.write(to: url)
            return url
        } catch {
            return nil
        }
    }
    #endif

    #if os(iOS)
    private static func saveToDocuments(data: Data, filename: String) throws -> URL {
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDir.appendingPathComponent(filename)
        try data.write(to: fileURL)
        return fileURL
    }
    #endif

    enum NativeFileSaveError: LocalizedError {
        case encodingFailed
        case saveFailed(String)

        var errorDescription: String? {
            switch self {
            case .encodingFailed:
                return "Failed to encode content"
            case .saveFailed(let reason):
                return "Failed to save file: \(reason)"
            }
        }
    }
}
