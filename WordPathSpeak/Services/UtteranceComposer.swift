import Foundation

final class UtteranceComposer: ObservableObject {
    @Published var composed: [WordItem] = []

    func add(_ item: WordItem) {
        composed.append(item)
    }

    func clear() {
        composed.removeAll()
    }

    var utteranceText: String {
        composed.map(\.label).joined(separator: " ")
    }

    func speak() {
        // Placeholder for TTS engine
        print("Speaking: \(utteranceText)")
    }
}
