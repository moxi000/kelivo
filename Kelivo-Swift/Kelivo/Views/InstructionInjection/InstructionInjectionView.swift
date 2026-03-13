import SwiftUI
import SwiftData

@available(iOS 26.0, macOS 26.0, *)
struct InstructionInjectionView: View {
    @Environment(InstructionInjectionViewModel.self) private var injectionVM
    @State private var showAddSheet = false
    @State private var newName = ""
    @State private var newContent = ""
    @State private var newPosition: InstructionInjection.Position = .before

    var body: some View {
        List {
            ForEach(injectionVM.injections) { injection in
                NavigationLink {
                    InstructionInjectionEditView(injection: injection)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(injection.name)
                                .font(.headline)
                            Text(injection.content)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                            HStack(spacing: 8) {
                                Text(injection.position == .before
                                     ? String(localized: "beforeUserMessage")
                                     : String(localized: "afterUserMessage"))
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(.quaternary)
                                    .clipShape(Capsule())
                            }
                        }
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { injection.isEnabled },
                            set: { newValue in
                                injection.isEnabled = newValue
                                injectionVM.updateInjection(injection)
                            }
                        ))
                        .labelsHidden()
                    }
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    injectionVM.deleteInjection(injectionVM.injections[index])
                }
            }
        }
        .navigationTitle(String(localized: "instructionInjection"))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.glass)
            }
        }
        .sheet(isPresented: $showAddSheet) {
            NavigationStack {
                Form {
                    TextField(String(localized: "name"), text: $newName)
                    Picker(String(localized: "position"), selection: $newPosition) {
                        Text(String(localized: "beforeUserMessage")).tag(InstructionInjection.Position.before)
                        Text(String(localized: "afterUserMessage")).tag(InstructionInjection.Position.after)
                    }
                    Section(String(localized: "content")) {
                        TextEditor(text: $newContent)
                            .frame(minHeight: 150)
                    }
                }
                .navigationTitle(String(localized: "addInjection"))
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(String(localized: "cancel")) { showAddSheet = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(String(localized: "save")) {
                            injectionVM.addInjection(name: newName, content: newContent, position: newPosition)
                            newName = ""
                            newContent = ""
                            showAddSheet = false
                        }
                        .disabled(newName.isEmpty || newContent.isEmpty)
                    }
                }
            }
        }
    }
}

@available(iOS 26.0, macOS 26.0, *)
private struct InstructionInjectionEditView: View {
    @Bindable var injection: InstructionInjection
    @Environment(InstructionInjectionViewModel.self) private var injectionVM

    var body: some View {
        Form {
            TextField(String(localized: "name"), text: $injection.name)
            Picker(String(localized: "position"), selection: $injection.position) {
                Text(String(localized: "beforeUserMessage")).tag(InstructionInjection.Position.before)
                Text(String(localized: "afterUserMessage")).tag(InstructionInjection.Position.after)
            }
            Toggle(String(localized: "enabled"), isOn: $injection.isEnabled)
            Section(String(localized: "content")) {
                TextEditor(text: $injection.content)
                    .frame(minHeight: 200)
            }
        }
        .navigationTitle(injection.name)
        .onChange(of: injection.name) { injectionVM.updateInjection(injection) }
        .onChange(of: injection.content) { injectionVM.updateInjection(injection) }
    }
}
