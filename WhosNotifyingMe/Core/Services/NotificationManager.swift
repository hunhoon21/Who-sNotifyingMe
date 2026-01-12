import Foundation
import UserNotifications
import Combine

@MainActor
class NotificationManager: ObservableObject {
    @Published var isAuthorized = false
    @Published var notifications: [NotificationRecord] = []
    @Published var appStats: [AppNotificationStats] = []
    @Published var todayTotal: Int = 0
    @Published var weeklyTotal: Int = 0

    private let notificationCenter = UNUserNotificationCenter.current()

    init() {
        Task {
            await checkAuthorizationStatus()
            loadMockData()
        }
    }

    func requestAuthorization() async {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
            isAuthorized = granted
        } catch {
            print("Authorization error: \(error)")
        }
    }

    func checkAuthorizationStatus() async {
        let settings = await notificationCenter.notificationSettings()
        isAuthorized = settings.authorizationStatus == .authorized
    }

    // Mock data for demonstration
    private func loadMockData() {
        appStats = [
            AppNotificationStats(
                appName: "Messages",
                bundleId: "com.apple.MobileSMS",
                totalCount: 156,
                todayCount: 23,
                weeklyCount: 156,
                category: .messaging,
                peakHour: 14,
                averageDaily: 22.3
            ),
            AppNotificationStats(
                appName: "Instagram",
                bundleId: "com.burbn.instagram",
                totalCount: 89,
                todayCount: 12,
                weeklyCount: 89,
                category: .social,
                peakHour: 20,
                averageDaily: 12.7
            ),
            AppNotificationStats(
                appName: "Gmail",
                bundleId: "com.google.Gmail",
                totalCount: 67,
                todayCount: 8,
                weeklyCount: 67,
                category: .productivity,
                peakHour: 10,
                averageDaily: 9.6
            ),
            AppNotificationStats(
                appName: "Twitter",
                bundleId: "com.atebits.Tweetie2",
                totalCount: 45,
                todayCount: 5,
                weeklyCount: 45,
                category: .social,
                peakHour: 18,
                averageDaily: 6.4
            ),
            AppNotificationStats(
                appName: "Slack",
                bundleId: "com.tinyspeck.chatlyio",
                totalCount: 34,
                todayCount: 7,
                weeklyCount: 34,
                category: .productivity,
                peakHour: 11,
                averageDaily: 4.9
            )
        ]

        todayTotal = appStats.reduce(0) { $0 + $1.todayCount }
        weeklyTotal = appStats.reduce(0) { $0 + $1.weeklyCount }
    }

    func getHourlyData() -> [HourlyNotificationData] {
        // Mock hourly distribution
        return [
            HourlyNotificationData(hour: 8, count: 5),
            HourlyNotificationData(hour: 9, count: 12),
            HourlyNotificationData(hour: 10, count: 18),
            HourlyNotificationData(hour: 11, count: 15),
            HourlyNotificationData(hour: 12, count: 8),
            HourlyNotificationData(hour: 13, count: 6),
            HourlyNotificationData(hour: 14, count: 22),
            HourlyNotificationData(hour: 15, count: 14),
            HourlyNotificationData(hour: 16, count: 11),
            HourlyNotificationData(hour: 17, count: 9),
            HourlyNotificationData(hour: 18, count: 16),
            HourlyNotificationData(hour: 19, count: 13),
            HourlyNotificationData(hour: 20, count: 19),
            HourlyNotificationData(hour: 21, count: 8),
            HourlyNotificationData(hour: 22, count: 4)
        ]
    }

    func getDailyData() -> [DailyNotificationData] {
        let calendar = Calendar.current
        return (0..<7).reversed().map { daysAgo in
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date())!
            return DailyNotificationData(
                date: date,
                count: Int.random(in: 40...80)
            )
        }
    }
}
