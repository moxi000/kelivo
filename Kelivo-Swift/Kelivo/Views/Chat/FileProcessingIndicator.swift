import SwiftUI

// MARK: - FileProcessingIndicator

/// Shows file processing progress with filename, progress bar,
/// animated loading indicator, and cancel button.
struct FileProcessingIndicator: View {
    let filename: String
    let progress: Double
    var onCancel: (() -> Void)?

    @State private var isAnimating = false

    // MARK: Body

    var body: some View {
        HStack(spacing: 12) {
            // Animated file icon
            loadingIcon

            // File info and progress bar
            VStack(alignment: .leading, spacing: 4) {
                Text(filename)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .truncationMode(.middle)

                ProgressView(value: clampedProgress)
                    .tint(Color.accentPrimary)

                Text(progressLabel)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }

            // Cancel button
            if let onCancel {
                Button {
                    onCancel()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .help(String(localized: "cancelProcessing"))
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .glassCard(cornerRadius: 14)
        .onAppear { isAnimating = true }
    }

    // MARK: - Loading Icon

    private var loadingIcon: some View {
        ZStack {
            Image(systemName: "doc.fill")
                .font(.title3)
                .foregroundStyle(.secondary)

            // Rotating progress ring
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(
                    Color.accentPrimary,
                    style: StrokeStyle(lineWidth: 2, lineCap: .round)
                )
                .frame(width: 28, height: 28)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    .linear(duration: 1.0).repeatForever(autoreverses: false),
                    value: isAnimating
                )
        }
        .frame(width: 36, height: 36)
    }

    // MARK: - Helpers

    private var clampedProgress: Double {
        min(max(progress, 0), 1)
    }

    private var progressLabel: String {
        let percent = Int(clampedProgress * 100)
        return String(localized: "\(percent)% processed")
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        FileProcessingIndicator(
            filename: "document.pdf",
            progress: 0.45
        ) {
            print("Cancelled")
        }

        FileProcessingIndicator(
            filename: "very_long_filename_that_should_truncate.txt",
            progress: 0.8
        )

        FileProcessingIndicator(
            filename: "image.png",
            progress: 0.0
        ) {
            print("Cancelled")
        }
    }
    .padding()
}
