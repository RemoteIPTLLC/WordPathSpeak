import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var datastore: DataStore

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Profile")) {
                    Picker("Select Profile", selection: $datastore.selectedProfile) {
                        ForEach(datastore.profiles, id: \.self) { profile in
                            Text(profile.tagProfile).tag(profile)
                        }
                    }
                }

                Section(header: Text("Categories")) {
                    ForEach(datastore.categories, id: \.self) { category in
                        Text(category)
                    }
                }

                Section(header: Text("Options")) {
                    Toggle(isOn: $datastore.isGrouped) {
                        Text("Grouped")
                    }
                }
            }
            .navigationTitle("Settings")
            .formStyle(.grouped) // ✅ Concrete value, no closure
        }
    }
}
