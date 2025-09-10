import Foundation

struct ChildProfile: Identifiable, Codable {
    let id: UUID
    var name: String
    var avatarKey: String
    var favoritesDBIDs: [Int64] = []
    var gameProgress: GameProgress = .init()
    var achievements: [Achievement] = AchievementCatalog.defaultSet()
    
    init(id: UUID = .init(), name: String, avatarKey: String = "buddy") {
        self.id = id
        self.name = name
        self.avatarKey = avatarKey
        self.achievements = AchievementCatalog.defaultSet()
    }
}

enum AchievementCatalog {
    static func defaultSet() -> [Achievement] {
        return [
            Achievement(
                id: "first_word",
                title: "First Word",
                subtitle: "Spoke your first word",
                symbol: "bubble.left.and.bubble.right.fill"
            ),
            Achievement(
                id: "100_words",
                title: "Word Star",
                subtitle: "100 words spoken",
                symbol: "star.circle.fill"
            ),
            Achievement(
                id: "streak_7",
                title: "Hot Streak",
                subtitle: "7 days in a row",
                symbol: "flame.fill"
            ),
            Achievement(
                id: "streak_30",
                title: "Marathon",
                subtitle: "30 days in a row",
                symbol: "calendar.circle.fill"
            ),
            Achievement(
                id: "10_favorites",
                title: "Collector",
                subtitle: "10 favorites added",
                symbol: "heart.circle.fill"
            )
        ]
    }
}

// MARK: - Equatable & Hashable
extension ChildProfile: Equatable {
    static func == (lhs: ChildProfile, rhs: ChildProfile) -> Bool {
        lhs.id == rhs.id
    }
}

extension ChildProfile: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
