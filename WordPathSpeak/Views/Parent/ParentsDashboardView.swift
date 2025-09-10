import SwiftUI

struct ParentsDashboardView: View {
    @EnvironmentObject var store: DataStore

    var body: some View {
        NavigationStack {
            List {
                LabeledContent("Total words", value: "\(store.wordsCount)")
                LabeledContent("Loaded", value: store.isFullyLoaded ? "Yes" : "No")
                if let profile = store.currentProfile {
                    LabeledContent("Current profile", value: profile)
                } else {
                    LabeledContent("Current profile", value: "None")
                }
            }
            .navigationTitle("Parent Dashboard")
        }
    }
}
