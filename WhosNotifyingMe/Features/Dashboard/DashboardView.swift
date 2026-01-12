import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var showQuickAdd = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Demo Mode Banner
                    if notificationManager.dataMode == .demo {
                        DemoModeBanner {
                            notificationManager.switchToTracking()
                        }
                    }

                    // Summary Cards
                    HStack(spacing: 16) {
                        SummaryCard(
                            title: String(localized: "Today"),
                            count: notificationManager.todayTotal,
                            icon: "bell.fill",
                            color: .blue
                        )

                        SummaryCard(
                            title: String(localized: "This Week"),
                            count: notificationManager.weeklyTotal,
                            icon: "calendar",
                            color: .purple
                        )
                    }
                    .padding(.horizontal)

                    // Top Apps Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Top Notification Sources")
                                .font(.headline)

                            Spacer()

                            if notificationManager.dataMode == .tracking {
                                Button {
                                    showQuickAdd = true
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                }
                            }
                        }
                        .padding(.horizontal)

                        if notificationManager.hasData {
                            ForEach(notificationManager.topApps) { stat in
                                AppNotificationRow(stat: stat)
                            }
                        } else {
                            EmptyStateView(
                                icon: "bell.slash",
                                title: "No Notifications Yet",
                                message: notificationManager.dataMode == .tracking
                                    ? "Tap + to add your first notification"
                                    : "Switch to tracking mode to start recording"
                            )
                            .padding(.vertical, 40)
                        }
                    }

                    // Quick Actions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Quick Actions")
                            .font(.headline)
                            .padding(.horizontal)

                        HStack(spacing: 12) {
                            if notificationManager.dataMode == .tracking {
                                QuickActionButton(
                                    title: "Add",
                                    icon: "plus.circle.fill",
                                    color: .green
                                ) {
                                    showQuickAdd = true
                                }
                            }

                            QuickActionButton(
                                title: "Settings",
                                icon: "gear",
                                color: .orange
                            ) {
                                notificationManager.openAppSettings()
                            }

                            QuickActionButton(
                                title: notificationManager.dataMode == .demo ? "Track" : "Demo",
                                icon: notificationManager.dataMode == .demo ? "hand.tap" : "sparkles",
                                color: .indigo
                            ) {
                                if notificationManager.dataMode == .demo {
                                    notificationManager.switchToTracking()
                                } else {
                                    notificationManager.switchToDemo()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
            .refreshable {
                notificationManager.refreshData()
            }
            .sheet(isPresented: $showQuickAdd) {
                QuickAddView()
            }
        }
    }
}

// MARK: - Demo Mode Banner
struct DemoModeBanner: View {
    let onSwitchToTracking: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.title3)
                .foregroundStyle(.orange)

            VStack(alignment: .leading, spacing: 2) {
                Text("Demo Mode")
                    .font(.subheadline.weight(.semibold))
                Text("Viewing sample data")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button("Start Tracking") {
                onSwitchToTracking()
            }
            .font(.caption.weight(.medium))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.orange)
            .foregroundStyle(.white)
            .clipShape(Capsule())
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text(title)
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

// MARK: - Summary Card
struct SummaryCard: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Spacer()
            }

            Text("\(count)")
                .font(.system(size: 32, weight: .bold))

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - App Notification Row
struct AppNotificationRow: View {
    let stat: AppNotificationStats

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: stat.iconSystemName)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 44, height: 44)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(stat.appName)
                    .font(.body.weight(.medium))

                Text("\(stat.todayCount) today")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(stat.totalCount)")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(NotificationManager())
}
