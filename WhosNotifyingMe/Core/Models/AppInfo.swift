import Foundation

struct AppInfo: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let bundleId: String
    let category: NotificationCategory
    let iconSystemName: String

    init(
        name: String,
        bundleId: String,
        category: NotificationCategory,
        iconSystemName: String
    ) {
        self.id = bundleId
        self.name = name
        self.bundleId = bundleId
        self.category = category
        self.iconSystemName = iconSystemName
    }
}

// MARK: - Predefined Popular Apps
extension AppInfo {
    static let popularApps: [AppInfo] = [
        // Messaging
        AppInfo(name: "Messages", bundleId: "com.apple.MobileSMS", category: .messaging, iconSystemName: "message.fill"),
        AppInfo(name: "KakaoTalk", bundleId: "com.kakao.talk", category: .messaging, iconSystemName: "bubble.left.fill"),
        AppInfo(name: "WhatsApp", bundleId: "net.whatsapp.WhatsApp", category: .messaging, iconSystemName: "bubble.left.and.bubble.right.fill"),
        AppInfo(name: "Telegram", bundleId: "ph.telegra.Telegraph", category: .messaging, iconSystemName: "paperplane.fill"),
        AppInfo(name: "LINE", bundleId: "jp.naver.line", category: .messaging, iconSystemName: "ellipsis.bubble.fill"),

        // Social
        AppInfo(name: "Instagram", bundleId: "com.burbn.instagram", category: .social, iconSystemName: "camera.fill"),
        AppInfo(name: "Twitter/X", bundleId: "com.atebits.Tweetie2", category: .social, iconSystemName: "at"),
        AppInfo(name: "Facebook", bundleId: "com.facebook.Facebook", category: .social, iconSystemName: "person.2.fill"),
        AppInfo(name: "TikTok", bundleId: "com.zhiliaoapp.musically", category: .social, iconSystemName: "play.square.fill"),
        AppInfo(name: "LinkedIn", bundleId: "com.linkedin.LinkedIn", category: .social, iconSystemName: "briefcase.fill"),

        // Productivity
        AppInfo(name: "Mail", bundleId: "com.apple.mobilemail", category: .productivity, iconSystemName: "envelope.fill"),
        AppInfo(name: "Gmail", bundleId: "com.google.Gmail", category: .productivity, iconSystemName: "envelope.badge.fill"),
        AppInfo(name: "Slack", bundleId: "com.tinyspeck.chatlyio", category: .productivity, iconSystemName: "number.square.fill"),
        AppInfo(name: "Microsoft Teams", bundleId: "com.microsoft.skype.teams", category: .productivity, iconSystemName: "person.3.fill"),
        AppInfo(name: "Notion", bundleId: "notion.id", category: .productivity, iconSystemName: "doc.text.fill"),
        AppInfo(name: "Calendar", bundleId: "com.apple.mobilecal", category: .productivity, iconSystemName: "calendar"),
        AppInfo(name: "Reminders", bundleId: "com.apple.reminders", category: .productivity, iconSystemName: "checklist"),

        // Entertainment
        AppInfo(name: "YouTube", bundleId: "com.google.ios.youtube", category: .entertainment, iconSystemName: "play.rectangle.fill"),
        AppInfo(name: "Netflix", bundleId: "com.netflix.Netflix", category: .entertainment, iconSystemName: "tv.fill"),
        AppInfo(name: "Spotify", bundleId: "com.spotify.client", category: .entertainment, iconSystemName: "music.note"),
        AppInfo(name: "Apple Music", bundleId: "com.apple.Music", category: .entertainment, iconSystemName: "music.note.list"),

        // Shopping
        AppInfo(name: "Coupang", bundleId: "com.coupang.mobile", category: .shopping, iconSystemName: "cart.fill"),
        AppInfo(name: "Amazon", bundleId: "com.amazon.Amazon", category: .shopping, iconSystemName: "shippingbox.fill"),
        AppInfo(name: "App Store", bundleId: "com.apple.AppStore", category: .shopping, iconSystemName: "bag.fill"),

        // News
        AppInfo(name: "News", bundleId: "com.apple.news", category: .news, iconSystemName: "newspaper.fill"),
        AppInfo(name: "Naver", bundleId: "com.nhn.NSearchPortal", category: .news, iconSystemName: "n.square.fill"),

        // Finance
        AppInfo(name: "Bank App", bundleId: "com.bank.app", category: .finance, iconSystemName: "dollarsign.circle.fill"),
        AppInfo(name: "Wallet", bundleId: "com.apple.Passbook", category: .finance, iconSystemName: "creditcard.fill"),

        // Health
        AppInfo(name: "Health", bundleId: "com.apple.Health", category: .health, iconSystemName: "heart.fill"),
        AppInfo(name: "Fitness", bundleId: "com.apple.fitness", category: .health, iconSystemName: "figure.run"),

        // Other
        AppInfo(name: "Other App", bundleId: "com.other.app", category: .other, iconSystemName: "app.fill")
    ]

    static func find(byBundleId bundleId: String) -> AppInfo? {
        popularApps.first { $0.bundleId == bundleId }
    }

    static func apps(for category: NotificationCategory) -> [AppInfo] {
        popularApps.filter { $0.category == category }
    }
}
