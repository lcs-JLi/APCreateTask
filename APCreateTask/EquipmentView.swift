import SwiftUI

struct EquipmentView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var appearance: AvatarAppearance

    private let columns = [GridItem(.adaptive(minimum: 135), spacing: 12)]

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
                    Text("Choose your gear")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                        .accessibilityAddTraits(.isHeader)

                    AvatarPreview(appearance: appearance)
                        .frame(height: 170)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(avatarDescription)

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(AvatarAppearance.Equipment.allCases) { item in
                            equipmentButton(item)
                        }
                    }

                    Button("Remove all gear") {
                        appearance.equippedEquipment.removeAll()
                    }
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.20, green: 0.48, blue: 0.45))
                    .disabled(appearance.equippedEquipment.isEmpty)

                    Button {
                        dismiss()
                    } label: {
                        Text("DONE")
                            .font(.system(size: 17, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: 420)
                            .frame(height: 56)
                            .background(
                                Color(red: 0.20, green: 0.48, blue: 0.45),
                                in: Capsule()
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 4)
                }
                .padding(20)
                .frame(maxWidth: 600)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Equipment")
    }

    private var avatarDescription: String {
        let equipmentNames = appearance.equippedEquipment
            .sorted { $0.rawValue < $1.rawValue }
            .map(\.name)
            .joined(separator: ", ")
        let equipmentDescription = equipmentNames.isEmpty ? "no equipment" : equipmentNames

        return "Your avatar with \(equipmentDescription)."
    }

    private func equipmentButton(_ item: AvatarAppearance.Equipment) -> some View {
        let isEquipped = appearance.equippedEquipment.contains(item)

        return Button {
            if isEquipped {
                appearance.equippedEquipment.remove(item)
            } else {
                appearance.equippedEquipment.insert(item)
            }
        } label: {
            VStack(spacing: 8) {
                Text(item.symbol)
                    .font(.system(size: 38))
                    .accessibilityHidden(true)

                Text(item.name)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))

                Text(item.effectDescription)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Text(isEquipped ? "Equipped" : "Tap to equip")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(
                        isEquipped
                            ? Color(red: 0.20, green: 0.48, blue: 0.45)
                            : Color.secondary
                    )
            }
            .frame(maxWidth: .infinity, minHeight: 142)
            .background(
                isEquipped ? Color(red: 0.87, green: 0.96, blue: 0.92) : .white.opacity(0.94),
                in: RoundedRectangle(cornerRadius: 20)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(
                        isEquipped ? Color(red: 0.20, green: 0.48, blue: 0.45) : .white,
                        lineWidth: 2
                    )
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(item.name). \(item.effectDescription)")
        .accessibilityValue(isEquipped ? "Equipped" : "Not equipped")
        .accessibilityHint("Toggle this item for your avatar")
    }
}

#Preview {
    NavigationStack {
        EquipmentView(appearance: .constant(AvatarAppearance()))
    }
}
