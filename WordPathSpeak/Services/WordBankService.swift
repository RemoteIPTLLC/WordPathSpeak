import Foundation

final class WordBankService {
    private let shardsFolderName = "wordbank_shards"

    func loadAllShards() -> [WordItem] {
        guard let folderURL = Bundle.main.url(forResource: shardsFolderName, withExtension: nil) else {
            return []
        }

        let jsons = (try? FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil))?
            .filter { $0.lastPathComponent.hasPrefix("WordBank-") && $0.pathExtension == "json" } ?? []

        var aggregate: [WordItem] = []
        for url in jsons {
            if let data = try? Data(contentsOf: url),
               let batch = try? JSONDecoder().decode([WordItem].self, from: data) {
                aggregate.append(contentsOf: batch)
            }
        }

        // De-dupe by label
        let merged = aggregate.reduce(into: [String: WordItem]()) { dict, item in
            let key = item.label.lowercased()
            if dict[key] == nil { dict[key] = item }
        }

        return Array(merged.values)
    }

    func seedStarterWords() -> [WordItem] {
        return [
            WordItem(label: "mom", category: .people, icon: "person.fill", tags: ["mother", "family"]),
            WordItem(label: "dad", category: .people, icon: "person.fill", tags: ["father", "family"]),
            WordItem(label: "me", category: .people, icon: "person", tags: ["self"]),
            WordItem(label: "you", category: .people, icon: "person.2"),
            WordItem(label: "help", category: .core, icon: "questionmark.circle"),
            WordItem(label: "need", category: .core, icon: "exclamationmark.triangle"),
            WordItem(label: "want", category: .core, icon: "star.fill"),
            WordItem(label: "please", category: .core, icon: "hands.sparkles.fill"),
            WordItem(label: "thank you", category: .core, icon: "heart.fill"),
            WordItem(label: "eat", category: .foodAndDrink, icon: "fork.knife"),
            WordItem(label: "drink", category: .foodAndDrink, icon: "cup.and.saucer.fill"),
            WordItem(label: "water", category: .foodAndDrink, icon: "drop.fill"),
            WordItem(label: "snack", category: .foodAndDrink, icon: "bag.fill"),
            WordItem(label: "go", category: .actions, icon: "figure.walk"),
            WordItem(label: "stop", category: .actions, icon: "hand.raised.fill")
        ]
    }
}
