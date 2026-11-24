import SwiftUI

struct AvatarPreview: View {
    let appearance: AvatarAppearance

    private let hairColor = Color(red: 0.22, green: 0.14, blue: 0.11)

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.91, green: 0.97, blue: 0.91))
                .overlay {
                    Circle()
                        .strokeBorder(.white, lineWidth: 5)
                }

            Capsule()
                .fill(appearance.skinTone.color)
                .frame(width: 17, height: 43)
                .rotationEffect(.degrees(-12))
                .offset(x: -43, y: 48)

            Capsule()
                .fill(appearance.skinTone.color)
                .frame(width: 17, height: 43)
                .rotationEffect(.degrees(12))
                .offset(x: 43, y: 48)

            Circle()
                .fill(appearance.skinTone.color)
                .frame(width: 18, height: 18)
                .offset(x: -49, y: 69)

            Circle()
                .fill(appearance.skinTone.color)
                .frame(width: 18, height: 18)
                .offset(x: 49, y: 69)

            clothing

            RoundedRectangle(cornerRadius: 9)
                .fill(appearance.skinTone.color)
                .frame(width: 25, height: 31)
                .offset(y: 27)

            head

            Image(systemName: "star.fill")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color(red: 0.98, green: 0.72, blue: 0.22))
                .offset(x: 62, y: -53)

            if !appearance.equippedEquipment.isEmpty {
                HStack(spacing: 2) {
                    ForEach(appearance.equippedEquipment.sorted { $0.rawValue < $1.rawValue }) { item in
                        Text(item.symbol)
                            .font(.system(size: 17))
                    }
                }
                .padding(.horizontal, 7)
                .padding(.vertical, 4)
                .background(.white.opacity(0.95), in: Capsule())
                .offset(y: 63)
                .accessibilityHidden(true)
            }
        }
        .frame(width: 152, height: 152)
    }

    private var head: some View {
        ZStack {
            Ellipse()
                .fill(hairColor)
                .frame(width: 82, height: 94)
                .offset(y: -15)

            Ellipse()
                .fill(appearance.skinTone.color)
                .frame(width: 66, height: 79)
                .offset(y: -14)

            HStack(spacing: 18) {
                Capsule()
                    .fill(hairColor)
                    .frame(width: 8, height: 2)
                Capsule()
                    .fill(hairColor)
                    .frame(width: 8, height: 2)
            }
            .offset(y: -25)

            HStack(spacing: 19) {
                Circle()
                    .fill(Color(red: 0.16, green: 0.13, blue: 0.12))
                    .frame(width: 5, height: 6)
                Circle()
                    .fill(Color(red: 0.16, green: 0.13, blue: 0.12))
                    .frame(width: 5, height: 6)
            }
            .offset(y: -17)

            HStack(spacing: 30) {
                Ellipse()
                    .fill(Color(red: 0.85, green: 0.35, blue: 0.31).opacity(0.3))
                    .frame(width: 9, height: 5)
                Ellipse()
                    .fill(Color(red: 0.85, green: 0.35, blue: 0.31).opacity(0.3))
                    .frame(width: 9, height: 5)
            }
            .offset(y: -4)

            Path { path in
                path.move(to: CGPoint(x: -8, y: 5))
                path.addQuadCurve(
                    to: CGPoint(x: 8, y: 5),
                    control: CGPoint(x: 0, y: 12)
                )
            }
            .stroke(hairColor, style: StrokeStyle(lineWidth: 2, lineCap: .round))
            .frame(width: 20, height: 14)
            .offset(y: 5)

            hairstyle
        }
        .offset(y: -15)
    }

    private var clothing: some View {
        ZStack {
            clothingPath
                .fill(outfitColor)

            clothingDetails
        }
        .frame(width: 100, height: 72)
        .offset(y: 48)
    }

    private var clothingPath: Path {
        Path { path in
            switch appearance.outfit {
            case .dress:
                path.move(to: CGPoint(x: 26, y: 14))
                path.addLine(to: CGPoint(x: 42, y: 14))
                path.addLine(to: CGPoint(x: 50, y: 23))
                path.addLine(to: CGPoint(x: 58, y: 14))
                path.addLine(to: CGPoint(x: 74, y: 14))
                path.addLine(to: CGPoint(x: 94, y: 72))
                path.addLine(to: CGPoint(x: 6, y: 72))
                path.closeSubpath()
            case .tee, .hoodie, .superhero, .spaceSuit, .raincoat, .wizard:
                path.move(to: CGPoint(x: 18, y: 72))
                path.addLine(to: CGPoint(x: 14, y: 30))
                path.addQuadCurve(
                    to: CGPoint(x: 35, y: 14),
                    control: CGPoint(x: 17, y: 14)
                )
                path.addLine(to: CGPoint(x: 43, y: 14))
                path.addLine(to: CGPoint(x: 50, y: 23))
                path.addLine(to: CGPoint(x: 57, y: 14))
                path.addLine(to: CGPoint(x: 65, y: 14))
                path.addQuadCurve(
                    to: CGPoint(x: 86, y: 30),
                    control: CGPoint(x: 83, y: 14)
                )
                path.addLine(to: CGPoint(x: 82, y: 72))
                path.closeSubpath()
            }
        }
    }

    @ViewBuilder
    private var clothingDetails: some View {
        switch appearance.outfit {
        case .tee:
            Path { path in
                path.move(to: CGPoint(x: 42, y: 15))
                path.addLine(to: CGPoint(x: 50, y: 25))
                path.addLine(to: CGPoint(x: 58, y: 15))
            }
            .stroke(.white.opacity(0.8), style: StrokeStyle(lineWidth: 3, lineCap: .round))
        case .hoodie:
            RoundedRectangle(cornerRadius: 5)
                .fill(outfitColor.opacity(0.7))
                .frame(width: 34, height: 16)
                .offset(y: 22)
            Path { path in
                path.move(to: CGPoint(x: 45, y: 20))
                path.addLine(to: CGPoint(x: 43, y: 39))
                path.move(to: CGPoint(x: 55, y: 20))
                path.addLine(to: CGPoint(x: 57, y: 39))
            }
            .stroke(.white.opacity(0.85), style: StrokeStyle(lineWidth: 2, lineCap: .round))
        case .dress:
            Capsule()
                .fill(Color(red: 1.00, green: 0.82, blue: 0.54))
                .frame(width: 37, height: 5)
                .offset(y: 16)
        case .superhero:
            Image(systemName: "bolt.fill")
                .font(.system(size: 25, weight: .black))
                .foregroundStyle(Color(red: 1.00, green: 0.82, blue: 0.24))
                .offset(y: -3)
        case .spaceSuit:
            Image(systemName: "sparkles")
                .font(.system(size: 23, weight: .black))
                .foregroundStyle(.white)
                .offset(y: -3)
        case .raincoat:
            VStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { _ in
                    Circle()
                        .fill(Color(red: 0.98, green: 0.80, blue: 0.24))
                        .frame(width: 5, height: 5)
                }
            }
            .offset(y: 8)
        case .wizard:
            Image(systemName: "star.fill")
                .font(.system(size: 22, weight: .black))
                .foregroundStyle(Color(red: 1.00, green: 0.82, blue: 0.24))
                .offset(y: -3)
        }
    }

    @ViewBuilder
    private var hairstyle: some View {
        switch appearance.hairstyle {
        case .curls:
            HStack(spacing: -4) {
                ForEach(0..<5, id: \.self) { _ in
                    Circle()
                        .fill(hairColor)
                        .frame(width: 20, height: 20)
                }
            }
            .offset(y: -50)
        case .bow:
            ZStack {
                Ellipse()
                    .fill(Color(red: 0.86, green: 0.29, blue: 0.42))
                    .frame(width: 19, height: 13)
                    .rotationEffect(.degrees(-28))
                    .offset(x: -8)
                Ellipse()
                    .fill(Color(red: 0.86, green: 0.29, blue: 0.42))
                    .frame(width: 19, height: 13)
                    .rotationEffect(.degrees(28))
                    .offset(x: 8)
                Circle()
                    .fill(Color(red: 0.98, green: 0.67, blue: 0.34))
                    .frame(width: 7, height: 7)
            }
            .offset(x: 28, y: -47)
        case .cap:
            ZStack {
                Ellipse()
                    .fill(Color(red: 0.24, green: 0.49, blue: 0.66))
                    .frame(width: 66, height: 35)
                    .offset(y: -56)
                Capsule()
                    .fill(Color(red: 0.18, green: 0.39, blue: 0.55))
                    .frame(width: 76, height: 10)
                    .offset(y: -40)
            }
        case .flower:
            ZStack {
                ForEach(0..<5, id: \.self) { petal in
                    Circle()
                        .fill(Color(red: 0.98, green: 0.57, blue: 0.60))
                        .frame(width: 10, height: 10)
                        .offset(
                            x: petal == 0 ? 0 : (petal < 3 ? 8 : -8),
                            y: petal == 0 ? -8 : (petal == 1 || petal == 4 ? 4 : -1)
                        )
                }
                Circle()
                    .fill(Color(red: 1.00, green: 0.82, blue: 0.30))
                    .frame(width: 7, height: 7)
            }
            .offset(x: 29, y: -45)
        case .ponytail:
            ZStack {
                Circle()
                    .fill(hairColor)
                    .frame(width: 28, height: 28)
                    .offset(x: 32, y: -42)
                HStack(spacing: -5) {
                    ForEach(0..<4, id: \.self) { _ in
                        Circle()
                            .fill(hairColor)
                            .frame(width: 20, height: 20)
                    }
                }
                .offset(y: -51)
            }
        case .spiky:
            HStack(spacing: -5) {
                ForEach(0..<5, id: \.self) { index in
                    Image(systemName: "triangle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 24)
                        .rotationEffect(.degrees(Double(index - 2) * 12))
                }
            }
            .foregroundStyle(hairColor)
            .offset(y: -53)
        case .braids:
            HStack(spacing: 22) {
                ForEach(0..<2, id: \.self) { _ in
                    VStack(spacing: -6) {
                        ForEach(0..<4, id: \.self) { _ in
                            Capsule()
                                .fill(hairColor)
                                .frame(width: 13, height: 17)
                        }
                    }
                }
            }
            .offset(y: -22)
        }
    }

    private var outfitColor: Color {
        switch appearance.outfit {
        case .tee: Color(red: 0.24, green: 0.62, blue: 0.50)
        case .hoodie: Color(red: 0.92, green: 0.48, blue: 0.27)
        case .dress: Color(red: 0.62, green: 0.43, blue: 0.70)
        case .superhero: Color(red: 0.29, green: 0.43, blue: 0.70)
        case .spaceSuit: Color(red: 0.29, green: 0.49, blue: 0.70)
        case .raincoat: Color(red: 0.92, green: 0.70, blue: 0.18)
        case .wizard: Color(red: 0.38, green: 0.30, blue: 0.63)
        }
    }
}
