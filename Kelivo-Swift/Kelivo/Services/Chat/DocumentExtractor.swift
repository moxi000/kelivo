import Foundation
import PDFKit

// MARK: - Document Extractor

/// Extracts text content from various document formats.
///
/// Supports PDF (via PDFKit), plain text files, and DOCX.
/// All extraction runs on a background thread to avoid blocking the main actor.
struct DocumentExtractor {

    // MARK: - Public API

    /// Extract text from a file URL based on its extension.
    ///
    /// Dispatches to the appropriate extractor based on file type.
    /// Throws `DocumentError` for unsupported formats or read failures.
    static func extractText(from url: URL) async throws -> String {
        let ext = url.pathExtension.lowercased()

        switch ext {
        case "pdf":
            return try await extractPDF(from: url)

        case "txt", "md", "swift", "py", "js", "ts", "json", "xml",
             "html", "css", "csv", "yaml", "yml", "toml", "ini",
             "sh", "bash", "zsh", "c", "h", "cpp", "hpp", "m", "mm",
             "java", "kt", "rs", "go", "rb", "lua", "r", "sql",
             "dart", "log", "env", "conf", "cfg", "properties":
            return try await extractPlainText(from: url)

        case "docx":
            return try await extractDocx(from: url)

        case "doc":
            throw DocumentError.unsupportedFormat(
                ext,
                detail: "Legacy .doc format is not supported. Please convert to .docx."
            )

        default:
            // Attempt plain text as a fallback for unknown extensions
            do {
                return try await extractPlainText(from: url)
            } catch {
                throw DocumentError.unsupportedFormat(ext)
            }
        }
    }

    // MARK: - PDF Extraction

    private static func extractPDF(from url: URL) async throws -> String {
        // PDFKit operations can be slow for large files; run off the main actor.
        return try await Task.detached {
            guard let document = PDFDocument(url: url) else {
                throw DocumentError.cannotOpen(path: url.path)
            }

            guard document.pageCount > 0 else {
                throw DocumentError.emptyDocument
            }

            var textParts: [String] = []
            textParts.reserveCapacity(document.pageCount)

            for i in 0..<document.pageCount {
                if Task.isCancelled {
                    throw CancellationError()
                }
                if let page = document.page(at: i), let pageText = page.string {
                    let trimmed = pageText.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmed.isEmpty {
                        textParts.append(trimmed)
                    }
                }
            }

            let result = textParts.joined(separator: "\n\n")
            if result.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                throw DocumentError.noTextContent(format: "PDF")
            }
            return result
        }.value
    }

    // MARK: - Plain Text Extraction

    private static func extractPlainText(from url: URL) async throws -> String {
        return try await Task.detached {
            let data = try Data(contentsOf: url)

            // Try UTF-8 first, then fall back to lossy decoding
            if let text = String(data: data, encoding: .utf8) {
                return text
            }

            // Try other common encodings
            for encoding: String.Encoding in [.utf16, .isoLatin1, .ascii, .windowsCP1252] {
                if let text = String(data: data, encoding: encoding) {
                    return text
                }
            }

            // Last resort: lossy UTF-8
            return String(decoding: data, as: UTF8.self)
        }.value
    }

    // MARK: - DOCX Extraction

    private static func extractDocx(from url: URL) async throws -> String {
        return try await Task.detached {
            // DOCX files are ZIP archives containing XML.
            // We extract word/document.xml and parse text from <w:t> elements.
            let fileData = try Data(contentsOf: url)

            guard let archive = try? extractZipEntry(
                from: fileData,
                entryPath: "word/document.xml"
            ) else {
                throw DocumentError.malformedDocument(
                    format: "DOCX",
                    detail: "Could not find word/document.xml in archive"
                )
            }

            guard let xmlString = String(data: archive, encoding: .utf8) else {
                throw DocumentError.malformedDocument(
                    format: "DOCX",
                    detail: "word/document.xml is not valid UTF-8"
                )
            }

            // Parse XML to extract text content from <w:t> elements
            let text = extractTextFromWordXML(xmlString)
            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                throw DocumentError.noTextContent(format: "DOCX")
            }
            return text
        }.value
    }

    /// Minimal ZIP extraction for a single entry.
    ///
    /// This is a lightweight implementation that handles the common case of
    /// extracting a single file from a ZIP archive without a third-party dependency.
    /// For production use with complex archives, consider using ZIPFoundation.
    private static func extractZipEntry(from data: Data, entryPath: String) throws -> Data? {
        // ZIP local file header signature: PK\x03\x04
        let signature: [UInt8] = [0x50, 0x4B, 0x03, 0x04]
        let bytes = [UInt8](data)

        var offset = 0
        while offset + 30 < bytes.count {
            // Check for local file header signature
            guard bytes[offset] == signature[0],
                  bytes[offset + 1] == signature[1],
                  bytes[offset + 2] == signature[2],
                  bytes[offset + 3] == signature[3]
            else {
                break
            }

            // Parse local file header
            let compressionMethod = UInt16(bytes[offset + 8]) | (UInt16(bytes[offset + 9]) << 8)
            let compressedSize = Int(
                UInt32(bytes[offset + 18])
                | (UInt32(bytes[offset + 19]) << 8)
                | (UInt32(bytes[offset + 20]) << 16)
                | (UInt32(bytes[offset + 21]) << 24)
            )
            let uncompressedSize = Int(
                UInt32(bytes[offset + 22])
                | (UInt32(bytes[offset + 23]) << 8)
                | (UInt32(bytes[offset + 24]) << 16)
                | (UInt32(bytes[offset + 25]) << 24)
            )
            let fileNameLength = Int(UInt16(bytes[offset + 26]) | (UInt16(bytes[offset + 27]) << 8))
            let extraFieldLength = Int(UInt16(bytes[offset + 28]) | (UInt16(bytes[offset + 29]) << 8))

            let fileNameStart = offset + 30
            let fileNameEnd = fileNameStart + fileNameLength
            guard fileNameEnd <= bytes.count else { break }

            let fileName = String(bytes: bytes[fileNameStart..<fileNameEnd], encoding: .utf8) ?? ""
            let dataStart = fileNameEnd + extraFieldLength

            if fileName == entryPath {
                let dataEnd = dataStart + compressedSize
                guard dataEnd <= bytes.count else {
                    throw DocumentError.malformedDocument(
                        format: "ZIP",
                        detail: "Entry data extends beyond archive bounds"
                    )
                }

                let entryData = Data(bytes[dataStart..<dataEnd])

                if compressionMethod == 0 {
                    // Stored (no compression)
                    return entryData
                } else if compressionMethod == 8 {
                    // Deflate — use Foundation's built-in decompression
                    let decompressed = try (entryData as NSData).decompressed(using: .zlib) as Data
                    _ = uncompressedSize  // validation reference
                    return decompressed
                } else {
                    throw DocumentError.malformedDocument(
                        format: "ZIP",
                        detail: "Unsupported compression method: \(compressionMethod)"
                    )
                }
            }

            // Advance to next entry
            offset = dataStart + compressedSize
        }

        return nil
    }

    /// Extract text content from Word XML by finding all <w:t> elements.
    ///
    /// Uses a simple regex-based approach rather than a full XML parser to
    /// avoid bringing in heavy dependencies for this specific use case.
    private static func extractTextFromWordXML(_ xml: String) -> String {
        var result: [String] = []
        var currentParagraph: [String] = []

        // Split by paragraph markers
        let paragraphs = xml.components(separatedBy: "<w:p ")
            + xml.components(separatedBy: "<w:p>").dropFirst()

        // Find all <w:t ...>text</w:t> within each paragraph
        let textPattern = #/<w:t[^>]*>([^<]*)<\/w:t>/#

        for paragraph in paragraphs {
            currentParagraph.removeAll()
            for match in paragraph.matches(of: textPattern) {
                let text = String(match.1)
                if !text.isEmpty {
                    currentParagraph.append(text)
                }
            }
            if !currentParagraph.isEmpty {
                result.append(currentParagraph.joined())
            }
        }

        return result.joined(separator: "\n")
    }
}

// MARK: - Document Error

enum DocumentError: LocalizedError, Sendable {
    case unsupportedFormat(String, detail: String? = nil)
    case cannotOpen(path: String)
    case emptyDocument
    case noTextContent(format: String)
    case malformedDocument(format: String, detail: String)

    var errorDescription: String? {
        switch self {
        case let .unsupportedFormat(ext, detail):
            var message = "Unsupported file format: .\(ext)"
            if let detail {
                message += ". \(detail)"
            }
            return message
        case let .cannotOpen(path):
            return "Cannot open file at path: \(path)"
        case .emptyDocument:
            return "The document contains no pages"
        case let .noTextContent(format):
            return "Unable to extract text from \(format) file"
        case let .malformedDocument(format, detail):
            return "Malformed \(format) document: \(detail)"
        }
    }
}
