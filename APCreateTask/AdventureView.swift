import SwiftUI

struct AdventureView: View {
    @Environment(\.dismiss) private var dismiss

    private static let questionsPerRun = 8

    let appearance: AvatarAppearance
    @Binding var history: [GameRun]

    @State private var questionIndex = 0
    @State private var selectedAnswer: Int?
    @State private var score = 0
    @State private var correctCount = 0
    @State private var streak = 0
    @State private var lastPointsEarned = 0
    @State private var hasFinished = false
    @State private var questions = Self.makeQuestionSet()
    @State private var answerResults: [GameQuestionResult] = []

    private var currentQuestion: MathQuestion {
        questions[questionIndex]
    }

    private static func makeQuestionSet() -> [MathQuestion] {
        Array(MathQuestionBank.questions.shuffled().prefix(questionsPerRun))
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

            ZStack(alignment: .bottomLeading) {
                ScrollView {
                    VStack(spacing: 20) {
                        gameHeader

                        if hasFinished {
                            if correctCount == questions.count {
                                victoryCard
                            } else {
                                resultsCard
                            }
                        } else {
                            questionCard
                            answerChoices

                            if let selectedAnswer {
                                answerFeedback(for: selectedAnswer)
                                continueButton
                            }
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 180)
                    .frame(maxWidth: 560)
                    .frame(maxWidth: .infinity)
                }

                runFooter
            }
        }
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }

    private var gameHeader: some View {
        VStack(spacing: 14) {
            HStack {
                Label("MATH QUEST", systemImage: "sparkles")
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .tracking(1)
                    .foregroundStyle(Color(red: 0.20, green: 0.48, blue: 0.45))

                Spacer()

                HStack(spacing: 8) {
                    Label("\(streak)", systemImage: "flame.fill")
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(red: 0.70, green: 0.35, blue: 0.12))
                        .accessibilityLabel("Streak: \(streak)")

                    Label("\(score)", systemImage: "star.fill")
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(red: 0.55, green: 0.40, blue: 0.09))
                        .accessibilityLabel("Score: \(score) points")
                }
                .padding(.horizontal, 13)
                .padding(.vertical, 9)
                .background(.white.opacity(0.9), in: Capsule())
            }

            if !hasFinished {
                VStack(spacing: 7) {
                    ProgressView(value: Double(questionIndex + 1), total: Double(questions.count))
                        .tint(Color(red: 0.20, green: 0.58, blue: 0.49))
                    Text("Question \(questionIndex + 1) of \(questions.count)")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .accessibilityElement(children: .combine)
            }
        }
    }

    private var runFooter: some View {
        HStack(alignment: .bottom, spacing: 12) {
            AvatarPreview(appearance: appearance)
                .frame(width: 140, height: 145)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Your avatar")

            VStack(alignment: .leading, spacing: 6) {
                Text("SCORE")
                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                    .foregroundStyle(.secondary)

                Label("\(score) points", systemImage: "star.fill")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.55, green: 0.40, blue: 0.09))

                Label("\(streak) streak", systemImage: "flame.fill")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.70, green: 0.35, blue: 0.12))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.white.opacity(0.96), in: RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(.white, lineWidth: 2)
            }
            .padding(.bottom, 12)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Score \(score) points. Streak \(streak).")
        }
        .frame(maxWidth: 560, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
        .allowsHitTesting(false)
    }

    private var questionCard: some View {
        VStack(spacing: 16) {
            Text("READY, \(appearance.outfit.name.uppercased()) EXPLORER?")
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .tracking(1)
                .foregroundStyle(Color(red: 0.31, green: 0.48, blue: 0.44))

            Text(currentQuestion.prompt)
                .font(.system(size: 28, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)

            Text("Choose the right answer!")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Color(red: 0.33, green: 0.42, blue: 0.44))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 26)
        .padding(.horizontal, 18)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 28))
        .shadow(color: Color(red: 0.33, green: 0.43, blue: 0.37).opacity(0.08), radius: 12, y: 6)
    }

    private var answerChoices: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(currentQuestion.options, id: \.self) { answer in
                Button {
                    submitAnswer(answer)
                } label: {
                    HStack(spacing: 8) {
                        Text("\(answer)")
                            .font(.system(size: 24, weight: .heavy, design: .rounded))
                        if selectedAnswer == answer {
                            Image(systemName: answer == currentQuestion.correctAnswer ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .font(.system(size: 18, weight: .bold))
                        }
                    }
                    .foregroundStyle(answerTextColor(for: answer))
                    .frame(maxWidth: .infinity)
                    .frame(height: 66)
                    .background(answerBackground(for: answer), in: RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(answerBorder(for: answer), lineWidth: 2)
                    }
                }
                .buttonStyle(.plain)
                .disabled(selectedAnswer != nil)
                .accessibilityLabel("Answer \(answer)")
                .accessibilityValue(answerAccessibilityValue(for: answer))
            }
        }
    }

    private func answerFeedback(for answer: Int) -> some View {
        let isCorrect = answer == currentQuestion.correctAnswer

        return VStack(alignment: .leading, spacing: 7) {
            Label(
                isCorrect
                    ? "That’s right! +\(lastPointsEarned) points"
                    : "Good try! Keep going!",
                systemImage: isCorrect ? "star.fill" : "heart.fill"
            )
            .font(.system(size: 17, weight: .heavy, design: .rounded))
            .foregroundStyle(isCorrect
                             ? Color(red: 0.16, green: 0.45, blue: 0.32)
                             : Color(red: 0.57, green: 0.34, blue: 0.17))

            Text(currentQuestion.explanation)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Color(red: 0.27, green: 0.35, blue: 0.34))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(isCorrect
                    ? Color(red: 0.87, green: 0.96, blue: 0.89)
                    : Color(red: 1.00, green: 0.94, blue: 0.83),
                    in: RoundedRectangle(cornerRadius: 20))
        .accessibilityElement(children: .combine)
    }

    private var continueButton: some View {
        Button(action: moveToNextQuestion) {
            HStack(spacing: 10) {
                Text(questionIndex == questions.count - 1 ? "See my score!" : "Next question")
                Image(systemName: "arrow.right")
            }
            .font(.system(size: 18, weight: .heavy, design: .rounded))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(Color(red: 0.20, green: 0.48, blue: 0.45), in: Capsule())
        }
        .buttonStyle(.plain)
    }

    private var victoryCard: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 1.00, green: 0.77, blue: 0.29),
                                Color(red: 0.95, green: 0.52, blue: 0.20)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Image(systemName: "trophy.fill")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(.white)

                Image(systemName: "sparkles")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color(red: 0.97, green: 0.63, blue: 0.17))
                    .offset(x: 42, y: -34)
            }
            .frame(width: 96, height: 96)
            .accessibilityHidden(true)

            AvatarPreview(appearance: appearance)
                .frame(height: 145)
                .accessibilityHidden(true)

            Text("You did it!")
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                .accessibilityAddTraits(.isHeader)

            Text("Perfect score!")
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.20, green: 0.48, blue: 0.45))

            Text("You answered all \(questions.count) questions correctly!")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(red: 0.33, green: 0.42, blue: 0.44))

            Text("\(score) points")
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.55, green: 0.40, blue: 0.09))

            resultActions
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.96), in: RoundedRectangle(cornerRadius: 30))
        .overlay {
            RoundedRectangle(cornerRadius: 30)
                .strokeBorder(Color(red: 1.00, green: 0.79, blue: 0.38).opacity(0.7), lineWidth: 3)
        }
        .shadow(color: Color(red: 0.75, green: 0.49, blue: 0.12).opacity(0.16), radius: 16, y: 8)
    }

    private var resultsCard: some View {
        VStack(spacing: 18) {
            AvatarPreview(appearance: appearance)
                .frame(height: 165)
                .accessibilityHidden(true)

            Text(resultTitle)
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                .accessibilityAddTraits(.isHeader)

            Text("You got \(correctCount) out of \(questions.count) questions right!")
                .font(.system(size: 19, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(red: 0.33, green: 0.42, blue: 0.44))

            Text("\(score) points")
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.55, green: 0.40, blue: 0.09))

            resultActions
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 30))
        .shadow(color: Color(red: 0.33, green: 0.43, blue: 0.37).opacity(0.08), radius: 12, y: 6)
    }

    private var resultActions: some View {
        VStack(spacing: 8) {
            Button(action: restartGame) {
                Label("Play again", systemImage: "arrow.clockwise")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(red: 0.20, green: 0.48, blue: 0.45), in: Capsule())
            }
            .buttonStyle(.plain)

            Button("Back to menu") {
                dismiss()
            }
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundStyle(Color(red: 0.20, green: 0.48, blue: 0.45))
            .padding(.top, 2)
        }
    }

    private var resultTitle: String {
        switch correctCount {
        case questions.count: "Perfect score!"
        case (questions.count / 2)...: "Amazing work!"
        default: "Keep practicing!"
        }
    }

    private func submitAnswer(_ answer: Int) {
        guard selectedAnswer == nil else { return }

        selectedAnswer = answer
        if answer == currentQuestion.correctAnswer {
            streak += 1
            lastPointsEarned = streak > 3 ? 5 + (streak - 3) : 5
            score += lastPointsEarned
            correctCount += 1
        } else {
            streak = 0
            lastPointsEarned = 0
        }
        answerResults.append(
            GameQuestionResult(question: currentQuestion, selectedAnswer: answer)
        )
    }

    private func moveToNextQuestion() {
        guard selectedAnswer != nil else { return }

        if questionIndex == questions.count - 1 {
            history.append(GameRun(answers: answerResults))
            hasFinished = true
        } else {
            questionIndex += 1
            selectedAnswer = nil
        }
    }

    private func restartGame() {
        questions = Self.makeQuestionSet()
        questionIndex = 0
        selectedAnswer = nil
        score = 0
        correctCount = 0
        streak = 0
        lastPointsEarned = 0
        hasFinished = false
        answerResults = []
    }

    private func answerBackground(for answer: Int) -> Color {
        guard let selectedAnswer else {
            return .white.opacity(0.94)
        }
        if answer == currentQuestion.correctAnswer {
            return Color(red: 0.86, green: 0.96, blue: 0.88)
        }
        if answer == selectedAnswer {
            return Color(red: 1.00, green: 0.91, blue: 0.86)
        }
        return .white.opacity(0.72)
    }

    private func answerBorder(for answer: Int) -> Color {
        guard let selectedAnswer else {
            return Color(red: 0.82, green: 0.88, blue: 0.83)
        }
        if answer == currentQuestion.correctAnswer {
            return Color(red: 0.29, green: 0.66, blue: 0.43)
        }
        if answer == selectedAnswer {
            return Color(red: 0.82, green: 0.43, blue: 0.31)
        }
        return .clear
    }

    private func answerTextColor(for answer: Int) -> Color {
        guard let selectedAnswer else {
            return Color(red: 0.15, green: 0.26, blue: 0.30)
        }
        if answer == currentQuestion.correctAnswer {
            return Color(red: 0.16, green: 0.45, blue: 0.32)
        }
        if answer == selectedAnswer {
            return Color(red: 0.62, green: 0.30, blue: 0.22)
        }
        return .secondary
    }

    private func answerAccessibilityValue(for answer: Int) -> String {
        guard let selectedAnswer else { return "" }
        if answer == currentQuestion.correctAnswer { return "Correct answer" }
        if answer == selectedAnswer { return "Your answer, incorrect" }
        return ""
    }
}

#Preview {
    NavigationStack {
        AdventureView(appearance: AvatarAppearance(), history: .constant([]))
    }
}
