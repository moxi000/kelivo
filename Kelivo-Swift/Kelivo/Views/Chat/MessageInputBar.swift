import SwiftUI
#if os(iOS)
import PhotosUI
#endif

// MARK: - MessageInputBar

/// Input bar at the bottom of the chat view with text editing,
/// image attachment, and send/stop controls.
struct MessageInputBar: View {
    @Environment(ChatViewModel.self) private var chatVM

    @State private var isExpanded = false
    @FocusState private var isFocused: Bool

    #if os(iOS)
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    #endif

    // MARK: Body

    var body: some View {
        VStack(spacing: 0) {
            Divider()

            // Image preview thumbnails
            if !chatVM.selectedImages.isEmpty {
                imagePreviewRow
            }

            // Input row
            HStack(alignment: .bottom, spacing: 10) {
                attachButton
                textInputField
                sendOrStopButton
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .inputBarGlassBackground()
        }
        #if os(macOS)
        .onDrop(of: [.image, .fileURL], isTargeted: nil) { providers in
            handleDrop(providers)
            return true
        }
        #endif
    }

    // MARK: - Text Input

    private var textInputField: some View {
        TextField(
            String(localized: "typeMessage"),
            text: Bindable(chatVM).inputText,
            axis: .vertical
        )
        .lineLimit(isExpanded ? 12 : 4)
        .focused($isFocused)
        .textFieldStyle(.plain)
        .onSubmit {
            #if os(macOS)
            sendMessage()
            #endif
        }
    }

    // MARK: - Attach Button

    private var attachButton: some View {
        #if os(iOS)
        PhotosPicker(
            selection: $selectedPhotoItems,
            maxSelectionCount: 5,
            matching: .images
        ) {
            Image(systemName: "plus.circle.fill")
                .font(.title2)
                .foregroundStyle(.secondary)
        }
        .onChange(of: selectedPhotoItems) { _, items in
            Task { await loadSelectedPhotos(items) }
        }
        #else
        Button {
            openFilePicker()
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.title2)
                .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
        #endif
    }

    // MARK: - Send / Stop Button

    @ViewBuilder
    private var sendOrStopButton: some View {
        if chatVM.isStreaming {
            Button {
                chatVM.stopStreaming()
            } label: {
                Image(systemName: "stop.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.red)
            }
            .glassButtonModifier()
            .help(String(localized: "stopGeneration"))
        } else {
            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundStyle(canSend ? Color.accentPrimary : .secondary)
            }
            .glassButtonModifier()
            .disabled(!canSend)
            .help(String(localized: "sendMessage"))
        }
    }

    // MARK: - Image Preview Row

    private var imagePreviewRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(chatVM.selectedImages.enumerated()), id: \.offset) { index, imageData in
                    imagePreviewThumbnail(data: imageData, index: index)
                }
            }
            .padding(.horizontal, 14)
            .padding(.top, 8)
        }
    }

    private func imagePreviewThumbnail(data: Data, index: Int) -> some View {
        ZStack(alignment: .topTrailing) {
            #if os(iOS)
            if let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            #elseif os(macOS)
            if let nsImage = NSImage(data: data) {
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            #endif

            Button {
                chatVM.selectedImages.remove(at: index)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.white, .black.opacity(0.6))
            }
            .buttonStyle(.plain)
            .offset(x: 4, y: -4)
        }
    }

    // MARK: - Helpers

    private var canSend: Bool {
        !chatVM.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || !chatVM.selectedImages.isEmpty
    }

    private func sendMessage() {
        Task { await chatVM.sendMessage() }
    }

    #if os(iOS)
    private func loadSelectedPhotos(_ items: [PhotosPickerItem]) async {
        var loaded: [Data] = []
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self) {
                loaded.append(data)
            }
        }
        await MainActor.run {
            chatVM.selectedImages.append(contentsOf: loaded)
            selectedPhotoItems = []
        }
    }
    #endif

    #if os(macOS)
    private func openFilePicker() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false

        if panel.runModal() == .OK {
            for url in panel.urls {
                if let data = try? Data(contentsOf: url) {
                    chatVM.selectedImages.append(data)
                }
            }
        }
    }

    private func handleDrop(_ providers: [NSItemProvider]) {
        for provider in providers {
            provider.loadDataRepresentation(forTypeIdentifier: "public.image") { data, _ in
                if let data {
                    DispatchQueue.main.async {
                        chatVM.selectedImages.append(data)
                    }
                }
            }
        }
    }
    #endif
}

// MARK: - Glass Modifiers

private extension View {
    @ViewBuilder
    func inputBarGlassBackground() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.glassEffect(.regular, in: .rect(cornerRadius: 0))
        } else {
            self.background(.bar)
        }
    }

    @ViewBuilder
    func glassButtonModifier() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.buttonStyle(.glass)
        } else {
            self.buttonStyle(.plain)
        }
    }
}

#if os(macOS)
import UniformTypeIdentifiers
#endif
