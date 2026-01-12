import SwiftUI

struct AppSelectorView: View {
    @Binding var selectedApp: AppInfo?
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var selectedCategory: NotificationCategory?

    private var filteredApps: [AppInfo] {
        var apps = AppInfo.popularApps

        if let category = selectedCategory {
            apps = apps.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            apps = apps.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }

        return apps
    }

    private var groupedApps: [NotificationCategory: [AppInfo]] {
        Dictionary(grouping: filteredApps) { $0.category }
    }

    var body: some View {
        NavigationStack {
            List {
                // Category Filter
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            CategoryChip(
                                title: "All",
                                isSelected: selectedCategory == nil
                            ) {
                                selectedCategory = nil
                            }

                            ForEach(NotificationCategory.allCases) { category in
                                CategoryChip(
                                    title: category.displayName,
                                    icon: category.icon,
                                    isSelected: selectedCategory == category
                                ) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

                // App List
                if selectedCategory != nil {
                    // Flat list when category is selected
                    ForEach(filteredApps) { app in
                        AppRow(app: app, isSelected: selectedApp?.id == app.id) {
                            selectApp(app)
                        }
                    }
                } else {
                    // Grouped by category
                    ForEach(NotificationCategory.allCases) { category in
                        let apps = groupedApps[category] ?? []
                        if !apps.isEmpty {
                            Section(category.displayName) {
                                ForEach(apps) { app in
                                    AppRow(app: app, isSelected: selectedApp?.id == app.id) {
                                        selectApp(app)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .searchable(text: $searchText, prompt: "Search apps")
            .navigationTitle("Select App")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func selectApp(_ app: AppInfo) {
        selectedApp = app
        dismiss()
    }
}

struct AppRow: View {
    let app: AppInfo
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: app.iconSystemName)
                    .font(.title2)
                    .foregroundStyle(.blue)
                    .frame(width: 36, height: 36)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 2) {
                    Text(app.name)
                        .foregroundStyle(.primary)

                    Text(app.category.displayName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.blue)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct CategoryChip: View {
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

#Preview {
    AppSelectorView(selectedApp: .constant(nil))
}
