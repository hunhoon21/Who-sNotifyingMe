import SwiftUI

struct ContentView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var selectedTab: Tab = .dashboard
    @State private var showOnboarding = false

    enum Tab {
        case dashboard
        case apps
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

            NotificationListView()
                .tabItem {
                    Label("Apps", systemImage: "square.grid.2x2")
                }
                .tag(Tab.apps)

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
        .onAppear {
            if !notificationManager.hasCompletedOnboarding {
                showOnboarding = true
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NotificationManager())
}
