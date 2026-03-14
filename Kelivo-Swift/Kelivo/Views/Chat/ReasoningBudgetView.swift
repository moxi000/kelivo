import SwiftUI

// MARK: - Reasoning Budget

/// Predefined reasoning budget tiers matching the Flutter implementation.
private enum ReasoningTier: Int, CaseIterable, Identifiable {
    case off = 0
    case auto = -1
    case light = 1024
    case medium = 16000
    case heavy = 32000
    case xhigh = 64000

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .off: return String(localized: "Off")
        case .auto: return String(localized: "Auto")
        case .light: return String(localized: "Light")
        case .medium: return String(localized: "Medium")
        case .heavy: return String(localized: "Heavy")
        case .xhigh: return String(localized: "Extra High")
        }
    }

    var icon: String {
        switch self {
        case .off: return "xmark"
        case .auto: return "gearshape"
        case .light: return "brain"
        case .medium: return "brain"
        case .heavy: return "brain"
        case .xhigh: return "brain.head.profile"
        }
    }
}

// MARK: - ReasoningBudgetView

/// Allows the user to select a thinking/reasoning token budget tier.
/// Corresponds to Flutter: `lib/features/chat/widgets/reasoning_budget_sheet.dart`
struct ReasoningBudgetView: View {
    @Environment(\.dismiss) private var dismiss

    /// The currently selected budget value. -1 = auto, 0 = off, positive = token count.
    @Binding var selectedBudget: Int

    /// Whether the extra-high (64k) option should be shown (model-dependent).
    var showXhighOption: Bool = false

    private var activeTiers: [ReasoningTier] {
        var tiers: [ReasoningTier] = [.off, .auto, .light, .medium, .heavy]
        if showXhighOption {
            tiers.append(.xhigh)
        }
        return tiers
    }

    /// Map any raw value to the nearest tier for selection highlight.
    private func bucket(_ value: Int) -> Int {
        if value == -1 { return -1 }
        if value < 1024 { return 0 }
        if value < 16000 { return 1024 }
        if value < 32000 { return 16000 }
        if !showXhighOption { return 32000 }
        if value < 64000 { return 32000 }
        return 64000
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(activeTiers) { tier in
                        tierRow(tier)
                    }
                } footer: {
                    Text(String(localized: "Controls how many tokens the model can use for internal reasoning before responding."))
                }
            }
            .navigationTitle(String(localized: "Reasoning Budget"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Close")) { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }

    // MARK: - Tier Row

    private func tierRow(_ tier: ReasoningTier) -> some View {
        let isActive = bucket(selectedBudget) == tier.rawValue

        return Button {
            selectedBudget = tier.rawValue
            dismiss()
        } label: {
            HStack {
                Image(systemName: tier.icon)
                    .foregroundStyle(isActive ? .tint : .secondary)
                    .frame(width: 24)

                Text(tier.label)
                    .foregroundStyle(isActive ? .tint : .primary)

                Spacer()

                if isActive {
                    Image(systemName: "checkmark")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.tint)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var budget = -1
    ReasoningBudgetView(selectedBudget: $budget, showXhighOption: true)
}
