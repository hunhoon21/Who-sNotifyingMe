import Foundation

struct AppNotificationStats: Identifiable {
    let id: String
    let appName: String
    let bundleId: String
    let totalCount: Int
    let todayCount: Int
    let weeklyCount: Int
    let category: NotificationCategory
    let peakHour: Int?
    let averageDaily: Double
    let iconSystemName: String

    init(
        appName: String,
        bundleId: String,
        totalCount: Int,
        todayCount: Int = 0,
        weeklyCount: Int = 0,
        category: NotificationCategory = .other,
        peakHour: Int? = nil,
        averageDaily: Double = 0,
        iconSystemName: String = "app.fill"
    ) {
        self.id = bundleId
        self.appName = appName
        self.bundleId = bundleId
        self.totalCount = totalCount
        self.todayCount = todayCount
        self.weeklyCount = weeklyCount
        self.category = category
        self.peakHour = peakHour
        self.averageDaily = averageDaily
        self.iconSystemName = iconSystemName
    }

    var peakHourFormatted: String? {
        guard let hour = peakHour else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        let date = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date())!
        return formatter.string(from: date)
    }
}

struct HourlyNotificationData: Identifiable {
    let id = UUID()
    let hour: Int
    let count: Int

    var hourLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        let date = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date())!
        return formatter.string(from: date)
    }
}

struct DailyNotificationData: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int

    var dayLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
}
