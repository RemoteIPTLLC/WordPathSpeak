import SwiftUI

struct RootTabView: View {
    // One source of truth injected into all child views
    @StateObject private var store = DataStore()
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            AACGridScreen()
                .environmentObject(store)
                .tabItem {
                    Image(systemName: "rectangle.grid.3x2.fill")
                    Text("AAC")
                }
                .tag(0)

            GamesHomeView()
                .environmentObject(store)
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("Games")
                }
                .tag(1)

            FavoritesView()
                .environmentObject(store)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
                .tag(2)

            SettingsView()
                .environmentObject(store)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}
