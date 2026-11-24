import SwiftUI

struct FortuneWheelSlice: Shape {
    let startFraction: Double
    let endFraction: Double

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let startAngle = startFraction * 2 * Double.pi - Double.pi / 2
        let endAngle = endFraction * 2 * Double.pi - Double.pi / 2
        let stepCount = max(1, Int(((endFraction - startFraction) * 360).rounded(.up)))

        var path = Path()
        path.move(to: center)
        for step in 0...stepCount {
            let progress = Double(step) / Double(stepCount)
            let angle = startAngle + (endAngle - startAngle) * progress
            path.addLine(
                to: CGPoint(
                    x: center.x + CGFloat(cos(angle)) * radius,
                    y: center.y + CGFloat(sin(angle)) * radius
                )
            )
        }
        path.closeSubpath()
        return path
    }
}
