//
//  WardrobeView.swift
//  APCreateTask
//
//  Created by John Li on 2026-11-20.
//  This code was generated using GitHub Copilot.
//  The existing wardrobe implementation was not changed.
//

import SwiftUI

struct WardrobeView: View {
    @Binding var appearance: AvatarAppearance
    @Binding var history: [GameRun]
    @Binding var level: Int
    @Binding var coins: Int
    @Binding var unlockedItems: Set<String>
    @State private var selectedCategory: Category = .outfit

    private enum Category: String, CaseIterable, Identifiable {
        case skin = "Skin"
        case hair = "Hair"
        case outfit = "Outfit"

        var id: Self { self }

        var symbol: String {
            switch self {
            case .skin: "face.smiling"
            case .hair: "sparkles"
            case .outfit: "tshirt"
            }
        }
    }

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

            ScrollView {
                VStack(spacing: 20) {
                    header
                    avatarCard
                    customizationCard
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 20)
                .frame(maxWidth: 560)
                .frame(maxWidth: .infinity)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            startButton
        }
#if os(iOS)
        .toolbar(.hidden, for: .navigationBar)
#endif
    }

    private var header: some View {
        VStack(spacing: 8) {
            HStack(spacing: 7) {
                Image(systemName: "sparkles")
                Text("EPIC QUEST")
                    .tracking(1.5)
            }
            .font(.system(size: 13, weight: .heavy, design: .rounded))
            .foregroundStyle(Color(red: 0.31, green: 0.41, blue: 0.43))

            Text("Make your\nadventure avatar!")
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                .minimumScaleFactor(0.8)
                .accessibilityAddTraits(.isHeader)

        }
        .frame(maxWidth: .infinity)
    }

    private var avatarCard: some View {
        VStack(spacing: 8) {
            HStack {
                Label("YOUR EXPLORER", systemImage: "star.fill")
                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                    .tracking(0.8)
                    .foregroundStyle(Color(red: 0.49, green: 0.39, blue: 0.14))
                Spacer()
                Text("✨")
                    .font(.title2)
                    .accessibilityHidden(true)
            }

            AvatarPreview(appearance: appearance)
                .frame(height: 168)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(avatarAccessibilityDescription)

            Text(appearance.displayUsername ?? "Looking great!")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.20, green: 0.39, blue: 0.37))

            TextField("Choose a username", text: $appearance.username)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    Color(red: 0.94, green: 0.96, blue: 0.94),
                    in: RoundedRectangle(cornerRadius: 14)
                )
                .accessibilityLabel("Username")

            Text("Your username will appear with your avatar.")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(18)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 28))
        .overlay {
            RoundedRectangle(cornerRadius: 28)
                .strokeBorder(.white, lineWidth: 2)
        }
        .shadow(color: Color(red: 0.33, green: 0.43, blue: 0.37).opacity(0.10), radius: 16, y: 8)
    }

    private var avatarAccessibilityDescription: String {
        let username = appearance.displayUsername ?? "Explorer"
        let skinTone = "\(appearance.skinTone.name) skin"
        let hairstyle = "\(appearance.hairstyle.name) hair"
        let outfit = "\(appearance.outfit.name) outfit"

        return "Your explorer, \(username). \(skinTone), \(hairstyle), \(outfit)."
    }

    private var customizationCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Pick your style")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                Spacer()
                Text("Tap to change")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 8) {
                ForEach(Category.allCases) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        Label(category.rawValue, systemImage: category.symbol)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 11)
                            .foregroundStyle(selectedCategory == category ? .white : Color.primary)
                            .background {
                                Capsule()
                                    .fill(selectedCategory == category
                                          ? Color(red: 0.20, green: 0.48, blue: 0.45)
                                          : Color(red: 0.94, green: 0.96, blue: 0.94))
                            }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(category.rawValue) options")
                    .accessibilityValue(selectedCategory == category ? "Selected" : "")
                }
            }

            options
                .frame(maxWidth: .infinity)
                .contentTransition(.opacity)
        }
        .padding(18)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 26))
        .shadow(color: Color(red: 0.33, green: 0.43, blue: 0.37).opacity(0.08), radius: 12, y: 6)
    }

    @ViewBuilder
    private var options: some View {
        switch selectedCategory {
        case .skin:
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 72), spacing: 8)], spacing: 8) {
                ForEach(AvatarAppearance.SkinTone.allCases) { tone in
                    let isLocked = !isUnlocked(
                        requirement: tone.unlockRequirement,
                        inventoryID: tone.inventoryID
                    )

                    Button {
                        guard !isLocked else { return }
                        appearance.skinTone = tone
                    } label: {
                        VStack(spacing: 5) {
                            ZStack {
                                Circle()
                                    .fill(tone.color)

                                Circle()
                                    .strokeBorder(
                                        appearance.skinTone == tone
                                            ? Color(red: 0.20, green: 0.48, blue: 0.45)
                                            : .clear,
                                        lineWidth: 3
                                    )

                                if isLocked {
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundStyle(.white)
                                        .padding(5)
                                        .background(.black.opacity(0.55), in: Circle())
                                }
                            }
                            .frame(width: 50, height: 50)

                            Text(tone.name)
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .lineLimit(1)

                            if isLocked {
                                Text(lockLabel(for: tone.unlockRequirement))
                                    .font(.system(size: 9, weight: .medium, design: .rounded))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 82)
                        .background(
                            appearance.skinTone == tone
                                ? Color(red: 0.89, green: 0.96, blue: 0.92)
                                : .white,
                            in: RoundedRectangle(cornerRadius: 14)
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(isLocked)
                    .accessibilityLabel("\(tone.name) skin tone")
                    .accessibilityValue(
                        isLocked
                            ? lockLabel(for: tone.unlockRequirement)
                            : appearance.skinTone == tone ? "Selected" : ""
                    )
                }
            }
        case .hair:
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 78), spacing: 10)], spacing: 10) {
                ForEach(AvatarAppearance.Hairstyle.allCases) { style in
                    let isLocked = !isUnlocked(
                        requirement: style.unlockRequirement,
                        inventoryID: style.inventoryID
                    )

                    optionButton(
                        symbol: style.symbol,
                        title: style.name,
                        isSelected: appearance.hairstyle == style,
                        isLocked: isLocked,
                        lockLabel: lockLabel(for: style.unlockRequirement)
                    ) {
                        appearance.hairstyle = style
                    }
                }
            }
        case .outfit:
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 78), spacing: 10)], spacing: 10) {
                ForEach(AvatarAppearance.Outfit.allCases) { outfit in
                    let isLocked = !isUnlocked(
                        requirement: outfit.unlockRequirement,
                        inventoryID: outfit.inventoryID
                    )

                    optionButton(
                        symbol: outfit.symbol,
                        title: outfit.name,
                        isSelected: appearance.outfit == outfit,
                        isLocked: isLocked,
                        lockLabel: lockLabel(for: outfit.unlockRequirement)
                    ) {
                        appearance.outfit = outfit
                    }
                }
            }
        }
    }

    private func optionButton(
        symbol: String,
        title: String,
        isSelected: Bool,
        isLocked: Bool,
        lockLabel: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Text(symbol)
                    .font(.system(size: 27))
                    .accessibilityHidden(true)
                Text(title)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                if isLocked {
                    Label(lockLabel, systemImage: "lock.fill")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: isLocked ? 84 : 68)
            .background(
                isSelected ? Color(red: 0.89, green: 0.96, blue: 0.92) : .white,
                in: RoundedRectangle(cornerRadius: 15)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(
                        isSelected ? Color(red: 0.20, green: 0.48, blue: 0.45) : Color.gray.opacity(0.16),
                        lineWidth: isSelected ? 2 : 1
                    )
            }
            .foregroundStyle(Color(red: 0.17, green: 0.28, blue: 0.31))
        }
        .buttonStyle(.plain)
        .disabled(isLocked)
        .accessibilityLabel(title)
        .accessibilityValue(isLocked ? lockLabel : isSelected ? "Selected" : "")
    }

    private func isUnlocked(
        requirement: AvatarUnlockRequirement?,
        inventoryID: String
    ) -> Bool {
        guard let requirement else { return true }

        switch requirement {
        case .level(let requiredLevel):
            return level >= requiredLevel
        case .coins, .fortunateWheel:
            return unlockedItems.contains(inventoryID)
        }
    }

    private func lockLabel(for requirement: AvatarUnlockRequirement?) -> String {
        switch requirement {
        case .level(let requiredLevel): "Lv. \(requiredLevel)"
        case .coins(let amount): "\(amount) coins in Shop"
        case .fortunateWheel: "Fortune Wheel"
        case nil: ""
        }
    }

    private var startButton: some View {
        NavigationLink(value: AppRoute.gameMenu) {
            HStack(spacing: 10) {
                Text("Continue")
                Image(systemName: "arrow.right")
            }
            .font(.system(size: 18, weight: .heavy, design: .rounded))
            .foregroundStyle(.white)
            .frame(maxWidth: 560)
            .frame(height: 58)
            .background(Color(red: 0.20, green: 0.48, blue: 0.45), in: Capsule())
            .shadow(color: Color(red: 0.14, green: 0.35, blue: 0.33).opacity(0.24), radius: 9, y: 5)
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityHint("Continue to the game menu")
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
    }
}

#Preview {
    NavigationStack {
        WardrobeView(
            appearance: .constant(AvatarAppearance()),
            history: .constant([]),
            level: .constant(1),
            coins: .constant(0),
            unlockedItems: .constant([])
        )
    }
}
