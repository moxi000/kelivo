import SwiftUI

/// A reusable card component that applies Liquid Glass styling.
struct GlassCard<Content: View>: View {
    let cornerRadius: CGFloat
    @ViewBuilder let content: () -> Content

    init(
        cornerRadius: CGFloat = 16,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.content = content
    }

    var body: some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            content()
                .padding()
                .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
        } else {
            content()
                .padding()
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}

#Preview {
    GlassCard {
        Text("Hello, Liquid Glass")
    }
    .padding()
}
