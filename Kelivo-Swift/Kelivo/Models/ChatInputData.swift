import Foundation

// MARK: - DocumentAttachment

struct DocumentAttachment: Equatable {
    let path: String       // absolute file path
    let fileName: String
    let mime: String       // e.g. application/pdf, text/plain
}

// MARK: - ChatInputData

struct ChatInputData: Equatable {
    var text: String
    var imagePaths: [String]            // absolute file paths or data URLs
    var documents: [DocumentAttachment] // selected files

    init(
        text: String = "",
        imagePaths: [String] = [],
        documents: [DocumentAttachment] = []
    ) {
        self.text = text
        self.imagePaths = imagePaths
        self.documents = documents
    }

    /// Whether the input contains any content (text, images, or documents).
    var isEmpty: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && imagePaths.isEmpty
            && documents.isEmpty
    }
}
