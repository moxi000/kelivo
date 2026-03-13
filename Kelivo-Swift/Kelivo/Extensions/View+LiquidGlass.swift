#if canImport(SwiftUI)
import SwiftUI

extension View {
    /// Applies a Liquid Glass card effect with the specified corner radius.
    @ViewBuilder
    func glassCard(cornerRadius: CGFloat = 16) -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
        } else {
            self
        }
    }

    /// Applies a Liquid Glass effect suitable for toolbar areas.
    @ViewBuilder
    func glassToolbarStyle() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.glassEffect(.regular, in: .rect(cornerRadius: 0))
        } else {
            self
        }
    }
}
#endif
