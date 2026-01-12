import Foundation

struct NotificationRecord: Identifiable, Codable {
    let id: UUID
    let appName: String
    let appBundleId: String
    let title: String?
    let body: String?
    let category: NotificationCategory
    let timestamp: Date
    let isRead: Bool

    init(
        id: UUID = UUID(),
        appName: String,
        appBundleId: String,
        title: String? = nil,
        body: String? = nil,
        category: NotificationCategory = .other,
        timestamp: Date = Date(),
        isRead: Bool = false
    ) {
        self.id = id
        self.appName = appName
        self.appBundleId = appBundleId
        self.title = title
        self.body = body
        self.category = category
        self.timestamp = timestamp
        self.isRead = isRead
    }
}

enum NotificationCategory: String, Codable, CaseIterable {
    case social = "Social"
    case messaging = "Messaging"
    case news = "News"
    case shopping = "Shopping"
    case productivity = "Productivity"
    case entertainment = "Entertainment"
    case finance = "Finance"
    case health = "Health"
    case other = "Other"

    var icon: String {
        switch self {
        case .social: return "person.2"
        case .messaging: return "message"
        case .news: return "newspaper"
        case .shopping: return "cart"
        case .productivity: return "checkmark.circle"
        case .entertainment: return "play.circle"
        case .finance: return "dollarsign.circle"
        case .health: return "heart"
        case .other: return "bell"
        }
    }
}
