import SwiftUI

struct QuickAddView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @Environment(\.dismiss) private var dismiss

    @State private var selectedApp: AppInfo?
    @State private var notificationTime: Date = Date()
    @State private var showAppSelector = false

    var body: some View {
        NavigationStack {
            Form {
                // App Selection
                Section {
                    Button {
                        showAppSelector = true
                    } label: {
                        HStack {
                            if let app = selectedApp {
                                Image(systemName: app.iconSystemName)
                                    .font(.title2)
                                    .foregroundStyle(.blue)
                                    .frame(width: 32)

                                VStack(alignment: .leading) {
                                    Text(app.name)
                                        .foregroundStyle(.primary)
                                    Text(app.category.displayName)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            } else {
                                Image(systemName: "app.badge.fill")
                                    .font(.title2)
                                    .foregroundStyle(.secondary)
                                    .frame(width: 32)

                                Text("Select App")
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                } header: {
                    Text("App")
                } footer: {
                    Text("Select the app that sent the notification")
                }

                // Time Selection
                Section {
                    DatePicker(
                        "Time",
                        selection: $notificationTime,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                } header: {
                    Text("When")
                } footer: {
                    Text("When did you receive this notification?")
                }

                // Quick Add Buttons (Frequently Used)
                if !recentApps.isEmpty {
                    Section {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(recentApps) { app in
                                QuickAppButton(app: app) {
                                    addNotificationAndDismiss(for: app)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    } header: {
                        Text("Quick Add")
                    }
                }
            }
            .navigationTitle("Add Notification")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addNotification()
                    }
                    .disabled(selectedApp == nil)
                }
            }
            .sheet(isPresented: $showAppSelector) {
                AppSelectorView(selectedApp: $selectedApp)
            }
        }
    }

    private var recentApps: [AppInfo] {
        // Return top 6 popular apps for quick add
        Array(AppInfo.popularApps.prefix(6))
    }

    private func addNotification() {
        guard let app = selectedApp else { return }
        addNotificationAndDismiss(for: app)
    }

    private func addNotificationAndDismiss(for app: AppInfo) {
        notificationManager.addNotification(for: app, at: notificationTime)
        dismiss()
    }
}

struct QuickAppButton: View {
    let app: AppInfo
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: app.iconSystemName)
                    .font(.title2)
                    .frame(width: 44, height: 44)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Text(app.name)
                    .font(.caption2)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    QuickAddView()
        .environmentObject(NotificationManager())
}
