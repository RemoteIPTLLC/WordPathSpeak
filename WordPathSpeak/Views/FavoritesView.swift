import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var store: DataStore
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Image(systemName: "star.fill").font(.system(size: 48))
                Text("Favorites will appear here.")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Favorites")
            .background(Color(.systemBackground))
        }
    }
}
