import SwiftUI

struct NotificationListView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var searchText = ""
    @State private var selectedCategory: NotificationCategory?

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

                            ForEach(NotificationCategory.allCases, id: \.self) { category in
                                CategoryFilterChip(
                                    title: category.rawValue,
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
                            AppNotificationRow(stat: stat)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .searchable(text: $searchText, prompt: "Search apps")
            .navigationTitle("Notifications")
        }
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
    let stat: AppNotificationStats

    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: stat.category.icon)
                        .font(.largeTitle)
                        .frame(width: 60, height: 60)
                        .background(Color(.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(stat.appName)
                            .font(.title2.weight(.bold))

                        Text(stat.category.rawValue)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .listRowBackground(Color.clear)
            }

            Section("Statistics") {
                StatRow(title: "Today", value: "\(stat.todayCount)")
                StatRow(title: "This Week", value: "\(stat.weeklyCount)")
                StatRow(title: "Total", value: "\(stat.totalCount)")
                StatRow(title: "Daily Average", value: String(format: "%.1f", stat.averageDaily))

                if let peakHour = stat.peakHour {
                    StatRow(title: "Peak Hour", value: formatHour(peakHour))
                }
            }

            Section("Actions") {
                Button {
                    // Open system notification settings for this app
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Label("Manage in Settings", systemImage: "gear")
                }

                Button(role: .destructive) {
                    // Mute this app
                } label: {
                    Label("Mute Notifications", systemImage: "bell.slash")
                }
            }
        }
        .navigationTitle(stat.appName)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formatHour(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        let date = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date())!
        return formatter.string(from: date)
    }
}

struct StatRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NotificationListView()
        .environmentObject(NotificationManager())
}
