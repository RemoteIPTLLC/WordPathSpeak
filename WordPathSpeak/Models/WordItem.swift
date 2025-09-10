import Foundation

struct WordItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var label: String
    var category: WordCategory?
    var icon: String?
    var assetName: String?
    var speechType: SpeechType = .system
    var audioURL: URL?
    var tags: [String] = []
    var synonyms: [String] = []
    var ownerProfileID: UUID?
}
