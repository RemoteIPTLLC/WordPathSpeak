import SwiftUI

struct AddWordView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: DataStore

    @State private var label: String = ""
    @State private var category: WordCategory = .custom
    @State private var icon: String = "square.fill"
    @State private var assetName: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Word")) {
                    TextField("Label (e.g., “juice”)", text: $label)

                    Picker("Category", selection: $category) {
                        ForEach(WordCategory.allCases, id: \.self) { cat in
                            Text(cat.displayName).tag(cat)
                        }
                    }
                }

                Section(header: Text("Appearance")) {
                    TextField("SF Symbol (optional)", text: $icon)
                    TextField("Asset name (optional)", text: $assetName)

                    HStack {
                        Text("Preview:")
                        Spacer()
                        if !assetName.isEmpty, UIImage(named: assetName) != nil {
                            Image(assetName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.secondary.opacity(0.2)))
                        } else {
                            Image(systemName: icon.isEmpty ? "square.fill" : icon)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
            .navigationTitle("Add Word")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.addWord(
                            WordItem(
                                label: label.trimmingCharacters(in: .whitespacesAndNewlines),
                                category: category,
                                icon: icon.isEmpty ? nil : icon,
                                assetName: assetName.isEmpty ? nil : assetName,
                                speechType: .system,
                                audioURL: nil,
                                tags: [],
                                synonyms: [],
                                ownerProfileID: nil
                            )
                        )
                        dismiss()
                    }
                    .disabled(label.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
