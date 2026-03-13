import SwiftUI

/// A loading indicator with glass background overlay.
struct LoadingView: View {
    let message: String?

    init(_ message: String? = nil) {
        self.message = message
    }

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .controlSize(.large)

            if let message {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(minWidth: 120, minHeight: 100)
        .glassCard(cornerRadius: 20)
    }
}

/// A full-screen loading overlay that dims the background.
struct LoadingOverlay: View {
    let message: String?
    let isPresented: Bool

    init(_ message: String? = nil, isPresented: Bool = true) {
        self.message = message
        self.isPresented = isPresented
    }

    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()

                LoadingView(message)
            }
            .transition(.opacity)
        }
    }
}

#Preview {
    ZStack {
        Color.blue.opacity(0.3).ignoresSafeArea()
        LoadingView(String(localized: "Loading..."))
    }
}
