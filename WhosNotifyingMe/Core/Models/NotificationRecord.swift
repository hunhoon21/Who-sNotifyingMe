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
    let inputSource: InputSource

    init(
        id: UUID = UUID(),
        appName: String,
        appBundleId: String,
        title: String? = nil,
        body: String? = nil,
        category: NotificationCategory = .other,
        timestamp: Date = Date(),
        isRead: Bool = false,
        inputSource: InputSource = .manual
    ) {
        self.id = id
        self.appName = appName
        self.appBundleId = appBundleId
        self.title = title
        self.body = body
        self.category = category
        self.timestamp = timestamp
        self.isRead = isRead
        self.inputSource = inputSource
    }

    // Convenience initializer from AppInfo
    init(from appInfo: AppInfo, timestamp: Date = Date()) {
        self.id = UUID()
        self.appName = appInfo.name
        self.appBundleId = appInfo.bundleId
        self.title = nil
        self.body = nil
        self.category = appInfo.category
        self.timestamp = timestamp
        self.isRead = false
        self.inputSource = .manual
    }
}

enum NotificationCategory: String, Codable, CaseIterable, Identifiable {
    case social = "Social"
    case messaging = "Messaging"
    case news = "News"
    case shopping = "Shopping"
    case productivity = "Productivity"
    case entertainment = "Entertainment"
    case finance = "Finance"
    case health = "Health"
    case other = "Other"

    var id: String { rawValue }

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

    var displayName: String {
        rawValue
    }
}
