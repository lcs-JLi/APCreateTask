import SwiftUI

struct AvatarPreview: View {
    let appearance: AvatarAppearance

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.91, green: 0.97, blue: 0.91))
                .frame(width: 152, height: 152)
                .overlay {
                    Circle()
                        .strokeBorder(.white, lineWidth: 5)
                }

            VStack(spacing: -3) {
                ZStack {
                    Circle()
                        .fill(appearance.skinTone.color)
                        .frame(width: 77, height: 77)
                    Text("☺")
                        .font(.system(size: 54, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(red: 0.18, green: 0.23, blue: 0.21))
                        .offset(y: 2)
                    Text(appearance.hairstyle.symbol)
                        .font(.system(size: 31))
                        .offset(x: 28, y: -31)
                }
                Text(appearance.outfit.symbol)
                    .font(.system(size: 69))
                    .frame(height: 78)
                    .accessibilityHidden(true)
            }
            .offset(y: 6)

            Text("⭐️")
                .font(.system(size: 25))
                .offset(x: 63, y: -52)
                .accessibilityHidden(true)

            if !appearance.equippedEquipment.isEmpty {
                HStack(spacing: 2) {
                    ForEach(appearance.equippedEquipment.sorted { $0.rawValue < $1.rawValue }) { item in
                        Text(item.symbol)
                            .font(.system(size: 19))
                    }
                }
                .padding(.horizontal, 7)
                .padding(.vertical, 4)
                .background(.white.opacity(0.95), in: Capsule())
                .offset(y: 65)
                .accessibilityHidden(true)
            }
        }
    }
}
