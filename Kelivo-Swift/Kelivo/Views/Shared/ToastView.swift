import SwiftUI

/// A toast/snackbar notification that appears at the bottom of the screen.
struct ToastView: View {
    let message: String
    let icon: String?
    let style: ToastStyle

    enum ToastStyle {
        case info, success, warning, error

        var color: Color {
            switch self {
            case .info: return .blue
            case .success: return .green
            case .warning: return .orange
            case .error: return .red
            }
        }

        var defaultIcon: String {
            switch self {
            case .info: return "info.circle.fill"
            case .success: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .error: return "xmark.circle.fill"
            }
        }
    }

    init(_ message: String, icon: String? = nil, style: ToastStyle = .info) {
        self.message = message
        self.icon = icon
        self.style = style
    }

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon ?? style.defaultIcon)
                .foregroundStyle(style.color)
            Text(message)
                .font(.subheadline)
                .lineLimit(2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial, in: Capsule())
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}

/// Modifier to show a toast message.
struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let style: ToastView.ToastStyle
    let duration: TimeInterval

    func body(content: Content) -> some View {
        content.overlay(alignment: .bottom) {
            if isPresented {
                ToastView(message, style: style)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 32)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                isPresented = false
                            }
                        }
                    }
            }
        }
        .animation(.spring(response: 0.3), value: isPresented)
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String, style: ToastView.ToastStyle = .info, duration: TimeInterval = 2.0) -> some View {
        modifier(ToastModifier(isPresented: isPresented, message: message, style: style, duration: duration))
    }
}

#Preview {
    VStack {
        ToastView("Message copied!", style: .success)
        ToastView("Network error occurred", style: .error)
        ToastView("Processing...", style: .info)
        ToastView("Rate limit approaching", style: .warning)
    }
    .padding()
}
