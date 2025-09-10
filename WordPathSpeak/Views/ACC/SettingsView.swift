import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var datastore: DataStore

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Profile")) {
                    Picker("Select Profile", selection: $datastore.currentProfile) {
                        ForEach(datastore.profiles, id: \.name) { profile in
                            Text(profile.name).tag(profile.name)
                        }
                    }
                }

                Section(header: Text("Categories")) {
                    ForEach(datastore.categories, id: \.self) { category in
                        Text(category)
                    }
                }

                Section(header: Text("Options")) {
                    Toggle("Grouped", isOn: $datastore.isGrouped)
                }
            }
            .navigationTitle("Settings")
            .formStyle(.grouped)
        }
    }
}
