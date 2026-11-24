import Foundation
import SwiftUI

struct ShopView: View {
    private static let spinCost = 5

    let level: Int
    @Binding var coins: Int
    @Binding var unlockedItems: Set<String>

    @State private var wheelRotation = 0.0
    @State private var isSpinning = false
    @State private var wheelMessage: String?

    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 12)]

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
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Shop")
                                .font(.system(size: 30, weight: .heavy, design: .rounded))
                                .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                                .accessibilityAddTraits(.isHeader)

                            Text("Unlock new styles and try your luck!")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundStyle(Color(red: 0.33, green: 0.42, blue: 0.44))
                        }

                        Spacer(minLength: 8)
                        CoinBalanceView(coins: coins)
                    }

                    wheelCard

                    Text("Avatar items")
                        .font(.system(size: 24, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                        .accessibilityAddTraits(.isHeader)

                    ForEach(AvatarShopCategory.allCases) { category in
                        let items = AvatarShopItem.allItems.filter { $0.category == category }

                        if !items.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(category.rawValue)
                                    .font(.system(size: 19, weight: .heavy, design: .rounded))
                                    .foregroundStyle(Color(red: 0.20, green: 0.39, blue: 0.37))

                                LazyVGrid(columns: columns, spacing: 12) {
                                    ForEach(items) { item in
                                        shopItemCard(item)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(20)
                .frame(maxWidth: 700)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Shop")
    }

    private var wheelCard: some View {
        VStack(spacing: 14) {
            Text("Fortunate Wheel")
                .font(.system(size: 24, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                .accessibilityAddTraits(.isHeader)

            Text("Spin for a prize!")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Color(red: 0.33, green: 0.42, blue: 0.44))

            wheel
                .frame(width: 290, height: 290)
                .frame(maxWidth: .infinity)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Six-part Fortunate Wheel")
                .accessibilityValue("Prizes: 2 coins, Wizard, Nothing, Braids, 10 coins, and Umber. Each spin costs 5 coins.")

            Text("Win 2 coins, 10 coins, Wizard, Braids, Umber, or Nothing!")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Color(red: 0.33, green: 0.42, blue: 0.44))
                .multilineTextAlignment(.center)

            Button(action: spinWheel) {
                Label(
                    isSpinning ? "Spinning…" : "Spin · \(Self.spinCost) Coins",
                    systemImage: "sparkles"
                )
                    .font(.system(size: 17, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(red: 0.49, green: 0.39, blue: 0.56), in: Capsule())
            }
            .buttonStyle(.plain)
            .disabled(isSpinning || coins < Self.spinCost)

            if let wheelMessage {
                Text(wheelMessage)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.20, green: 0.48, blue: 0.45))
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.updatesFrequently)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 26))
    }

    private var wheel: some View {
        ZStack {
            ZStack {
                ForEach(FortuneWheelPrize.allCases, id: \.self) { prize in
                    wheelSlice(prize)
                }

                wheelSeparators

                ForEach(FortuneWheelPrize.allCases, id: \.self) { prize in
                    wheelLabel(prize)
                }
            }
            .frame(width: 270, height: 270)
            .rotationEffect(.degrees(wheelRotation))

            Circle()
                .fill(.white)
                .frame(width: 48, height: 48)
                .overlay {
                    Image(systemName: "sparkles")
                        .font(.system(size: 21, weight: .heavy))
                        .foregroundStyle(Color(red: 0.49, green: 0.39, blue: 0.56))
                }
                .accessibilityHidden(true)

            Image(systemName: "triangle.fill")
                .font(.system(size: 24, weight: .black))
                .rotationEffect(.degrees(180))
                .foregroundStyle(Color(red: 0.88, green: 0.62, blue: 0.10))
                .offset(y: -132)
                .accessibilityHidden(true)
        }
    }

    private func wheelSlice(_ prize: FortuneWheelPrize) -> some View {
        let start = startFraction(for: prize)
        let end = start + Double(prize.percentage) / 100
        let slice = FortuneWheelSlice(startFraction: start, endFraction: end)

        return slice.fill(wheelColor(for: prize))
    }

    private func wheelLabel(_ prize: FortuneWheelPrize) -> some View {
        let start = startFraction(for: prize)
        let end = start + Double(prize.percentage) / 100
        let middleAngle = (start + end) * Double.pi - Double.pi / 2
        let sectorAngle = Double(prize.percentage) * 2 * Double.pi / 100
        let center = 135.0
        let labelRadius = 4 * center * sin(sectorAngle / 2) / (3 * sectorAngle)

        return Text(prize.wheelLabel)
            .font(.system(size: 11, weight: .heavy, design: .rounded))
            .multilineTextAlignment(.center)
            .foregroundStyle(wheelLabelColor(for: prize))
            .frame(width: 66)
            .minimumScaleFactor(0.8)
            .shadow(color: .black.opacity(0.55), radius: 2)
            .position(
                x: CGFloat(center + cos(middleAngle) * labelRadius),
                y: CGFloat(center + sin(middleAngle) * labelRadius)
            )
            .accessibilityHidden(true)
    }

    private var wheelSeparators: some View {
        GeometryReader { geometry in
            let path = separatorPath(in: CGRect(origin: .zero, size: geometry.size))

            path
                .stroke(.black.opacity(0.35), style: StrokeStyle(lineWidth: 6, lineCap: .round))

            path
                .stroke(.white, style: StrokeStyle(lineWidth: 3, lineCap: .round))

            Circle()
                .stroke(.white, lineWidth: 3)
        }
        .accessibilityHidden(true)
    }

    private func separatorPath(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        var precedingWeight = 0

        return Path { path in
            for prize in FortuneWheelPrize.allCases {
                let angle = Double(precedingWeight) / 100 * 2 * Double.pi - Double.pi / 2
                path.move(to: center)
                path.addLine(
                    to: CGPoint(
                        x: center.x + CGFloat(cos(angle)) * radius,
                        y: center.y + CGFloat(sin(angle)) * radius
                    )
                )
                precedingWeight += prize.percentage
            }
        }
    }

    private func startFraction(for prize: FortuneWheelPrize) -> Double {
        var precedingWeight = 0
        for candidate in FortuneWheelPrize.allCases {
            if candidate == prize { break }
            precedingWeight += candidate.percentage
        }
        return Double(precedingWeight) / 100
    }

    private func wheelColor(for prize: FortuneWheelPrize) -> Color {
        switch prize {
        case .twoCoins: Color(red: 0.96, green: 0.78, blue: 0.12)
        case .wizard: Color(red: 0.16, green: 0.62, blue: 0.34)
        case .nothing: Color(red: 0.86, green: 0.20, blue: 0.22)
        case .braids: Color(red: 0.16, green: 0.43, blue: 0.84)
        case .tenCoins: Color(red: 0.91, green: 0.29, blue: 0.57)
        case .umber: Color(red: 0.53, green: 0.27, blue: 0.76)
        }
    }

    private func wheelLabelColor(for prize: FortuneWheelPrize) -> Color {
        switch prize {
        case .twoCoins: Color(red: 0.18, green: 0.17, blue: 0.12)
        case .wizard, .nothing, .braids, .tenCoins, .umber: .white
        }
    }

    private func shopItemCard(_ item: AvatarShopItem) -> some View {
        let isUnlocked = item.isUnlocked(level: level, unlockedItems: unlockedItems)

        return VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 9) {
                Text(item.symbol)
                    .font(.system(size: 27))
                    .accessibilityHidden(true)

                Text(item.name)
                    .font(.system(size: 15, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            if isUnlocked {
                Label("Unlocked", systemImage: "checkmark.circle.fill")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.20, green: 0.48, blue: 0.45))
            } else {
                switch item.unlockRequirement {
                case .level(let requiredLevel):
                    Label("Unlock at level \(requiredLevel)", systemImage: "lock.fill")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(.secondary)
                case .coins(let cost):
                    Button {
                        purchase(item, cost: cost)
                    } label: {
                        Label("Buy for \(cost) coins", systemImage: "dollarsign.circle.fill")
                            .font(.system(size: 12, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 9)
                            .background(
                                Color(red: 0.67, green: 0.48, blue: 0.15),
                                in: Capsule()
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(coins < cost)
                    .opacity(coins < cost ? 0.55 : 1)
                case .fortunateWheel:
                    Label("Fortunate Wheel only", systemImage: "sparkles")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.49, green: 0.39, blue: 0.56))
                case nil:
                    EmptyView()
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 92, alignment: .leading)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(
                    isUnlocked
                        ? Color(red: 0.20, green: 0.48, blue: 0.45).opacity(0.35)
                        : Color.gray.opacity(0.12),
                    lineWidth: 1
                )
        }
    }

    private func purchase(_ item: AvatarShopItem, cost: Int) {
        guard coins >= cost, !item.isUnlocked(level: level, unlockedItems: unlockedItems) else {
            return
        }

        coins -= cost
        unlockedItems.insert(item.id)
    }

    private func spinWheel() {
        guard !isSpinning, coins >= Self.spinCost else { return }

        coins -= Self.spinCost
        let prize = FortuneWheelPrize.random()
        let prizeItem: AvatarShopItem?
        switch prize {
        case .wizard:
            prizeItem = .outfit(.wizard)
        case .braids:
            prizeItem = .hairstyle(.braids)
        case .umber:
            prizeItem = .skin(.umber)
        case .twoCoins, .nothing, .tenCoins:
            prizeItem = nil
        }

        let middleDegrees = (startFraction(for: prize) + Double(prize.percentage) / 200) * 360
        let currentRotation = wheelRotation.truncatingRemainder(dividingBy: 360)
        let alignmentRotation = (
            360 - middleDegrees - currentRotation
        )
        .truncatingRemainder(dividingBy: 360)
        let normalizedAlignment = (alignmentRotation + 360).truncatingRemainder(dividingBy: 360)

        wheelMessage = nil
        isSpinning = true
        withAnimation(.easeOut(duration: 2.8), completionCriteria: .logicallyComplete) {
            wheelRotation += 360 * 5 + normalizedAlignment
        } completion: {
            award(prize, item: prizeItem)
            isSpinning = false
        }
    }

    private func award(_ prize: FortuneWheelPrize, item: AvatarShopItem?) {
        switch prize {
        case .nothing:
            wheelMessage = "No prize this time. Give it another spin!"
        case .wizard, .braids, .umber:
            guard let item else {
                wheelMessage = "No item was available. Please spin again."
                return
            }
            if unlockedItems.insert(item.id).inserted {
                wheelMessage = "You unlocked \(item.name)!"
            } else {
                wheelMessage = "You already own \(item.name)."
            }
        case .twoCoins:
            coins += 2
            wheelMessage = "You won 2 coins!"
        case .tenCoins:
            coins += 10
            wheelMessage = "You won 10 coins!"
        }
    }
}

#Preview {
    NavigationStack {
        ShopView(level: 1, coins: .constant(6), unlockedItems: .constant([]))
    }
}
