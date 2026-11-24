import SwiftUI

struct CoinBalanceView: View {
    let coins: Int

    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: "dollarsign.circle.fill")
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(Color(red: 0.88, green: 0.62, blue: 0.10))

            Text(coins.formatted())
                .font(.system(size: 16, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.38, green: 0.30, blue: 0.13))
                .monospacedDigit()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(.white.opacity(0.94), in: Capsule())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Coins")
        .accessibilityValue(coins.formatted())
    }
}
