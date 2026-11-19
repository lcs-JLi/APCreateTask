import SwiftUI

struct SubjectSelectionView: View {
    @State private var showsEnglishLockMessage = false

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

                Button {
                    showsEnglishLockMessage = true
                } label: {
                    subjectButton(
                        "English",
                        systemImage: "lock.fill",
                        color: Color(red: 0.44, green: 0.49, blue: 0.55)
                    )
                }
                .buttonStyle(.plain)
                .accessibilityHint("Available after level 10")
            }
            .padding(24)
            .frame(maxWidth: 480)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .alert("English is locked", isPresented: $showsEnglishLockMessage) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Available after Lv. 10")
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
