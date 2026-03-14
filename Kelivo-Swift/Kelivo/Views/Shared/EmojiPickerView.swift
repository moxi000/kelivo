import SwiftUI

/// A simple emoji picker grid view.
struct EmojiPickerView: View {
    @Environment(\.dismiss) private var dismiss
    let onSelect: (String) -> Void

    @State private var searchText = ""

    private static let commonEmojis: [String] = [
        "😀", "😃", "😄", "😁", "😆", "😅", "🤣", "😂", "🙂", "🙃",
        "😉", "😊", "😇", "🥰", "😍", "🤩", "😘", "😗", "😚", "😙",
        "🥲", "😋", "😛", "😜", "🤪", "😝", "🤑", "🤗", "🤭", "🫢",
        "🤫", "🤔", "🫡", "🤐", "🤨", "😐", "😑", "😶", "🫥", "😏",
        "😒", "🙄", "😬", "🤥", "😌", "😔", "😪", "🤤", "😴", "😷",
        "🤒", "🤕", "🤢", "🤮", "🥵", "🥶", "🥴", "😵", "🤯", "🤠",
        "🥳", "🥸", "😎", "🤓", "🧐", "😕", "🫤", "😟", "🙁", "😮",
        "😯", "😲", "😳", "🥺", "🥹", "😦", "😧", "😨", "😰", "😥",
        "😢", "😭", "😱", "😖", "😣", "😞", "😓", "😩", "😫", "🥱",
        "😤", "😡", "😠", "🤬", "😈", "👿", "💀", "☠️", "💩", "🤡",
        "👹", "👺", "👻", "👽", "👾", "🤖", "😺", "😸", "😹", "😻",
        "🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯",
        "🦁", "🐮", "🐷", "🐸", "🐵", "🐔", "🐧", "🐦", "🦅", "🦆",
        "❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤍", "🤎", "💔",
        "💯", "💢", "💥", "💫", "💦", "💨", "🕳️", "💣", "💬", "👋",
        "🤚", "🖐️", "✋", "🖖", "🫱", "🫲", "🫳", "🫴", "👌", "🤌",
        "🤏", "✌️", "🤞", "🫰", "🤟", "🤘", "🤙", "👈", "👉", "👆",
        "🖕", "👇", "☝️", "🫵", "👍", "👎", "✊", "👊", "🤛", "🤜",
        "⭐", "🌟", "✨", "⚡", "🔥", "💧", "🌈", "☀️", "🌤️", "⛅",
        "🎉", "🎊", "🎈", "🎁", "🏆", "🏅", "🥇", "🥈", "🥉", "⚽",
    ]

    private var filteredEmojis: [String] {
        if searchText.isEmpty { return Self.commonEmojis }
        return Self.commonEmojis.filter { $0.contains(searchText) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 8), spacing: 4) {
                    ForEach(filteredEmojis, id: \.self) { emoji in
                        Button {
                            onSelect(emoji)
                            dismiss()
                        } label: {
                            Text(emoji)
                                .font(.title)
                                .frame(width: 44, height: 44)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .searchable(text: $searchText, prompt: String(localized: "Search emoji"))
            .navigationTitle(String(localized: "Emoji"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
            }
        }
    }
}

#Preview {
    EmojiPickerView { emoji in
        print("Selected: \(emoji)")
    }
}
