import Foundation

final class MockDataProvider {
    static let shared = MockDataProvider()

    private init() {}

    // MARK: - App Statistics
    var appStats: [AppNotificationStats] {
        [
            AppNotificationStats(
                appName: "Messages",
                bundleId: "com.apple.MobileSMS",
                totalCount: 156,
                todayCount: 23,
                weeklyCount: 156,
                category: .messaging,
                peakHour: 14,
                averageDaily: 22.3,
                iconSystemName: "message.fill"
            ),
            AppNotificationStats(
                appName: "Instagram",
                bundleId: "com.burbn.instagram",
                totalCount: 89,
                todayCount: 12,
                weeklyCount: 89,
                category: .social,
                peakHour: 20,
                averageDaily: 12.7,
                iconSystemName: "camera.fill"
            ),
            AppNotificationStats(
                appName: "Gmail",
                bundleId: "com.google.Gmail",
                totalCount: 67,
                todayCount: 8,
                weeklyCount: 67,
                category: .productivity,
                peakHour: 10,
                averageDaily: 9.6,
                iconSystemName: "envelope.badge.fill"
            ),
            AppNotificationStats(
                appName: "KakaoTalk",
                bundleId: "com.kakao.talk",
                totalCount: 234,
                todayCount: 45,
                weeklyCount: 234,
                category: .messaging,
                peakHour: 19,
                averageDaily: 33.4,
                iconSystemName: "bubble.left.fill"
            ),
            AppNotificationStats(
                appName: "Twitter/X",
                bundleId: "com.atebits.Tweetie2",
                totalCount: 45,
                todayCount: 5,
                weeklyCount: 45,
                category: .social,
                peakHour: 18,
                averageDaily: 6.4,
                iconSystemName: "at"
            ),
            AppNotificationStats(
                appName: "Slack",
                bundleId: "com.tinyspeck.chatlyio",
                totalCount: 34,
                todayCount: 7,
                weeklyCount: 34,
                category: .productivity,
                peakHour: 11,
                averageDaily: 4.9,
                iconSystemName: "number.square.fill"
            ),
            AppNotificationStats(
                appName: "YouTube",
                bundleId: "com.google.ios.youtube",
                totalCount: 28,
                todayCount: 3,
                weeklyCount: 28,
                category: .entertainment,
                peakHour: 21,
                averageDaily: 4.0,
                iconSystemName: "play.rectangle.fill"
            ),
            AppNotificationStats(
                appName: "Coupang",
                bundleId: "com.coupang.mobile",
                totalCount: 42,
                todayCount: 6,
                weeklyCount: 42,
                category: .shopping,
                peakHour: 12,
                averageDaily: 6.0,
                iconSystemName: "cart.fill"
            )
        ]
    }

    var todayTotal: Int {
        appStats.reduce(0) { $0 + $1.todayCount }
    }

    var weeklyTotal: Int {
        appStats.reduce(0) { $0 + $1.weeklyCount }
    }

    // MARK: - Hourly Distribution
    func getHourlyData() -> [HourlyNotificationData] {
        [
            HourlyNotificationData(hour: 7, count: 3),
            HourlyNotificationData(hour: 8, count: 8),
            HourlyNotificationData(hour: 9, count: 15),
            HourlyNotificationData(hour: 10, count: 22),
            HourlyNotificationData(hour: 11, count: 18),
            HourlyNotificationData(hour: 12, count: 12),
            HourlyNotificationData(hour: 13, count: 8),
            HourlyNotificationData(hour: 14, count: 25),
            HourlyNotificationData(hour: 15, count: 19),
            HourlyNotificationData(hour: 16, count: 14),
            HourlyNotificationData(hour: 17, count: 11),
            HourlyNotificationData(hour: 18, count: 16),
            HourlyNotificationData(hour: 19, count: 28),
            HourlyNotificationData(hour: 20, count: 24),
            HourlyNotificationData(hour: 21, count: 18),
            HourlyNotificationData(hour: 22, count: 9),
            HourlyNotificationData(hour: 23, count: 4)
        ]
    }

    // MARK: - Daily Trend
    func getDailyData() -> [DailyNotificationData] {
        let calendar = Calendar.current
        let counts = [68, 72, 58, 85, 91, 45, 77]

        return (0..<7).reversed().enumerated().map { index, daysAgo in
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date())!
            return DailyNotificationData(date: date, count: counts[index])
        }
    }

    // MARK: - Sample Notifications
    func getSampleNotifications() -> [NotificationRecord] {
        let now = Date()
        return [
            NotificationRecord(
                appName: "Messages",
                appBundleId: "com.apple.MobileSMS",
                title: "Mom",
                body: "Don't forget dinner tonight!",
                category: .messaging,
                timestamp: now.addingTimeInterval(-300),
                inputSource: .demo
            ),
            NotificationRecord(
                appName: "Instagram",
                appBundleId: "com.burbn.instagram",
                title: nil,
                body: "john_doe liked your photo",
                category: .social,
                timestamp: now.addingTimeInterval(-1800),
                inputSource: .demo
            ),
            NotificationRecord(
                appName: "Gmail",
                appBundleId: "com.google.Gmail",
                title: "Weekly Report",
                body: "Your weekly summary is ready",
                category: .productivity,
                timestamp: now.addingTimeInterval(-3600),
                inputSource: .demo
            )
        ]
    }
}
