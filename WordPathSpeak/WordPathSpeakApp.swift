import SwiftUI

@main
struct WordPathSpeakApp: App {
    @StateObject private var lockService = ParentLockService()
    @StateObject private var store = DataStore()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(store)
                .environmentObject(lockService)
                .accentColor(AppTheme.accentColor)
        }
    }
}
