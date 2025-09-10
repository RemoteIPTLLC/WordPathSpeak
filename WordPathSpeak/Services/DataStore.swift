import Foundation
import Combine

@MainActor
final class DataStore: ObservableObject {

    // MARK: - Published state
    @Published var allWords: [WordItem] = []
    @Published var filteredWords: [WordItem] = []
    @Published var searchText: String = ""
    @Published var composedUtterance: [WordItem] = []

    // Progress flags
    @Published var isFullyLoaded: Bool = false
    @Published var wordsCount: Int = 0

    // Simple stub so older views compile
    @Published var currentProfile: String? = nil

    // MARK: - Shards
    private let shardsFolderName = "wordbank_shards"
    private var cancellables: Set<AnyCancellable> = []

    init() {
        // live search
        $searchText
            .removeDuplicates()
            .sink { [weak self] q in self?.filter(query: q) }
            .store(in: &cancellables)

        Task { await loadAllShards() }
        seedStarterWordsIfNeeded()
    }

    func filter(query: String) {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else {
            filteredWords = allWords
            return
        }
        filteredWords = allWords.filter { item in
            if item.label.lowercased().contains(q) { return true }
            if item.tags.contains(where: { $0.lowercased().contains(q) }) { return true }
            if item.synonyms.contains(where: { $0.lowercased().contains(q) }) { return true }
            return false
        }
    }

    /// Loads all WordBank-*.json files inside a **folder reference** named `wordbank_shards`
    func loadAllShards() async {
        guard let folderURL = Bundle.main.url(forResource: shardsFolderName, withExtension: nil) else {
            await MainActor.run {
                self.filteredWords = self.allWords
                self.wordsCount = self.allWords.count
                self.isFullyLoaded = true
            }
            return
        }

        do {
            let jsons = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
                .filter { $0.lastPathComponent.hasPrefix("WordBank-") && $0.pathExtension == "json" }
                .sorted { $0.lastPathComponent < $1.lastPathComponent }

            var aggregate: [WordItem] = []
            for url in jsons {
                do {
                    let data = try Data(contentsOf: url)
                    let batch = try JSONDecoder().decode([WordItem].self, from: data)
                    aggregate.append(contentsOf: batch)
                } catch {
                    #if DEBUG
                    print("Shard load error \(url.lastPathComponent): \(error)")
                    #endif
                }
            }

            await MainActor.run {
                // de-dupe by label (case-insensitive), preserve first encountered
                let merged = (self.allWords + aggregate).reduce(into: [String: WordItem]()) { dict, item in
                    let key = item.label.lowercased()
                    if dict[key] == nil { dict[key] = item }
                }
                self.allWords = Array(merged.values)
                self.filteredWords = self.allWords
                self.wordsCount = self.allWords.count
                self.isFullyLoaded = true
            }
        } catch {
            #if DEBUG
            print("Folder read error: \(error)")
            #endif
        }
    }

    // MARK: - Compose / Speak
    func addToUtterance(_ item: WordItem) { composedUtterance.append(item) }
    func clearUtterance() { composedUtterance.removeAll() }
    var speakUtterance: String { composedUtterance.map(\.label).joined(separator: " ") }

    // MARK: - Mutating words
    func addWord(_ item: WordItem) {
        allWords.insert(item, at: 0)
        filter(query: searchText)
        wordsCount = allWords.count
    }

    /// Convenience overload (older calls with fewer params)
    func addWord(label: String,
                 category: String = "Custom",
                 icon: String? = nil,
                 assetName: String? = nil,
                 tags: [String] = [],
                 synonyms: [String] = []) {
        let item = WordItem(label: label,
                            category: category,
                            icon: icon,
                            assetName: assetName,
                            speechType: .system,
                            audioURL: nil,
                            tags: tags,
                            synonyms: synonyms,
                            ownerProfileID: nil)
        addWord(item)
    }

    func deleteWord(id: UUID) {
        allWords.removeAll { $0.id == id }
        filter(query: searchText)
        wordsCount = allWords.count
    }

    func updateWord(_ updated: WordItem) {
        guard let idx = allWords.firstIndex(where: { $0.id == updated.id }) else { return }
        allWords[idx] = updated
        filter(query: searchText)
    }

    // MARK: - Starter words
    private func seedStarterWordsIfNeeded() {
        guard allWords.isEmpty else { return }
        let starters: [WordItem] = [
            WordItem(label: "mom", category: "People", icon: "person.fill", tags: ["mother", "family"]),
            WordItem(label: "dad", category: "People", icon: "person.fill", tags: ["father", "family"]),
            WordItem(label: "me", category: "People", icon: "person", tags: ["self"]),
            WordItem(label: "you", category: "People", icon: "person.2"),
            WordItem(label: "help", category: "Core", icon: "questionmark.circle"),
            WordItem(label: "need", category: "Core", icon: "exclamationmark.triangle"),
            WordItem(label: "want", category: "Core", icon: "star.fill"),
            WordItem(label: "please", category: "Core", icon: "hands.sparkles.fill"),
            WordItem(label: "thank you", category: "Core", icon: "heart.fill"),
            WordItem(label: "eat", category: "Food & Drink", icon: "fork.knife"),
            WordItem(label: "drink", category: "Food & Drink", icon: "cup.and.saucer.fill"),
            WordItem(label: "water", category: "Food & Drink", icon: "drop.fill"),
            WordItem(label: "snack", category: "Food & Drink", icon: "bag.fill"),
            WordItem(label: "go", category: "Actions", icon: "figure.walk"),
            WordItem(label: "stop", category: "Actions", icon: "hand.raised.fill")
        ]
        allWords = starters
        filteredWords = starters
        wordsCount = starters.count
    }
}
