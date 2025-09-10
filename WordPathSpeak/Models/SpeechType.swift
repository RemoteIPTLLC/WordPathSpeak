import Foundation

enum SpeechType: String, CaseIterable, Codable {
    case system      // Use system TTS
    case recording   // Play a recorded audio file

    var displayName: String {
        switch self {
        case .system: return "System Speech"
        case .recording: return "Recorded Audio"
        }
    }
}
