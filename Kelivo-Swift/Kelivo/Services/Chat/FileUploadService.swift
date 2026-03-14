import Foundation
import UniformTypeIdentifiers

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

// MARK: - File Upload Error

enum FileUploadError: Error, LocalizedError {
    case unsupportedFileType(String)
    case fileTooLarge(maxBytes: Int)
    case imageProcessingFailed(String)
    case fileReadFailed(path: String, underlying: Error)

    var errorDescription: String? {
        switch self {
        case let .unsupportedFileType(ext):
            return "Unsupported file type: .\(ext)"
        case let .fileTooLarge(maxBytes):
            let mb = maxBytes / (1024 * 1024)
            return "File exceeds maximum size of \(mb) MB"
        case let .imageProcessingFailed(detail):
            return "Image processing failed: \(detail)"
        case let .fileReadFailed(path, underlying):
            return "Failed to read file at \(path): \(underlying.localizedDescription)"
        }
    }
}

// MARK: - Uploaded File Info

/// Represents a processed file ready for API submission.
struct UploadedFile: Sendable {
    let fileName: String
    let mimeType: String
    let data: Data
    let isImage: Bool

    /// Data URL string suitable for embedding in API payloads.
    /// Format: `data:<mimeType>;base64,<encoded>`
    var dataURL: String {
        "data:\(mimeType);base64,\(data.base64EncodedString())"
    }
}

// MARK: - File Upload Service

/// Handles file selection, validation, image resizing, and conversion to
/// base64 data URLs for chat API payloads.
///
/// Image files are resized if they exceed the maximum dimension to reduce
/// payload size. Documents are passed through with text extraction deferred
/// to `DocumentExtractor`.
struct FileUploadService {

    /// Maximum image dimension (width or height) before resizing.
    static let maxImageDimension: CGFloat = 2048

    /// Maximum file size in bytes (20 MB).
    static let maxFileSize: Int = 20 * 1024 * 1024

    // MARK: - Supported Types

    /// Image UTTypes accepted for upload.
    static let supportedImageTypes: [UTType] = [.jpeg, .png, .gif, .webP, .heic, .heif, .bmp, .tiff]

    /// Document UTTypes accepted for upload.
    static let supportedDocumentTypes: [UTType] = [.pdf, .plainText, .utf8PlainText, .rtf]

    // MARK: - Process File

    /// Process a file URL into an `UploadedFile` ready for API submission.
    ///
    /// Images are resized if they exceed `maxImageDimension`. Documents are
    /// read as-is; text extraction should be handled separately via
    /// `DocumentExtractor` if needed.
    static func processFile(at url: URL) async throws -> UploadedFile {
        let accessing = url.startAccessingSecurityScopedResource()
        defer {
            if accessing { url.stopAccessingSecurityScopedResource() }
        }

        let resourceValues = try url.resourceValues(forKeys: [.fileSizeKey])
        if let fileSize = resourceValues.fileSize, fileSize > maxFileSize {
            throw FileUploadError.fileTooLarge(maxBytes: maxFileSize)
        }

        let ext = url.pathExtension.lowercased()
        let fileName = url.lastPathComponent

        if isImageExtension(ext) {
            return try await processImage(at: url, fileName: fileName)
        } else if isDocumentExtension(ext) {
            return try processDocument(at: url, fileName: fileName)
        } else {
            throw FileUploadError.unsupportedFileType(ext)
        }
    }

    // MARK: - Image Processing

    /// Process an image file: load, optionally resize, and encode as JPEG or PNG.
    static func processImage(at url: URL, fileName: String) async throws -> UploadedFile {
        return try await Task.detached {
            let data = try readFileData(at: url)

            guard let cgImage = createCGImage(from: data) else {
                throw FileUploadError.imageProcessingFailed("Cannot decode image")
            }

            let width = CGFloat(cgImage.width)
            let height = CGFloat(cgImage.height)

            let needsResize = width > maxImageDimension || height > maxImageDimension
            let finalImage: CGImage

            if needsResize {
                finalImage = try resizeImage(cgImage, maxDimension: maxImageDimension)
            } else {
                finalImage = cgImage
            }

            // Encode as JPEG for photos, PNG for images with alpha
            let hasAlpha = cgImage.alphaInfo != .none
                && cgImage.alphaInfo != .noneSkipFirst
                && cgImage.alphaInfo != .noneSkipLast

            let (encodedData, mimeType) = try encodeImage(finalImage, preserveAlpha: hasAlpha)

            return UploadedFile(
                fileName: fileName,
                mimeType: mimeType,
                data: encodedData,
                isImage: true
            )
        }.value
    }

    /// Process raw image data (e.g., from camera capture).
    static func processImageData(_ data: Data, fileName: String = "image.jpg") async throws -> UploadedFile {
        return try await Task.detached {
            guard let cgImage = createCGImage(from: data) else {
                throw FileUploadError.imageProcessingFailed("Cannot decode image data")
            }

            let width = CGFloat(cgImage.width)
            let height = CGFloat(cgImage.height)

            let needsResize = width > maxImageDimension || height > maxImageDimension
            let finalImage = needsResize ? try resizeImage(cgImage, maxDimension: maxImageDimension) : cgImage

            let (encodedData, mimeType) = try encodeImage(finalImage, preserveAlpha: false)

            return UploadedFile(
                fileName: fileName,
                mimeType: mimeType,
                data: encodedData,
                isImage: true
            )
        }.value
    }

    // MARK: - Document Processing

    /// Read a document file and package it for upload.
    private static func processDocument(at url: URL, fileName: String) throws -> UploadedFile {
        let data = try readFileData(at: url)
        let mimeType = mimeTypeForExtension(url.pathExtension.lowercased())

        return UploadedFile(
            fileName: fileName,
            mimeType: mimeType,
            data: data,
            isImage: false
        )
    }

    // MARK: - Image Helpers

    /// Create a CGImage from raw data using ImageIO.
    private static func createCGImage(from data: Data) -> CGImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        return CGImageSourceCreateImageAtIndex(source, 0, nil)
    }

    /// Resize a CGImage proportionally so the longest side equals `maxDimension`.
    private static func resizeImage(_ image: CGImage, maxDimension: CGFloat) throws -> CGImage {
        let width = CGFloat(image.width)
        let height = CGFloat(image.height)
        let scale = maxDimension / max(width, height)

        let newWidth = Int(width * scale)
        let newHeight = Int(height * scale)

        guard let colorSpace = image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB) else {
            throw FileUploadError.imageProcessingFailed("Cannot determine color space")
        }

        guard let context = CGContext(
            data: nil,
            width: newWidth,
            height: newHeight,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            throw FileUploadError.imageProcessingFailed("Cannot create bitmap context")
        }

        context.interpolationQuality = .high
        context.draw(image, in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))

        guard let resized = context.makeImage() else {
            throw FileUploadError.imageProcessingFailed("Cannot render resized image")
        }

        return resized
    }

    /// Encode a CGImage as JPEG or PNG data.
    private static func encodeImage(_ image: CGImage, preserveAlpha: Bool) throws -> (Data, String) {
        let uti = preserveAlpha ? UTType.png : UTType.jpeg
        let mimeType = preserveAlpha ? "image/png" : "image/jpeg"

        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(data as CFMutableData, uti.identifier as CFString, 1, nil) else {
            throw FileUploadError.imageProcessingFailed("Cannot create image destination")
        }

        let options: [CFString: Any] = preserveAlpha ? [:] : [kCGImageDestinationLossyCompressionQuality: 0.85]
        CGImageDestinationAddImage(destination, image, options as CFDictionary)

        guard CGImageDestinationFinalize(destination) else {
            throw FileUploadError.imageProcessingFailed("Cannot finalize image encoding")
        }

        return (data as Data, mimeType)
    }

    // MARK: - File Helpers

    private static func readFileData(at url: URL) throws -> Data {
        do {
            return try Data(contentsOf: url)
        } catch {
            throw FileUploadError.fileReadFailed(path: url.path, underlying: error)
        }
    }

    private static func isImageExtension(_ ext: String) -> Bool {
        let imageExtensions: Set<String> = ["jpg", "jpeg", "png", "gif", "webp", "heic", "heif", "bmp", "tiff", "tif"]
        return imageExtensions.contains(ext)
    }

    private static func isDocumentExtension(_ ext: String) -> Bool {
        let docExtensions: Set<String> = [
            "pdf", "txt", "md", "rtf", "csv", "json", "xml", "html",
            "swift", "py", "js", "ts", "dart", "c", "cpp", "h", "java",
            "kt", "rs", "go", "rb", "lua", "sql", "yaml", "yml", "toml",
            "sh", "log", "conf", "cfg", "docx",
        ]
        return docExtensions.contains(ext)
    }

    private static func mimeTypeForExtension(_ ext: String) -> String {
        if let utType = UTType(filenameExtension: ext) {
            return utType.preferredMIMEType ?? "application/octet-stream"
        }
        return "application/octet-stream"
    }
}
