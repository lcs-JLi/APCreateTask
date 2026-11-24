import SwiftUI

struct SubjectSelectionView: View {
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
                Text("Choose a subject")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                    .accessibilityAddTraits(.isHeader)
                    .padding(.bottom, 8)

                NavigationLink(value: AppRoute.adventure) {
                    subjectButton(
                        "Math",
                        systemImage: "plus.forwardslash.minus",
                        color: Color(red: 0.20, green: 0.48, blue: 0.45)
                    )
                }
                .buttonStyle(.plain)

                NavigationLink(value: AppRoute.wordPuzzle) {
                    subjectButton(
                        "English",
                        systemImage: "textformat.abc",
                        color: Color(red: 0.49, green: 0.39, blue: 0.56)
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(24)
            .frame(maxWidth: 480)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func subjectButton(
        _ title: String,
        systemImage: String,
        color: Color
    ) -> some View {
        Label(title, systemImage: systemImage)
            .font(.system(size: 20, weight: .heavy, design: .rounded))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(color, in: RoundedRectangle(cornerRadius: 20))
    }
}
