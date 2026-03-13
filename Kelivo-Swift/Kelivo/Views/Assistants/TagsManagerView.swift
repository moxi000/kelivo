import SwiftUI
import SwiftData

struct TagsManagerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \AssistantTag.sortOrder) private var tags: [AssistantTag]

    @State private var newTagName = ""
    @State private var newTagColor: Color = .blue
    @State private var editingTag: AssistantTag?

    var body: some View {
        List {
            // MARK: - Add Tag
            Section {
                HStack(spacing: 12) {
                    ColorPicker("", selection: $newTagColor)
                        .labelsHidden()
                        .frame(width: 30)

                    TextField(String(localized: "Tag Name"), text: $newTagName)

                    Button {
                        addTag()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                    .disabled(newTagName.isEmpty)
                }
            } header: {
                Text(String(localized: "New Tag"))
            }

            // MARK: - Tag List
            Section {
                ForEach(tags) { tag in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(colorFromHex(tag.color))
                            .frame(width: 16, height: 16)

                        if editingTag?.id == tag.id {
                            TextField(String(localized: "Tag Name"), text: Binding(
                                get: { tag.name },
                                set: { tag.name = $0 }
                            ))
                            .onSubmit { editingTag = nil }

                            ColorPicker("", selection: Binding(
                                get: { colorFromHex(tag.color) },
                                set: { tag.color = hexFromColor($0) }
                            ))
                            .labelsHidden()
                            .frame(width: 30)
                        } else {
                            Text(tag.name)
                                .onTapGesture { editingTag = tag }
                            Spacer()
                        }
                    }
                }
                .onDelete(perform: deleteTags)
                .onMove(perform: moveTags)
            } header: {
                Text(String(localized: "Tags"))
            }
        }
        .navigationTitle(String(localized: "Tags"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { EditButton() }
        #endif
        .overlay {
            if tags.isEmpty {
                ContentUnavailableView {
                    Label(String(localized: "No Tags"), systemImage: "tag")
                } description: {
                    Text(String(localized: "Create tags to organize your assistants."))
                }
            }
        }
    }

    // MARK: - Actions

    private func addTag() {
        let tag = AssistantTag(
            name: newTagName,
            color: hexFromColor(newTagColor),
            sortOrder: tags.count
        )
        modelContext.insert(tag)
        newTagName = ""
    }

    private func deleteTags(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(tags[index])
        }
    }

    private func moveTags(from source: IndexSet, to destination: Int) {
        var ordered = tags
        ordered.move(fromOffsets: source, toOffset: destination)
        for (index, tag) in ordered.enumerated() {
            tag.sortOrder = index
        }
    }

    // MARK: - Color Helpers

    private func colorFromHex(_ hex: String) -> Color {
        let cleaned = hex.replacingOccurrences(of: "#", with: "")
        guard cleaned.count == 6, let value = UInt64(cleaned, radix: 16) else {
            return .blue
        }
        return Color(
            red: Double((value >> 16) & 0xFF) / 255.0,
            green: Double((value >> 8) & 0xFF) / 255.0,
            blue: Double(value & 0xFF) / 255.0
        )
    }

    private func hexFromColor(_ color: Color) -> String {
        #if os(iOS)
        let uiColor = UIColor(color)
        var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: nil)
        #elseif os(macOS)
        let nsColor = NSColor(color).usingColorSpace(.deviceRGB) ?? NSColor(color)
        var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0
        nsColor.getRed(&r, green: &g, blue: &b, alpha: nil)
        #endif
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}

#Preview {
    NavigationStack {
        TagsManagerView()
    }
}
