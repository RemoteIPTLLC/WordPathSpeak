import SwiftUI

// MARK: - Badge View
struct Badge: View {
    var name: String

    var body: some View {
        Text(name)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.accentColor.opacity(0.2))
            )
            .overlay(
                Capsule()
                    .stroke(Color.accentColor, lineWidth: 1)
            )
    }
}

// MARK: - Achievements View
struct AchievementsView: View {
    let achievements: [String] = [
        "First Word",
        "10 Words Spoken",
        "Daily Streak",
        "Custom Phrase"
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(achievements, id: \.self) { achievement in
                    HStack {
                        Badge(name: achievement)
                        Spacer()
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(.green)
                    }
                }
            }
            .navigationTitle("Achievements")
        }
    }
}

// MARK: - Preview
#Preview {
    AchievementsView()
}
