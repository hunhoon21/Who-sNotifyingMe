import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @AppStorage("enableDailySummary") private var enableDailySummary = true
    @AppStorage("dailyReportTime") private var dailyReportTime = Date()
    @State private var showClearDataAlert = false
    @State private var showResetAlert = false

    var body: some View {
        NavigationStack {
            List {
                // Data Mode Section
                Section {
                    HStack {
                        Image(systemName: notificationManager.dataMode.iconName)
                            .foregroundStyle(notificationManager.dataMode == .demo ? .orange : .green)
                            .frame(width: 28)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(notificationManager.dataMode.displayName)
                                .font(.body)
                            Text(notificationManager.dataMode.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Button(notificationManager.dataMode == .demo ? "Start Tracking" : "View Demo") {
                            if notificationManager.dataMode == .demo {
                                notificationManager.switchToTracking()
                            } else {
                                notificationManager.switchToDemo()
                            }
                        }
                        .font(.caption.weight(.medium))
                        .buttonStyle(.bordered)
                    }
                } header: {
                    Text("Data Mode")
                } footer: {
                    Text(notificationManager.dataMode == .demo
                         ? "Demo mode shows sample data to explore app features."
                         : "Tracking mode records notifications you manually add.")
                }

                // Notification Permissions
                Section {
                    HStack {
                        Label("Notification Access", systemImage: "bell.badge")
                        Spacer()
                        if notificationManager.isAuthorized {
                            Text("Granted")
                                .font(.caption)
                                .foregroundStyle(.green)
                        } else {
                            Button("Enable") {
                                Task {
                                    await notificationManager.requestAuthorization()
                                }
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }
                    }

                    Button {
                        notificationManager.openAppSettings()
                    } label: {
                        HStack {
                            Label("Open iOS Settings", systemImage: "gear")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Permissions")
                } footer: {
                    Text("To manage app notifications, go to iOS Settings > Notifications.")
                }

                // Preferences
                Section("Preferences") {
                    Toggle(isOn: $enableDailySummary) {
                        Label("Daily Summary", systemImage: "doc.text")
                    }

                    if enableDailySummary {
                        DatePicker(
                            selection: $dailyReportTime,
                            displayedComponents: .hourAndMinute
                        ) {
                            Label("Summary Time", systemImage: "clock")
                        }
                    }
                }

                // Data Management
                Section {
                    if notificationManager.dataMode == .tracking {
                        NavigationLink {
                            ExportDataView()
                        } label: {
                            Label("Export Data", systemImage: "square.and.arrow.up")
                        }

                        Button(role: .destructive) {
                            showClearDataAlert = true
                        } label: {
                            Label("Clear All Data", systemImage: "trash")
                        }
                    }

                    Button(role: .destructive) {
                        showResetAlert = true
                    } label: {
                        Label("Reset to Demo", systemImage: "arrow.counterclockwise")
                    }
                } header: {
                    Text("Data")
                }

                // About
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }

                    NavigationLink {
                        PrivacyPolicyView()
                    } label: {
                        Text("Privacy Policy")
                    }

                    NavigationLink {
                        LimitationsView()
                    } label: {
                        Text("iOS Limitations")
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Clear All Data?", isPresented: $showClearDataAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    notificationManager.clearAllData()
                }
            } message: {
                Text("This will delete all your tracked notifications. This action cannot be undone.")
            }
            .alert("Reset to Demo?", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    notificationManager.resetToDemo()
                }
            } message: {
                Text("This will clear your data and switch to demo mode.")
            }
        }
    }
}

struct ExportDataView: View {
    @EnvironmentObject var notificationManager: NotificationManager

    var body: some View {
        List {
            Section {
                Button {
                    exportAsJSON()
                } label: {
                    Label("Export as JSON", systemImage: "doc.text")
                }

                Button {
                    exportAsCSV()
                } label: {
                    Label("Export as CSV", systemImage: "tablecells")
                }
            } footer: {
                Text("Export your notification data for backup or analysis.")
            }
        }
        .navigationTitle("Export Data")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func exportAsJSON() {
        // TODO: Implement JSON export
    }

    private func exportAsCSV() {
        // TODO: Implement CSV export
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy Policy")
                    .font(.title.weight(.bold))

                Text("Your privacy is important to us. This app processes all notification data locally on your device. We do not collect, store, or transmit any personal information to external servers.")

                Text("Data Collection")
                    .font(.headline)

                Text("- Notification metadata (app names, timestamps, categories)\n- No notification content is stored\n- All data remains on your device")

                Text("Third-Party Services")
                    .font(.headline)

                Text("This app does not use any third-party analytics or tracking services.")
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LimitationsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("iOS Limitations")
                    .font(.title.weight(.bold))

                LimitationCard(
                    icon: "lock.shield",
                    title: "Cannot Access Other Apps' Notifications",
                    description: "iOS security prevents apps from reading notifications sent by other apps. This is why you need to manually log notifications."
                )

                LimitationCard(
                    icon: "gear.badge.xmark",
                    title: "Cannot Directly Disable Notifications",
                    description: "Apps cannot programmatically disable notifications for other apps. We can only guide you to iOS Settings."
                )

                LimitationCard(
                    icon: "arrow.up.right.square",
                    title: "Settings Deep Link Limited",
                    description: "We can open your app's settings, but cannot jump directly to a specific app's notification settings."
                )

                Text("Future Improvements")
                    .font(.headline)
                    .padding(.top)

                Text("We're working on integrating Screen Time API (requires Apple approval) which may provide automatic notification statistics in future updates.")
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("Limitations")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LimitationCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.orange)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    SettingsView()
        .environmentObject(NotificationManager())
}
