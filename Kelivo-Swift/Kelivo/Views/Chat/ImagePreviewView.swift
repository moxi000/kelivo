import SwiftUI

// MARK: - ImagePreviewView

/// Displays a grid of attached images with full-screen preview and deletion support.
struct ImagePreviewView: View {
    @Binding var imagePaths: [String]

    @State private var selectedIndex: Int?
    @Namespace private var imageNamespace

    // MARK: Body

    var body: some View {
        VStack(spacing: 0) {
            if imagePaths.isEmpty {
                emptyState
            } else {
                imageGrid
            }
        }
        .navigationTitle(String(localized: "imagePreview"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .sheet(item: selectedIndexBinding) { wrapper in
            fullScreenPreview(index: wrapper.index)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        ContentUnavailableView(
            String(localized: "noImages"),
            systemImage: "photo.on.rectangle.angled",
            description: Text(String(localized: "noImagesAttached"))
        )
    }

    // MARK: - Image Grid

    private var imageGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 120, maximum: 200), spacing: 8)
                ],
                spacing: 8
            ) {
                ForEach(Array(imagePaths.enumerated()), id: \.offset) {
                    index,
                    path in
                    imageCell(path: path, index: index)
                }
            }
            .padding()
        }
    }

    private func imageCell(path: String, index: Int) -> some View {
        ZStack(alignment: .topTrailing) {
            loadedImage(path: path)
                .scaledToFill()
                .frame(minHeight: 120)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .glassCard(cornerRadius: 12)
                .onTapGesture {
                    selectedIndex = index
                }

            // Delete button
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    guard index < imagePaths.count else { return }
                    imagePaths.remove(at: index)
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .black.opacity(0.6))
            }
            .buttonStyle(.plain)
            .padding(6)
        }
    }

    // MARK: - Full Screen Preview

    private func fullScreenPreview(index: Int) -> some View {
        NavigationStack {
            Group {
                if index < imagePaths.count {
                    loadedImage(path: imagePaths[index])
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ContentUnavailableView(
                        String(localized: "imageNotFound"),
                        systemImage: "photo"
                    )
                }
            }
            .background(.black)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "done")) {
                        selectedIndex = nil
                    }
                    .tint(.white)
                }

                if index < imagePaths.count {
                    ToolbarItem(placement: .destructiveAction) {
                        Button(role: .destructive) {
                            imagePaths.remove(at: index)
                            selectedIndex = nil
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
        }
    }

    // MARK: - Image Loading

    @ViewBuilder
    private func loadedImage(path: String) -> some View {
        #if os(iOS)
        if let uiImage = UIImage(contentsOfFile: path) {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            imagePlaceholder
        }
        #elseif os(macOS)
        if let nsImage = NSImage(contentsOfFile: path) {
            Image(nsImage: nsImage)
                .resizable()
        } else {
            imagePlaceholder
        }
        #endif
    }

    private var imagePlaceholder: some View {
        Rectangle()
            .fill(.quaternary)
            .overlay {
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.tertiary)
            }
    }

    // MARK: - Index Wrapper

    private var selectedIndexBinding: Binding<IndexWrapper?> {
        Binding(
            get: { selectedIndex.map { IndexWrapper(index: $0) } },
            set: { selectedIndex = $0?.index }
        )
    }
}

/// Identifiable wrapper for an integer index, used for sheet presentation.
private struct IndexWrapper: Identifiable {
    let index: Int
    var id: Int { index }
}

// MARK: - Preview

#Preview {
    @Previewable @State var paths: [String] = []

    NavigationStack {
        ImagePreviewView(imagePaths: $paths)
    }
}
