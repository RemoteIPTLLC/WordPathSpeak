import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataStore: DataStore

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    Picker("Select Profile", selection: $dataStore.currentProfileID) {
                        ForEach(dataStore.profiles) { profile in
                            Text(profile.name).tag(profile.id as UUID?)
                        }
                    }
                }

                Section(header: Text("Categories")) {
                    ForEach(dataStore.categories) { category in
                        HStack {
                            Image(systemName: category.systemImage)
                            Text(category.name)
                        }
                    }
                }

                Section(header: Text("Custom Words")) {
                    Button("Clear Words for Current Profile") {
                        dataStore.clearCustomWordsForCurrentProfile()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
