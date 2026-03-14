import Foundation
import Vision

// MARK: - OCR Error

enum OCRError: Error, LocalizedError {
    case recognitionFailed(String)
    case noTextFound
    case unsupportedImage

    var errorDescription: String? {
        switch self {
        case let .recognitionFailed(detail):
            return "Text recognition failed: \(detail)"
        case .noTextFound:
            return "No text was found in the image"
        case .unsupportedImage:
            return "The image format is not supported for text recognition"
        }
    }
}

// MARK: - OCR Service

/// Extracts text from images using Apple's Vision framework
/// (`VNRecognizeTextRequest`).
///
/// Supports multiple languages and produces a single string with recognized
/// text blocks joined by newlines.
struct OCRService {

    /// Recognition accuracy level.
    enum RecognitionLevel {
        case fast
        case accurate

        var vnLevel: VNRequestTextRecognitionLevel {
            switch self {
            case .fast: return .fast
            case .accurate: return .accurate
            }
        }
    }

    // MARK: - Public API

    /// Recognize text in a `CGImage`.
    ///
    /// - Parameters:
    ///   - image: The source image.
    ///   - languages: BCP-47 language codes to prioritize (e.g. `["en-US", "zh-Hans"]`).
    ///               Pass an empty array to use the system default.
    ///   - level: Recognition accuracy level. `.accurate` is slower but yields
    ///            better results.
    /// - Returns: The recognized text as a single string.
    static func recognizeText(
        from image: CGImage,
        languages: [String] = [],
        level: RecognitionLevel = .accurate
    ) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error {
                    continuation.resume(throwing: OCRError.recognitionFailed(error.localizedDescription))
                    return
                }

                guard let observations = request.results as? [VNRecognizedTextObservation],
                      !observations.isEmpty
                else {
                    continuation.resume(throwing: OCRError.noTextFound)
                    return
                }

                // Collect the top candidate from each observation.
                let lines = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }

                let result = lines.joined(separator: "\n")
                if result.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    continuation.resume(throwing: OCRError.noTextFound)
                } else {
                    continuation.resume(returning: result)
                }
            }

            request.recognitionLevel = level.vnLevel
            request.usesLanguageCorrection = true

            if !languages.isEmpty {
                request.recognitionLanguages = languages
            }

            let handler = VNImageRequestHandler(cgImage: image, options: [:])

            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: OCRError.recognitionFailed(error.localizedDescription))
            }
        }
    }

    /// Recognize text from image data (JPEG, PNG, etc.).
    ///
    /// Convenience wrapper that decodes the data into a `CGImage` first.
    static func recognizeText(
        from imageData: Data,
        languages: [String] = [],
        level: RecognitionLevel = .accurate
    ) async throws -> String {
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil)
        else {
            throw OCRError.unsupportedImage
        }

        return try await recognizeText(from: cgImage, languages: languages, level: level)
    }

    // MARK: - Supported Languages

    /// Returns the list of languages supported by the text recognizer at the
    /// given recognition level.
    static func supportedLanguages(level: RecognitionLevel = .accurate) -> [String] {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = level.vnLevel
        return (try? request.supportedRecognitionLanguages()) ?? []
    }
}
