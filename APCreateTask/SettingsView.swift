import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var level: Int
    @Binding var experience: Double
    @Binding var coins: Int
    @Binding var coinExperienceProgress: Double

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 1.00, green: 0.95, blue: 0.84),
                    Color(red: 0.89, green: 0.97, blue: 0.94)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 18) {
                Text("Settings")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                    .accessibilityAddTraits(.isHeader)

                Text("Level \(level) · \(experience.formatted(.number.precision(.fractionLength(0...1)))) XP")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.33, green: 0.42, blue: 0.44))
                    .multilineTextAlignment(.center)

                CoinBalanceView(coins: coins)

                settingsButton(
                    "Ex · +1,000 EXP",
                    systemImage: "sparkles",
                    color: Color(red: 0.20, green: 0.48, blue: 0.45),
                    action: addExperience
                )

                settingsButton(
                    "Coins · +1,000",
                    systemImage: "dollarsign.circle.fill",
                    color: Color(red: 0.67, green: 0.48, blue: 0.15),
                    action: addCoins
                )

                settingsButton(
                    "Back",
                    systemImage: "arrow.left",
                    color: Color(red: 0.42, green: 0.48, blue: 0.53),
                    action: { dismiss() }
                )
            }
            .padding(24)
            .frame(maxWidth: 480)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle("Settings")
    }

    private func settingsButton(
        _ title: String,
        systemImage: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.system(size: 19, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 62)
                .background(color, in: RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
    }

    private func addExperience() {
        PlayerRewards.awardExperience(
            1_000,
            level: &level,
            experience: &experience,
            coins: &coins,
            coinExperienceProgress: &coinExperienceProgress
        )
    }

    private func addCoins() {
        coins += 1_000
    }
}

#Preview {
    NavigationStack {
        SettingsView(
            level: .constant(1),
            experience: .constant(0),
            coins: .constant(0),
            coinExperienceProgress: .constant(0)
        )
    }
}
