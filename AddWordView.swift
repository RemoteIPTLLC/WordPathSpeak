import SwiftUI

struct AddWordView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: DataStore

    @State private var label: String = ""
    @State private var category: String = "Custom"
    @State private var icon: String = "square.fill"
    @State private var assetName: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Word") {
                    TextField("Label (e.g., “juice”)", text: $label)
                    TextField("Category (e.g., “Food & Drink”)", text: $category)
                }
                Section("Appearance") {
                    TextField("SF Symbol (optional)", text: $icon)
                    TextField("Asset name (optional)", text: $assetName)
                }
            }
            .navigationTitle("Add Word")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.addWord(label: label,
                                      category: category,
                                      icon: icon.isEmpty ? nil : icon,
                                      assetName: assetName.isEmpty ? nil : assetName)
                        dismiss()
                    }.disabled(label.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
