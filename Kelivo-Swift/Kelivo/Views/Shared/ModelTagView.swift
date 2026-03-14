import SwiftUI

/// Displays model capability tags (vision, tools, reasoning) as colored pills.
struct ModelTagView: View {
    let abilities: [String]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(abilities, id: \.self) { ability in
                tagView(for: ability)
            }
        }
    }

    @ViewBuilder
    private func tagView(for ability: String) -> some View {
        let (icon, color) = iconAndColor(for: ability)
        HStack(spacing: 2) {
            Image(systemName: icon)
                .font(.caption2)
            Text(ability)
                .font(.caption2)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(color.opacity(0.15), in: Capsule())
        .foregroundStyle(color)
    }

    private func iconAndColor(for ability: String) -> (String, Color) {
        switch ability.lowercased() {
        case "vision", "image":
            return ("eye", .purple)
        case "tool", "tools", "function_calling":
            return ("wrench", .blue)
        case "reasoning", "thinking":
            return ("brain", .orange)
        case "embedding":
            return ("square.grid.3x3", .green)
        case "code":
            return ("chevron.left.forwardslash.chevron.right", .cyan)
        default:
            return ("tag", .secondary)
        }
    }
}

/// Displays a model icon based on provider type.
struct ModelIconView: View {
    let providerType: String
    let size: CGFloat

    init(providerType: String, size: CGFloat = 24) {
        self.providerType = providerType
        self.size = size
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: size, height: size)
            Text(iconText)
                .font(.system(size: size * 0.45, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
    }

    private var backgroundColor: Color {
        switch providerType.lowercased() {
        case "claude", "anthropic": return .orange
        case "openai", "chatgpt": return .green
        case "gemini", "google": return .blue
        case "vertex": return .indigo
        case "ollama": return .gray
        case "deepseek": return .cyan
        case "mistral": return .purple
        default: return .secondary
        }
    }

    private var iconText: String {
        switch providerType.lowercased() {
        case "claude", "anthropic": return "C"
        case "openai", "chatgpt": return "O"
        case "gemini", "google": return "G"
        case "vertex": return "V"
        case "ollama": return "L"
        case "deepseek": return "D"
        case "mistral": return "M"
        default: return String(providerType.prefix(1).uppercased())
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        ModelTagView(abilities: ["vision", "tools", "reasoning"])

        HStack {
            ModelIconView(providerType: "claude")
            ModelIconView(providerType: "openai")
            ModelIconView(providerType: "gemini")
            ModelIconView(providerType: "vertex")
        }
    }
    .padding()
}
