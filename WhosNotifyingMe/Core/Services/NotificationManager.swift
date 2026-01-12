import Foundation
import UserNotifications
import Combine
import SwiftUI

@MainActor
class NotificationManager: ObservableObject {
    // MARK: - Data Mode
    @AppStorage("dataMode") var dataMode: DataMode = .demo {
        didSet { refreshData() }
    }

    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    // MARK: - Published Properties
    @Published var isAuthorized = false
    @Published private(set) var appStats: [AppNotificationStats] = []
    @Published private(set) var todayTotal: Int = 0
    @Published private(set) var weeklyTotal: Int = 0

    // MARK: - Dependencies
    private let notificationCenter = UNUserNotificationCenter.current()
    private let mockProvider = MockDataProvider.shared
    private let dataStore = DataStore.shared
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init() {
        setupBindings()
        Task {
            await checkAuthorizationStatus()
            refreshData()
        }
    }

    // MARK: - Data Mode Switching
    func switchToDemo() {
        dataMode = .demo
    }

    func switchToTracking() {
        dataMode = .tracking
    }

    // MARK: - Data Refresh
    func refreshData() {
        switch dataMode {
        case .demo:
            loadDemoData()
        case .tracking:
            loadTrackingData()
        }
    }

    private func loadDemoData() {
        appStats = mockProvider.appStats
        todayTotal = mockProvider.todayTotal
        weeklyTotal = mockProvider.weeklyTotal
    }

    private func loadTrackingData() {
        appStats = dataStore.getAppStats()
        todayTotal = dataStore.getTodayTotal()
        weeklyTotal = dataStore.getWeeklyTotal()
    }

    private func setupBindings() {
        dataStore.$notifications
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard self?.dataMode == .tracking else { return }
                self?.loadTrackingData()
            }
            .store(in: &cancellables)
    }

    // MARK: - Chart Data
    func getHourlyData() -> [HourlyNotificationData] {
        switch dataMode {
        case .demo:
            return mockProvider.getHourlyData()
        case .tracking:
            return dataStore.getHourlyData()
        }
    }

    func getDailyData() -> [DailyNotificationData] {
        switch dataMode {
        case .demo:
            return mockProvider.getDailyData()
        case .tracking:
            return dataStore.getDailyData()
        }
    }

    // MARK: - Manual Notification Entry
    func addNotification(_ record: NotificationRecord) {
        dataStore.addNotification(record)
        if dataMode == .tracking {
            refreshData()
        }
    }

    func addNotification(for appInfo: AppInfo, at timestamp: Date = Date()) {
        let record = NotificationRecord(from: appInfo, timestamp: timestamp)
        addNotification(record)
    }

    func deleteNotification(_ record: NotificationRecord) {
        dataStore.deleteNotification(record)
        if dataMode == .tracking {
            refreshData()
        }
    }

    // MARK: - Data Management
    func clearAllData() {
        dataStore.clearAllNotifications()
        refreshData()
    }

    func resetToDemo() {
        dataStore.clearAllNotifications()
        dataMode = .demo
    }

    // MARK: - Authorization
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

    // MARK: - Settings Helper
    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    // MARK: - Statistics Helpers
    var hasData: Bool {
        !appStats.isEmpty
    }

    var topApps: [AppNotificationStats] {
        Array(appStats.prefix(5))
    }

    func stats(for bundleId: String) -> AppNotificationStats? {
        appStats.first { $0.bundleId == bundleId }
    }

    var categoryBreakdown: [(category: NotificationCategory, count: Int, percentage: Double)] {
        let grouped = Dictionary(grouping: appStats) { $0.category }
        let total = Double(appStats.reduce(0) { $0 + $1.totalCount })

        return grouped.map { category, stats in
            let count = stats.reduce(0) { $0 + $1.totalCount }
            let percentage = total > 0 ? (Double(count) / total) * 100 : 0
            return (category: category, count: count, percentage: percentage)
        }
        .sorted { $0.count > $1.count }
    }
}
