import SwiftUI
import Charts

struct AnalyticsView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var selectedTimeRange: TimeRange = .week

    enum TimeRange: String, CaseIterable {
        case day = "Today"
        case week = "Week"
        case month = "Month"
    }

    var body: some View {
        NavigationStack {
            Group {
                if notificationManager.hasData {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Time Range Picker
                            Picker("Time Range", selection: $selectedTimeRange) {
                                ForEach(TimeRange.allCases, id: \.self) { range in
                                    Text(range.rawValue).tag(range)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(.horizontal)

                            // Summary Stats
                            HStack(spacing: 16) {
                                StatCard(
                                    title: "Total",
                                    value: "\(notificationManager.weeklyTotal)",
                                    subtitle: "this week",
                                    color: .blue
                                )

                                StatCard(
                                    title: "Daily Avg",
                                    value: String(format: "%.0f", Double(notificationManager.weeklyTotal) / 7),
                                    subtitle: "notifications",
                                    color: .purple
                                )

                                StatCard(
                                    title: "Apps",
                                    value: "\(notificationManager.appStats.count)",
                                    subtitle: "tracked",
                                    color: .green
                                )
                            }
                            .padding(.horizontal)

                            // Hourly Distribution Chart
                            ChartCard(title: "Hourly Distribution") {
                                Chart(notificationManager.getHourlyData()) { data in
                                    BarMark(
                                        x: .value("Hour", data.hourLabel),
                                        y: .value("Count", data.count)
                                    )
                                    .foregroundStyle(.blue.gradient)
                                    .cornerRadius(4)
                                }
                                .frame(height: 200)
                            }

                            // Daily Trend Chart
                            ChartCard(title: "Daily Trend") {
                                Chart(notificationManager.getDailyData()) { data in
                                    LineMark(
                                        x: .value("Day", data.dayLabel),
                                        y: .value("Count", data.count)
                                    )
                                    .foregroundStyle(.purple)
                                    .interpolationMethod(.catmullRom)
                                    .symbol(Circle().strokeBorder(lineWidth: 2))

                                    AreaMark(
                                        x: .value("Day", data.dayLabel),
                                        y: .value("Count", data.count)
                                    )
                                    .foregroundStyle(.purple.opacity(0.1))
                                    .interpolationMethod(.catmullRom)
                                }
                                .frame(height: 200)
                            }

                            // Category Breakdown
                            ChartCard(title: "By Category") {
                                CategoryBreakdownView(breakdown: notificationManager.categoryBreakdown)
                            }

                            // Insights Section
                            InsightsSection(stats: notificationManager.appStats)
                        }
                        .padding(.vertical)
                    }
                } else {
                    // Empty State
                    VStack(spacing: 20) {
                        EmptyStateView(
                            icon: "chart.bar",
                            title: "No Data to Analyze",
                            message: notificationManager.dataMode == .tracking
                                ? "Start adding notifications to see your analytics."
                                : "Switch to demo mode to see sample analytics."
                        )

                        if notificationManager.dataMode == .tracking {
                            Button {
                                notificationManager.switchToDemo()
                            } label: {
                                Label("View Demo", systemImage: "sparkles")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Analytics")
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(color)

            Text(subtitle)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ChartCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)

            content
                .padding(.horizontal)
        }
    }
}

struct CategoryBreakdownView: View {
    let breakdown: [(category: NotificationCategory, count: Int, percentage: Double)]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(breakdown, id: \.category) { item in
                HStack {
                    Image(systemName: item.category.icon)
                        .foregroundStyle(.blue)
                        .frame(width: 24)

                    Text(item.category.displayName)
                        .font(.subheadline)

                    Spacer()

                    Text("\(item.count)")
                        .font(.subheadline.weight(.medium))

                    Text(String(format: "%.0f%%", item.percentage))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(width: 40, alignment: .trailing)
                }

                if item.category != breakdown.last?.category {
                    Divider()
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct InsightsSection: View {
    let stats: [AppNotificationStats]

    var topApp: AppNotificationStats? {
        stats.max { $0.todayCount < $1.todayCount }
    }

    var peakHourApp: AppNotificationStats? {
        stats.first { $0.peakHour != nil }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Insights")
                .font(.headline)
                .padding(.horizontal)

            if let top = topApp, top.todayCount > 0 {
                InsightCard(
                    icon: "arrow.up.circle.fill",
                    title: "Most Active Today",
                    description: "\(top.appName) sent \(top.todayCount) notifications today",
                    color: .blue
                )
            }

            if let peak = peakHourApp, let hour = peak.peakHourFormatted {
                InsightCard(
                    icon: "clock.fill",
                    title: "Peak Time",
                    description: "\(peak.appName) is most active at \(hour)",
                    color: .orange
                )
            }

            if stats.count > 3 {
                InsightCard(
                    icon: "lightbulb.fill",
                    title: "Tip",
                    description: "Consider reviewing apps with high notification counts",
                    color: .green
                )
            }
        }
    }
}

struct InsightCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.15))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.medium))

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}

#Preview {
    AnalyticsView()
        .environmentObject(NotificationManager())
}
