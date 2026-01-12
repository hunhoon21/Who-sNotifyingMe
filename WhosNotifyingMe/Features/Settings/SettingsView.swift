import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @AppStorage("enableNotifications") private var enableNotifications = true
    @AppStorage("showBadge") private var showBadge = true
    @AppStorage("dailyReportTime") private var dailyReportTime = Date()

    var body: some View {
        NavigationStack {
            List {
                // Notification Permissions
                Section {
                    HStack {
                        Label("Notification Access", systemImage: "bell.badge")
                        Spacer()
                        if notificationManager.isAuthorized {
                            Text("Granted")
                                .foregroundStyle(.green)
                        } else {
                            Button("Enable") {
                                Task {
                                    await notificationManager.requestAuthorization()
                                }
                            }
                            .buttonStyle(.bordered)
                        }
                    }

                    NavigationLink {
                        ScreenTimePermissionView()
                    } label: {
                        Label("Screen Time Access", systemImage: "hourglass")
                    }
                } header: {
                    Text("Permissions")
                } footer: {
                    Text("These permissions are required to track and analyze notifications.")
                }

                // Preferences
                Section("Preferences") {
                    Toggle(isOn: $enableNotifications) {
                        Label("Daily Summary", systemImage: "doc.text")
                    }

                    Toggle(isOn: $showBadge) {
                        Label("Show Badge Count", systemImage: "app.badge")
                    }

                    DatePicker(
                        selection: $dailyReportTime,
                        displayedComponents: .hourAndMinute
                    ) {
                        Label("Report Time", systemImage: "clock")
                    }
                }

                // Data Management
                Section("Data") {
                    NavigationLink {
                        ExportDataView()
                    } label: {
                        Label("Export Data", systemImage: "square.and.arrow.up")
                    }

                    Button(role: .destructive) {
                        // Clear all data
                    } label: {
                        Label("Clear All Data", systemImage: "trash")
                    }
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

                    Link(destination: URL(string: "https://github.com")!) {
                        HStack {
                            Text("GitHub")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct ScreenTimePermissionView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "hourglass.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)

            Text("Screen Time Access")
                .font(.title2.weight(.bold))

            Text("To analyze notification patterns from all apps, we need access to Screen Time data. This helps us provide accurate statistics and insights.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .navigationTitle("Screen Time")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExportDataView: View {
    var body: some View {
        List {
            Section {
                Button {
                    // Export as JSON
                } label: {
                    Label("Export as JSON", systemImage: "doc.text")
                }

                Button {
                    // Export as CSV
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

#Preview {
    SettingsView()
        .environmentObject(NotificationManager())
}
