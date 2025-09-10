import Foundation
import Combine

@MainActor
final class DataStore: ObservableObject {
    @Published var allWords: [WordItem] = []
    @Published var filteredWords: [WordItem] = []
    @Published var searchText: String = ""
    @Published var wordsCount: Int = 0
    @Published var isFullyLoaded: Bool = false
    @Published var currentProfile: String? = nil
    @Published var profiles: [Profile] = []
    @Published var categories: [String] = []
    @Published var isGrouped: Bool = false

    let composer = UtteranceComposer()
    private let wordBank = WordBankService()
    private var cancellables: Set<AnyCancellable> = []

    init() {
        $searchText
            .removeDuplicates()
            .sink { [weak self] q in self?.filter(query: q) }
            .store(in: &cancellables)

        Task {
            let loaded = wordBank.loadAllShards()
            let seeded = wordBank.seedStarterWords()
            let merged = (loaded + seeded).reduce(into: [String: WordItem]()) { dict, item in
                let key = item.label.lowercased()
                if dict[key] == nil { dict[key] = item }
            }
            self.allWords = Array(merged.values)
            self.filteredWords = self.allWords
            self.wordsCount = self.allWords.count
            self.isFullyLoaded = true
        }

        // Example seed data
        self.profiles = [Profile(name: "Default"), Profile(name: "Guest")]
        self.categories = ["Food", "Actions", "Objects"]
    }

    func filter(query: String) {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else {
            filteredWords = allWords
            return
        }
        filteredWords = allWords.filter { item in
            item.label.lowercased().contains(q)
            || item.tags.contains(where: { $0.lowercased().contains(q) })
            || item.synonyms.contains(where: { $0.lowercased().contains(q) })
        }
    }

    func addWord(_ item: WordItem) {
        allWords.insert(item, at: 0)
        filter(query: searchText)
        wordsCount = allWords.count
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

    var composedUtterance: [WordItem] { composer.composed }
    func addToUtterance(_ item: WordItem) { composer.add(item) }
    func clearUtterance() { composer.clear() }
    func speakUtterance() { composer.speak() }
}

struct Profile: Identifiable, Hashable {
    var id = UUID()
    var name: String
}
