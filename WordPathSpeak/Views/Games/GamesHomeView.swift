import SwiftUI

struct GamesHomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: AACGridScreen()) {
                    Text("AAC Grid")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                }

                NavigationLink(destination: AddWordView()) {
                    Text("Add Word")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Games Home")
        }
    }
}
