import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var datastore: DataStore

    var body: some View {
        NavigationStack {
            SwiftUI.Form {
                SwiftUI.Section(header: Text("Profile")) {
                    Picker("Select Profile", selection: $datastore.selectedProfile) {
                        ForEach(datastore.profiles, id: \.self) { profile in
                            Text(profile.tagProfile).tag(profile)
                        }
                    }
                }

                SwiftUI.Section(header: Text("Categories")) {
                    ForEach(datastore.categories, id: \.self) { category in
                        Text(category)
                    }
                }

                SwiftUI.Section(header: Text("Options")) {
                    Toggle(isOn: $datastore.isGrouped) {
                        Text("Grouped")
                    }
                }
            }
            .navigationTitle("Settings")
            .formStyle(.grouped) // ✅ Explicit style, no closure
        }
    }
}
