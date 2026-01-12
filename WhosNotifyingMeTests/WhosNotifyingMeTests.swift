import XCTest
@testable import WhosNotifyingMe

final class WhosNotifyingMeTests: XCTestCase {

    override func setUpWithError() throws {
        // Setup before each test
    }

    override func tearDownWithError() throws {
        // Teardown after each test
    }

    // MARK: - NotificationRecord Tests

    func testNotificationRecordInitialization() throws {
        let record = NotificationRecord(
            appName: "Test App",
            appBundleId: "com.test.app",
            title: "Test Title",
            body: "Test Body",
            category: .messaging
        )

        XCTAssertEqual(record.appName, "Test App")
        XCTAssertEqual(record.appBundleId, "com.test.app")
        XCTAssertEqual(record.title, "Test Title")
        XCTAssertEqual(record.body, "Test Body")
        XCTAssertEqual(record.category, .messaging)
        XCTAssertFalse(record.isRead)
    }

    func testNotificationCategoryIcon() throws {
        XCTAssertEqual(NotificationCategory.social.icon, "person.2")
        XCTAssertEqual(NotificationCategory.messaging.icon, "message")
        XCTAssertEqual(NotificationCategory.news.icon, "newspaper")
    }

    // MARK: - AppNotificationStats Tests

    func testAppNotificationStatsInitialization() throws {
        let stats = AppNotificationStats(
            appName: "Messages",
            bundleId: "com.apple.MobileSMS",
            totalCount: 100,
            todayCount: 10,
            weeklyCount: 50,
            category: .messaging,
            peakHour: 14,
            averageDaily: 14.3
        )

        XCTAssertEqual(stats.appName, "Messages")
        XCTAssertEqual(stats.totalCount, 100)
        XCTAssertEqual(stats.todayCount, 10)
        XCTAssertEqual(stats.peakHour, 14)
    }

    // MARK: - Date Extension Tests

    func testDateIsToday() throws {
        let today = Date()
        XCTAssertTrue(today.isToday)

        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        XCTAssertFalse(yesterday.isToday)
    }

    func testDateDaysAgo() throws {
        let today = Date()
        let threeDaysAgo = today.daysAgo(3)

        let calendar = Calendar.current
        let difference = calendar.dateComponents([.day], from: threeDaysAgo, to: today)

        XCTAssertEqual(difference.day, 3)
    }

    // MARK: - Performance Tests

    func testHourlyDataPerformance() throws {
        measure {
            let manager = NotificationManager()
            _ = manager.getHourlyData()
        }
    }
}
