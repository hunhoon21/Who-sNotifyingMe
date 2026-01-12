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

                    // Hourly Distribution Chart
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Hourly Distribution")
                            .font(.headline)
                            .padding(.horizontal)

                        Chart(notificationManager.getHourlyData()) { data in
                            BarMark(
                                x: .value("Hour", data.hourLabel),
                                y: .value("Count", data.count)
                            )
                            .foregroundStyle(.blue.gradient)
                            .cornerRadius(4)
                        }
                        .frame(height: 200)
                        .padding(.horizontal)
                    }

                    // Daily Trend Chart
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Daily Trend")
                            .font(.headline)
                            .padding(.horizontal)

                        Chart(notificationManager.getDailyData()) { data in
                            LineMark(
                                x: .value("Day", data.dayLabel),
                                y: .value("Count", data.count)
                            )
                            .foregroundStyle(.purple)
                            .interpolationMethod(.catmullRom)

                            AreaMark(
                                x: .value("Day", data.dayLabel),
                                y: .value("Count", data.count)
                            )
                            .foregroundStyle(.purple.opacity(0.1))
                            .interpolationMethod(.catmullRom)
                        }
                        .frame(height: 200)
                        .padding(.horizontal)
                    }

                    // Category Breakdown
                    VStack(alignment: .leading, spacing: 12) {
                        Text("By Category")
                            .font(.headline)
                            .padding(.horizontal)

                        CategoryBreakdownView(stats: notificationManager.appStats)
                    }

                    // Insights Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Insights")
                            .font(.headline)
                            .padding(.horizontal)

                        InsightCard(
                            icon: "lightbulb.fill",
                            title: "Peak Notification Time",
                            description: "Most notifications arrive between 2-3 PM",
                            color: .orange
                        )

                        InsightCard(
                            icon: "arrow.up.right",
                            title: "Trending",
                            description: "Instagram notifications increased 23% this week",
                            color: .red
                        )

                        InsightCard(
                            icon: "checkmark.circle.fill",
                            title: "Suggestion",
                            description: "Consider muting Twitter during work hours",
                            color: .green
                        )
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Analytics")
        }
    }
}

struct CategoryBreakdownView: View {
    let stats: [AppNotificationStats]

    private var categoryData: [(category: NotificationCategory, count: Int)] {
        Dictionary(grouping: stats, by: { $0.category })
            .map { (category: $0.key, count: $0.value.reduce(0) { $0 + $1.totalCount }) }
            .sorted { $0.count > $1.count }
    }

    var body: some View {
        VStack(spacing: 8) {
            ForEach(categoryData, id: \.category) { item in
                HStack {
                    Image(systemName: item.category.icon)
                        .frame(width: 24)

                    Text(item.category.rawValue)
                        .font(.subheadline)

                    Spacer()

                    Text("\(item.count)")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
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
