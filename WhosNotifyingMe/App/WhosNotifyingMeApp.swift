import SwiftUI

@main
struct WhosNotifyingMeApp: App {
    @StateObject private var notificationManager = NotificationManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notificationManager)
        }
    }
}
