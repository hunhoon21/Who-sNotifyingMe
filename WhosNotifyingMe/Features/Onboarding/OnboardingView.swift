import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.blue)

                Text("Who's Notifying Me")
                    .font(.largeTitle.weight(.bold))

                Text("Take control of your notifications")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 60)
            .padding(.bottom, 40)

            // Features
            VStack(spacing: 24) {
                FeatureRow(
                    icon: "chart.bar.fill",
                    title: "Track & Analyze",
                    description: "See which apps notify you most"
                )

                FeatureRow(
                    icon: "eye.fill",
                    title: "Visual Insights",
                    description: "Beautiful charts show your notification patterns"
                )

                FeatureRow(
                    icon: "hand.raised.fill",
                    title: "Take Control",
                    description: "Quickly access settings to silence noisy apps"
                )
            }
            .padding(.horizontal, 32)

            Spacer()

            // Mode Selection
            VStack(spacing: 16) {
                Text("Choose how to get started")
                    .font(.headline)

                HStack(spacing: 16) {
                    ModeSelectionCard(
                        mode: .demo,
                        isSelected: false
                    ) {
                        selectMode(.demo)
                    }

                    ModeSelectionCard(
                        mode: .tracking,
                        isSelected: false
                    ) {
                        selectMode(.tracking)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 40)
        }
        .background(Color(.systemBackground))
    }

    private func selectMode(_ mode: DataMode) {
        notificationManager.dataMode = mode
        notificationManager.hasCompletedOnboarding = true
        dismiss()
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 44, height: 44)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }
}

struct ModeSelectionCard: View {
    let mode: DataMode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: mode.iconName)
                    .font(.largeTitle)
                    .foregroundStyle(mode == .demo ? .orange : .green)

                Text(mode.displayName)
                    .font(.headline)

                Text(mode == .demo
                     ? "Explore with\nsample data"
                     : "Start tracking\nyour notifications")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OnboardingView()
        .environmentObject(NotificationManager())
}
