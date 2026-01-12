import Foundation

final class DataStore: ObservableObject {
    static let shared = DataStore()

    private let userDefaults = UserDefaults.standard
    private let notificationsKey = "stored_notifications"
    private let customAppsKey = "custom_apps"

    @Published private(set) var notifications: [NotificationRecord] = []
    @Published private(set) var customApps: [AppInfo] = []

    private init() {
        loadNotifications()
        loadCustomApps()
    }

    // MARK: - Notifications CRUD

    func addNotification(_ record: NotificationRecord) {
        notifications.insert(record, at: 0)
        saveNotifications()
    }

    func deleteNotification(_ record: NotificationRecord) {
        notifications.removeAll { $0.id == record.id }
        saveNotifications()
    }

    func deleteNotifications(for bundleId: String) {
        notifications.removeAll { $0.appBundleId == bundleId }
        saveNotifications()
    }

    func clearAllNotifications() {
        notifications.removeAll()
        saveNotifications()
    }

    // MARK: - Statistics Calculation

    func getAppStats() -> [AppNotificationStats] {
        let grouped = Dictionary(grouping: notifications) { $0.appBundleId }

        return grouped.map { bundleId, records in
            let appInfo = AppInfo.find(byBundleId: bundleId)
                ?? customApps.first { $0.bundleId == bundleId }

            let todayRecords = records.filter { $0.timestamp.isToday }
            let weekRecords = records.filter { $0.timestamp.isThisWeek }

            let hourCounts = Dictionary(grouping: records) { $0.timestamp.hour }
            let peakHour = hourCounts.max { $0.value.count < $1.value.count }?.key

            let dayCount = Set(records.map { Calendar.current.startOfDay(for: $0.timestamp) }).count
            let avgDaily = dayCount > 0 ? Double(records.count) / Double(dayCount) : 0

            return AppNotificationStats(
                appName: records.first?.appName ?? "Unknown",
                bundleId: bundleId,
                totalCount: records.count,
                todayCount: todayRecords.count,
                weeklyCount: weekRecords.count,
                category: appInfo?.category ?? .other,
                peakHour: peakHour,
                averageDaily: avgDaily,
                iconSystemName: appInfo?.iconSystemName ?? "app.fill"
            )
        }
        .sorted { $0.todayCount > $1.todayCount }
    }

    func getTodayTotal() -> Int {
        notifications.filter { $0.timestamp.isToday }.count
    }

    func getWeeklyTotal() -> Int {
        notifications.filter { $0.timestamp.isThisWeek }.count
    }

    func getHourlyData() -> [HourlyNotificationData] {
        let todayNotifications = notifications.filter { $0.timestamp.isToday }
        let grouped = Dictionary(grouping: todayNotifications) { $0.timestamp.hour }

        return (0..<24).map { hour in
            HourlyNotificationData(hour: hour, count: grouped[hour]?.count ?? 0)
        }
    }

    func getDailyData() -> [DailyNotificationData] {
        let calendar = Calendar.current
        let last7Days = (0..<7).map { daysAgo in
            calendar.date(byAdding: .day, value: -daysAgo, to: Date())!
        }.reversed()

        return last7Days.map { date in
            let dayStart = calendar.startOfDay(for: date)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
            let count = notifications.filter {
                $0.timestamp >= dayStart && $0.timestamp < dayEnd
            }.count
            return DailyNotificationData(date: date, count: count)
        }
    }

    // MARK: - Custom Apps

    func addCustomApp(_ app: AppInfo) {
        guard !customApps.contains(where: { $0.bundleId == app.bundleId }) else { return }
        customApps.append(app)
        saveCustomApps()
    }

    func removeCustomApp(_ app: AppInfo) {
        customApps.removeAll { $0.bundleId == app.bundleId }
        saveCustomApps()
    }

    // MARK: - Persistence

    private func loadNotifications() {
        guard let data = userDefaults.data(forKey: notificationsKey),
              let decoded = try? JSONDecoder().decode([NotificationRecord].self, from: data) else {
            return
        }
        notifications = decoded
    }

    private func saveNotifications() {
        guard let encoded = try? JSONEncoder().encode(notifications) else { return }
        userDefaults.set(encoded, forKey: notificationsKey)
    }

    private func loadCustomApps() {
        guard let data = userDefaults.data(forKey: customAppsKey),
              let decoded = try? JSONDecoder().decode([AppInfo].self, from: data) else {
            return
        }
        customApps = decoded
    }

    private func saveCustomApps() {
        guard let encoded = try? JSONEncoder().encode(customApps) else { return }
        userDefaults.set(encoded, forKey: customAppsKey)
    }
}
