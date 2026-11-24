import SwiftUI

struct GameMenuView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var appearance: AvatarAppearance
    @Binding var history: [GameRun]
    @Binding var wordPuzzleHistory: [WordPuzzleRun]
    @Binding var level: Int
    @Binding var experience: Double
    @Binding var coins: Int
    @Binding var coinExperienceProgress: Double
    @Binding var unlockedItems: Set<String>
    @State private var showsResetConfirmation = false

    var body: some View {
        GeometryReader { geometry in
            let horizontalPadding: CGFloat = 20
            let availableWidth = max(0, geometry.size.width - horizontalPadding * 2)
            let spacing: CGFloat = geometry.size.width < 500 ? 12 : 40
            let buttonWidth = min(280, availableWidth * 0.48)
            let avatarWidth = min(210, max(0, availableWidth - buttonWidth - spacing))
            let avatarScale = min(avatarWidth / 152, 1.25)

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

                VStack {
                    Text("EPIC QUEST")
                        .font(.system(size: 44, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                        .accessibilityAddTraits(.isHeader)
                        .padding(.top, 28)

                    HStack(spacing: 10) {
                        ExperienceProgressView(level: level, experience: experience)
                            .frame(maxWidth: .infinity)
                        CoinBalanceView(coins: coins)
                    }
                        .padding(.horizontal, horizontalPadding)
                        .frame(maxWidth: 560)

                    Spacer(minLength: 20)

                    HStack(alignment: .bottom, spacing: 0) {
                        VStack(spacing: 2) {
                            AvatarPreview(appearance: appearance)
                                .frame(width: 152, height: 180)
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel(avatarDescription)
                                .overlay(alignment: .top) {
                                    Button {
                                        dismiss()
                                    } label: {
                                        Label("Avatar", systemImage: "person.crop.square.fill")
                                            .font(.system(size: 12, weight: .heavy, design: .rounded))
                                            .foregroundStyle(Color(red: 0.20, green: 0.48, blue: 0.45))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 7)
                                            .frame(minHeight: 44)
                                            .background(.white.opacity(0.96), in: Capsule())
                                            .contentShape(Capsule())
                                    }
                                    .buttonStyle(.plain)
                                    .offset(y: 5)
                                }
                                .scaleEffect(avatarScale)
                                .frame(width: avatarWidth, height: 180, alignment: .bottomLeading)

                            Text(appearance.displayUsername ?? "Explorer")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        .frame(width: avatarWidth)

                        Spacer(minLength: spacing)

                        VStack(spacing: 14) {
                            NavigationLink(value: AppRoute.subjectSelection) {
                                menuButtonLabel(
                                    "START",
                                    systemImage: "play.fill",
                                    color: Color(red: 0.20, green: 0.48, blue: 0.45)
                                )
                            }
                            .buttonStyle(.plain)

                            NavigationLink(value: AppRoute.shop) {
                                menuButtonLabel(
                                    "SHOP",
                                    systemImage: "bag.fill",
                                    color: Color(red: 0.49, green: 0.39, blue: 0.56)
                                )
                            }
                            .buttonStyle(.plain)

                            NavigationLink {
                                EquipmentView(
                                    appearance: $appearance,
                                    unlockedItems: $unlockedItems,
                                    coins: $coins
                                )
                            } label: {
                                menuButtonLabel(
                                    "EQUIPMENT",
                                    systemImage: "backpack.fill",
                                    color: Color(red: 0.30, green: 0.48, blue: 0.63)
                                )
                            }
                            .buttonStyle(.plain)

                            NavigationLink {
                                GameHistoryView(runs: history, wordPuzzleRuns: wordPuzzleHistory)
                            } label: {
                                menuButtonLabel(
                                    "HISTORY",
                                    systemImage: "clock.arrow.circlepath",
                                    color: Color(red: 0.49, green: 0.39, blue: 0.56)
                                )
                            }
                            .buttonStyle(.plain)

                            NavigationLink {
                                SettingsView(
                                    level: $level,
                                    experience: $experience,
                                    coins: $coins,
                                    coinExperienceProgress: $coinExperienceProgress,
                                    backpackEquipped: appearance.equippedEquipment.contains(.backpack)
                                )
                            } label: {
                                menuButtonLabel(
                                    "SETTINGS",
                                    systemImage: "gearshape.fill",
                                    color: Color(red: 0.42, green: 0.48, blue: 0.53)
                                )
                            }
                            .buttonStyle(.plain)

                            Button {
                                showsResetConfirmation = true
                            } label: {
                                menuButtonLabel(
                                    "RESET PROFILE",
                                    systemImage: "arrow.counterclockwise",
                                    color: Color(red: 0.67, green: 0.34, blue: 0.30)
                                )
                            }
                            .buttonStyle(.plain)
                            .accessibilityHint(
                                "Reset your avatar, experience, level, coins, unlocked items, and game history"
                            )

                            Button {} label: {
                                menuButtonLabel(
                                    "EXIT",
                                    systemImage: "xmark",
                                    color: Color.gray.opacity(0.55)
                                )
                            }
                            .buttonStyle(.plain)
                            .disabled(true)
                        }
                        .frame(width: buttonWidth)
                    }
                    .frame(maxWidth: 900)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, horizontalPadding)
                    .padding(.bottom, 24)
                }
            }
        }
        .confirmationDialog(
            "Reset your profile?",
            isPresented: $showsResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset profile", role: .destructive) {
                appearance = AvatarAppearance()
                experience = 0
                level = 1
                coins = 0
                coinExperienceProgress = 0
                unlockedItems.removeAll()
                history.removeAll()
                wordPuzzleHistory.removeAll()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This resets your avatar, coins, experience, level, unlocked items, and all game history.")
        }
    }

    private var avatarDescription: String {
        let equipmentNames = appearance.equippedEquipment
            .sorted { $0.rawValue < $1.rawValue }
            .map(\.name)
            .joined(separator: ", ")
        let equipmentDescription = equipmentNames.isEmpty ? "no equipment" : equipmentNames

        return "Your avatar, \(appearance.displayUsername ?? "Explorer"). " +
            "\(appearance.skinTone.name) skin, " +
            "\(appearance.hairstyle.name) hair, \(appearance.outfit.name) outfit, " +
            "\(equipmentDescription)."
    }

    private func menuButtonLabel(_ title: String, systemImage: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
            Text(title)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .font(.system(size: 17, weight: .heavy, design: .rounded))
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, minHeight: 62)
        .background(color, in: RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    NavigationStack {
        GameMenuView(
            appearance: .constant(AvatarAppearance()),
            history: .constant([]),
            wordPuzzleHistory: .constant([]),
            level: .constant(1),
            experience: .constant(0),
            coins: .constant(0),
            coinExperienceProgress: .constant(0),
            unlockedItems: .constant([])
        )
    }
}
