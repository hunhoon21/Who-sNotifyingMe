import Foundation

enum DataMode: String, Codable, CaseIterable {
    case demo = "demo"
    case tracking = "tracking"

    var displayName: String {
        switch self {
        case .demo: return String(localized: "Demo Mode")
        case .tracking: return String(localized: "Tracking Mode")
        }
    }

    var description: String {
        switch self {
        case .demo:
            return String(localized: "Experience the app with sample data")
        case .tracking:
            return String(localized: "Track your actual notifications")
        }
    }

    var iconName: String {
        switch self {
        case .demo: return "sparkles"
        case .tracking: return "hand.tap"
        }
    }
}

enum InputSource: String, Codable {
    case manual = "manual"
    case automatic = "automatic"
    case demo = "demo"

    var displayName: String {
        switch self {
        case .manual: return "Manual"
        case .automatic: return "Automatic"
        case .demo: return "Demo"
        }
    }
}
