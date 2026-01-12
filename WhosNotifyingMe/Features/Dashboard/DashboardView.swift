import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var notificationManager: NotificationManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Summary Cards
                    HStack(spacing: 16) {
                        SummaryCard(
                            title: "Today",
                            count: notificationManager.todayTotal,
                            icon: "bell.fill",
                            color: .blue
                        )

                        SummaryCard(
                            title: "This Week",
                            count: notificationManager.weeklyTotal,
                            icon: "calendar",
                            color: .purple
                        )
                    }
                    .padding(.horizontal)

                    // Top Apps Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Top Notification Sources")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(notificationManager.appStats.prefix(5)) { stat in
                            AppNotificationRow(stat: stat)
                        }
                    }

                    // Quick Actions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Quick Actions")
                            .font(.headline)
                            .padding(.horizontal)

                        HStack(spacing: 12) {
                            QuickActionButton(
                                title: "Manage",
                                icon: "slider.horizontal.3",
                                color: .orange
                            ) {
                                // Navigate to notification settings
                            }

                            QuickActionButton(
                                title: "Focus",
                                icon: "moon.fill",
                                color: .indigo
                            ) {
                                // Navigate to focus mode
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
            .refreshable {
                // Refresh data
            }
        }
    }
}

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

struct AppNotificationRow: View {
    let stat: AppNotificationStats

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: stat.category.icon)
                .font(.title2)
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
