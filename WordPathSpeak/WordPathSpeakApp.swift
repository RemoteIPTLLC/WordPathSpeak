import SwiftUI

@main
struct WordPathSpeakApp: App {
    @StateObject private var lockService = ParentLockService()
    @StateObject private var datastore = DataStore() // ✅ Renamed for clarity and consistency

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(datastore)       // ✅ Injected as expected
                .environmentObject(lockService)
                .accentColor(AppTheme.accentColor)
        }
    }
}
