#if os(iOS)
import SwiftUI

// MARK: - iOSSideDrawer

/// iOS side drawer that slides in from the leading edge to show a conversation
/// list. Supports swipe gesture to open/close and an overlay background that
/// dismisses the drawer on tap.
struct iOSSideDrawer<Content: View>: View {
    @Binding var isOpen: Bool
    @ViewBuilder let content: () -> Content

    private let drawerWidth: CGFloat = 300
    @GestureState private var dragOffset: CGFloat = 0

    // MARK: Body

    var body: some View {
        ZStack(alignment: .leading) {
            // Overlay background
            if isOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isOpen = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)
            }

            // Drawer
            HStack(spacing: 0) {
                content()
                    .frame(width: drawerWidth)
                    .background(.regularMaterial)
                    .offset(x: drawerXOffset)

                Spacer(minLength: 0)
            }
            .zIndex(2)
        }
        .gesture(dragGesture)
        .animation(.easeInOut(duration: 0.25), value: isOpen)
    }

    // MARK: - Offset

    private var drawerXOffset: CGFloat {
        let baseOffset = isOpen ? 0 : -drawerWidth
        let clamped = max(-drawerWidth, min(0, baseOffset + dragOffset))
        return clamped
    }

    // MARK: - Gesture

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .updating($dragOffset) { value, state, _ in
                if isOpen {
                    // Only allow dragging to close (negative translation)
                    state = min(0, value.translation.width)
                } else {
                    // Only allow dragging to open (positive translation from left edge)
                    if value.startLocation.x < 30 {
                        state = max(0, value.translation.width)
                    }
                }
            }
            .onEnded { value in
                let threshold = drawerWidth * 0.4
                if isOpen {
                    if value.translation.width < -threshold {
                        isOpen = false
                    }
                } else {
                    if value.startLocation.x < 30 && value.translation.width > threshold {
                        isOpen = true
                    }
                }
            }
    }
}

// MARK: - Convenience Modifier

extension View {
    /// Attaches a side drawer that slides in from the leading edge.
    func sideDrawer<DrawerContent: View>(
        isOpen: Binding<Bool>,
        @ViewBuilder content: @escaping () -> DrawerContent
    ) -> some View {
        ZStack {
            self
            iOSSideDrawer(isOpen: isOpen, content: content)
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var isOpen = true

    NavigationStack {
        VStack {
            Button(String(localized: "toggleSidebar")) {
                withAnimation { isOpen.toggle() }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Chat")
    }
    .sideDrawer(isOpen: $isOpen) {
        VStack(alignment: .leading, spacing: 16) {
            Text(String(localized: "chats"))
                .font(.title2.bold())
                .padding(.top, 60)
                .padding(.horizontal, 16)

            List {
                Text("Conversation 1")
                Text("Conversation 2")
                Text("Conversation 3")
            }
            .listStyle(.plain)
        }
    }
}
#endif
