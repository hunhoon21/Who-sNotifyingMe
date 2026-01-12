import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .dashboard

    enum Tab {
        case dashboard
        case analytics
        case settings
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "bell.badge")
                }
                .tag(Tab.dashboard)

            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar")
                }
                .tag(Tab.analytics)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(Tab.settings)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NotificationManager())
}
