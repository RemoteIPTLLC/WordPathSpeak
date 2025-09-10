import Foundation

enum WordCategory: String, CaseIterable, Codable, Hashable {
    case core
    case needs
    case foodAndDrink
    case people
    case places
    case actions
    case feelings
    case custom

    var displayName: String {
        switch self {
        case .core: return "Core"
        case .needs: return "Needs"
        case .foodAndDrink: return "Food & Drink"
        case .people: return "People"
        case .places: return "Places"
        case .actions: return "Actions"
        case .feelings: return "Feelings"
        case .custom: return "Custom"
        }
    }
}
