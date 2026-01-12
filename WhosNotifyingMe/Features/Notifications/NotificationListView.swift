import SwiftUI

struct NotificationListView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var searchText = ""
    @State private var selectedCategory: NotificationCategory?
    @State private var showQuickAdd = false

    var filteredStats: [AppNotificationStats] {
        var result = notificationManager.appStats

        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            result = result.filter { $0.appName.localizedCaseInsensitiveContains(searchText) }
        }

        return result
    }

    var body: some View {
        NavigationStack {
            Group {
                if notificationManager.hasData {
                    List {
                        // Category Filter
                        Section {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    CategoryFilterChip(
                                        title: "All",
                                        isSelected: selectedCategory == nil
                                    ) {
                                        selectedCategory = nil
                                    }

                                    ForEach(NotificationCategory.allCases) { category in
                                        CategoryFilterChip(
                                            title: category.displayName,
                                            icon: category.icon,
                                            isSelected: selectedCategory == category
                                        ) {
                                            selectedCategory = category
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                        }

                        // App List
                        Section {
                            ForEach(filteredStats) { stat in
                                NavigationLink {
                                    AppDetailView(stat: stat)
                                } label: {
                                    AppListRow(stat: stat)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                } else {
                    // Empty State
                    VStack(spacing: 20) {
                        EmptyStateView(
                            icon: "app.badge",
                            title: "No Apps Tracked",
                            message: notificationManager.dataMode == .tracking
                                ? "Start adding notifications to see your app statistics here."
                                : "Switch to tracking mode to start recording notifications."
                        )

                        if notificationManager.dataMode == .tracking {
                            Button {
                                showQuickAdd = true
                            } label: {
                                Label("Add First Notification", systemImage: "plus.circle.fill")
                            }
                            .buttonStyle(.borderedProminent)
                        } else {
                            Button {
                                notificationManager.switchToTracking()
                            } label: {
                                Label("Start Tracking", systemImage: "hand.tap")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .searchable(text: $searchText, prompt: "Search apps")
            .navigationTitle("Apps")
            .toolbar {
                if notificationManager.dataMode == .tracking && notificationManager.hasData {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showQuickAdd = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showQuickAdd) {
                QuickAddView()
            }
        }
    }
}

struct AppListRow: View {
    let stat: AppNotificationStats

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: stat.iconSystemName)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 40, height: 40)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(stat.appName)
                    .font(.body.weight(.medium))

                HStack(spacing: 8) {
                    Text(stat.category.displayName)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if stat.todayCount > 0 {
                        Text("\(stat.todayCount) today")
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(stat.totalCount)")
                    .font(.headline)

                Text("total")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct CategoryFilterChip: View {
    let title: String
    var icon: String?
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                }
                Text(title)
                    .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color(.systemGray5))
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
    }
}

struct AppDetailView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    let stat: AppNotificationStats
    @State private var showQuickAdd = false

    var body: some View {
        List {
            // App Header
            Section {
                HStack(spacing: 16) {
                    Image(systemName: stat.iconSystemName)
                        .font(.largeTitle)
                        .foregroundStyle(.blue)
                        .frame(width: 64, height: 64)
                        .background(Color(.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(stat.appName)
                            .font(.title2.weight(.bold))

                        Text(stat.category.displayName)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .listRowBackground(Color.clear)
            }

            // Statistics
            Section("Statistics") {
                StatRow(title: "Today", value: "\(stat.todayCount)", highlight: true)
                StatRow(title: "This Week", value: "\(stat.weeklyCount)")
                StatRow(title: "Total", value: "\(stat.totalCount)")
                StatRow(title: "Daily Average", value: String(format: "%.1f", stat.averageDaily))

                if let peakHour = stat.peakHourFormatted {
                    StatRow(title: "Peak Hour", value: peakHour)
                }
            }

            // Actions
            Section("Actions") {
                Button {
                    notificationManager.openAppSettings()
                } label: {
                    HStack {
                        Label("Manage in iOS Settings", systemImage: "gear")
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                if notificationManager.dataMode == .tracking {
                    Button {
                        showQuickAdd = true
                    } label: {
                        Label("Add Notification", systemImage: "plus.circle")
                    }
                }
            }

            // Guide
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("How to manage notifications")
                        .font(.subheadline.weight(.medium))

                    Text("To disable or adjust notifications for \(stat.appName):")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("1. Open iOS Settings\n2. Tap Notifications\n3. Find \(stat.appName)\n4. Adjust settings as needed")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle(stat.appName)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showQuickAdd) {
            QuickAddView()
        }
    }
}

struct StatRow: View {
    let title: String
    let value: String
    var highlight: Bool = false

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .fontWeight(highlight ? .semibold : .regular)
                .foregroundStyle(highlight ? .blue : .secondary)
        }
    }
}

#Preview {
    NotificationListView()
        .environmentObject(NotificationManager())
}
