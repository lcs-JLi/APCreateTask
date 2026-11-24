//
//  AdventureView.swift
//  APCreateTask
//
//  Created by John Li on 2026-11-20.
//  This code was generated using GitHub Copilot:
//  Main functions: makeQuestionSet, submitAnswer, moveToNextQuestion, chooseEventChoice,
//  awardExperience, restartGame, and answer-feedback/accessibility helpers.
//  Copilot change in this session: renamed the overtime outcome to draw.
//

import SwiftUI

struct AdventureView: View {
    private static let questionsPerRun = 10
    private static let questionsPerEventInterval = 4
    private static let events: [AdventureEvent] = [
        AdventureEvent(
            id: "mystery-chest",
            name: "A mystery chest",
            prompt: "You found a mystery chest along your way.",
            choices: [
                .init(title: "Open the chest", detail: "Gain 15 points", effect: .addPoints(15)),
                .init(title: "Leave it alone", detail: "Nothing happens", effect: .none)
            ]
        ),
        AdventureEvent(
            id: "ancient-textbook",
            name: "An ancient textbook",
            prompt: "You found an ancient textbook under a pile of leaves.",
            choices: [
                .init(title: "Read", detail: "Add 3 extra questions to the run", effect: .addQuestions(3)),
                .init(title: "Leave it alone", detail: "Nothing happens", effect: .none)
            ]
        )
    ]

    let appearance: AvatarAppearance
    @Binding var history: [GameRun]
    @Binding var navigationPath: [AppRoute]
    @Binding var level: Int
    @Binding var experience: Double
    @Binding var coins: Int
    @Binding var coinExperienceProgress: Double

    @State private var questionIndex = 0
    @State private var selectedAnswer: Int?
    @State private var score = 0
    @State private var botScore = 0
    @State private var correctCount = 0
    @State private var streak = 0
    @State private var lastPointsEarned = 0
    @State private var lastStreakBonus = 0
    @State private var notebookProtectionUsed = false
    @State private var notebookSavedStreak = false
    @State private var activeEvent: AdventureEvent?
    @State private var eventResult: String?
    @State private var usedEventIDs: Set<String> = []
    @State private var botAnswer: Int?
    @State private var botAppearance = AvatarAppearance.random
    @State private var hasFinished = false
    @State private var experienceEarnedThisRun = 0.0
    @State private var coinsEarnedThisRun = 0
    @State private var experienceAwarded = false
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

            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 20) {
                        gameHeader

                        if let activeEvent {
                            eventCard(activeEvent)
                        } else if hasFinished {
                            outcomeCard
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

                    Label("\(botScore)", systemImage: "person.fill")
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(red: 0.30, green: 0.43, blue: 0.63))
                        .accessibilityLabel("Opponent score: \(botScore) points")
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
        HStack(alignment: .bottom, spacing: 0) {
            playerRunBadge
            Spacer(minLength: 8)
            botRunBadge
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
        .background {
            LinearGradient(
                colors: [.clear, Color(red: 0.95, green: 0.97, blue: 0.92).opacity(0.96)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .bottom)
        }
    }

    private var playerRunBadge: some View {
        runBadge(
            name: "YOU",
            username: appearance.displayUsername,
            avatar: appearance,
            score: score,
            detail: "\(streak) streak",
            detailSymbol: "flame.fill",
            detailColor: Color(red: 0.70, green: 0.35, blue: 0.12),
            answer: nil
        )
    }

    private var botRunBadge: some View {
        runBadge(
            name: "OPPONENT",
            avatar: botAppearance,
            score: botScore,
            detail: botAnswer.map { "Picked \($0)" } ?? "Ready",
            detailSymbol: botAnswer == currentQuestion.correctAnswer ? "checkmark.circle.fill" : "sparkles",
            detailColor: botAnswer == currentQuestion.correctAnswer
                ? Color(red: 0.16, green: 0.45, blue: 0.32)
                : Color(red: 0.30, green: 0.43, blue: 0.63),
            answer: botAnswer
        )
    }

    private func runBadge(
        name: String,
        username: String? = nil,
        avatar: AvatarAppearance,
        score: Int,
        detail: String,
        detailSymbol: String,
        detailColor: Color,
        answer: Int?
    ) -> some View {
        let displayName = name == "YOU" ? username ?? name : name

        return VStack(spacing: 1) {
            Text(displayName)
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            AvatarPreview(appearance: avatar)
                .frame(width: 152, height: 152)
                .scaleEffect(0.72)
                .frame(width: 110, height: 110)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(name == "YOU" ? "Your avatar" : "Opponent avatar")

            Label("\(score) pts", systemImage: "star.fill")
                .font(.system(size: 14, weight: .heavy, design: .rounded))
                .foregroundStyle(name == "YOU"
                                 ? Color(red: 0.55, green: 0.40, blue: 0.09)
                                 : Color(red: 0.30, green: 0.43, blue: 0.63))

            Label(detail, systemImage: detailSymbol)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(detailColor)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .frame(minWidth: 120)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(.white, lineWidth: 2)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            name == "YOU"
                ? "\(displayName), \(score) points, \(streak) correct answers in a row."
                : "Opponent, \(score) points, \(answer.map { "answered \($0)" } ?? "waiting to answer")."
        )
    }

    private func eventCard(_ event: AdventureEvent) -> some View {
        VStack(spacing: 18) {
            Image(systemName: "sparkles")
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(Color(red: 0.75, green: 0.49, blue: 0.12))
                .accessibilityHidden(true)

            Text(event.name)
                .font(.system(size: 28, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)

            Text(event.prompt)
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundStyle(Color(red: 0.33, green: 0.42, blue: 0.44))
                .multilineTextAlignment(.center)

            if let eventResult {
                Label(eventResult, systemImage: "checkmark.circle.fill")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.20, green: 0.48, blue: 0.45))
                    .multilineTextAlignment(.center)

                Button("Continue", action: continueAfterEvent)
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(red: 0.20, green: 0.48, blue: 0.45), in: Capsule())
                    .buttonStyle(.plain)
            } else {
                ForEach(event.choices) { choice in
                    Button {
                        chooseEventChoice(choice, for: event)
                    } label: {
                        VStack(spacing: 5) {
                            Text(choice.title)
                                .font(.system(size: 17, weight: .heavy, design: .rounded))
                            Text(choice.detail)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                        }
                        .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(.white, in: RoundedRectangle(cornerRadius: 18))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.95), in: RoundedRectangle(cornerRadius: 28))
        .shadow(color: Color(red: 0.33, green: 0.43, blue: 0.37).opacity(0.08), radius: 12, y: 6)
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

            if isCorrect {
                Label("Streak bonus: +\(lastStreakBonus) points", systemImage: "flame.fill")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.70, green: 0.35, blue: 0.12))
            }

            if isCorrect && appearance.equippedEquipment.contains(.pen) {
                Label("Regular pen bonus: +1 point!", systemImage: "pencil")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.20, green: 0.48, blue: 0.45))
            }

            if notebookSavedStreak {
                Label("Notebook saved your streak! It stays at \(streak).", systemImage: "book.fill")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.20, green: 0.48, blue: 0.45))
            }
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

    private var outcomeCard: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(outcome.accentColor.gradient)

                Image(systemName: outcome.symbol)
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 96, height: 96)
            .accessibilityHidden(true)

            AvatarPreview(appearance: appearance)
                .frame(height: 145)
                .accessibilityHidden(true)

            Text(outcome.title)
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(outcome.accentColor)
                .accessibilityAddTraits(.isHeader)

            Text(outcome.message(
                totalQuestions: questions.count,
                scoreDifference: score - botScore,
                userScore: score
            ))
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(red: 0.33, green: 0.42, blue: 0.44))

            Text("Correct answers: \(correctCount) of \(questions.count)")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(red: 0.33, green: 0.42, blue: 0.44))

            HStack(spacing: 24) {
                Label("You: \(score)", systemImage: "star.fill")
                    .foregroundStyle(Color(red: 0.55, green: 0.40, blue: 0.09))
                Label("Opponent: \(botScore)", systemImage: "person.fill")
                    .foregroundStyle(Color(red: 0.30, green: 0.43, blue: 0.63))
            }
            .font(.system(size: 16, weight: .heavy, design: .rounded))
            .multilineTextAlignment(.center)

            ExperienceProgressView(
                level: level,
                experience: experience,
                earnedThisRun: experienceEarnedThisRun
            )

            HStack(spacing: 12) {
                CoinBalanceView(coins: coins)
                Label(
                    "+\(coinsEarnedThisRun) \(coinsEarnedThisRun == 1 ? "coin" : "coins")",
                    systemImage: "dollarsign.circle.fill"
                )
                .font(.system(size: 16, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.67, green: 0.48, blue: 0.15))
            }

            resultActions
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.96), in: RoundedRectangle(cornerRadius: 30))
        .overlay {
            RoundedRectangle(cornerRadius: 30)
                .strokeBorder(outcome.accentColor.opacity(0.45), lineWidth: 3)
        }
        .shadow(color: outcome.accentColor.opacity(0.16), radius: 16, y: 8)
    }

    private var outcome: RunOutcome {
        let scoreDifference = score - botScore
        if scoreDifference == 0 {
            return .draw
        }
        if scoreDifference < 0 {
            return .defeat
        }
        if correctCount == questions.count {
            return .flawlessVictory
        }
        return scoreDifference <= 5 ? .clutch : .victory
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
                navigationPath = [.gameMenu]
            }
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundStyle(Color(red: 0.20, green: 0.48, blue: 0.45))
            .padding(.top, 2)
        }
    }

    private func submitAnswer(_ answer: Int) {
        guard selectedAnswer == nil else { return }

        selectedAnswer = answer
        notebookSavedStreak = false
        lastStreakBonus = 0
        if answer == currentQuestion.correctAnswer {
            streak += 1
            let streakBonus = max(0, streak - 3)
            let penBonus = appearance.equippedEquipment.contains(.pen) ? 1 : 0
            lastStreakBonus = streakBonus
            lastPointsEarned = 5 + streakBonus + penBonus
            score += lastPointsEarned
            correctCount += 1
        } else {
            lastPointsEarned = 0
            if streak > 0,
               appearance.equippedEquipment.contains(.notebook),
               !notebookProtectionUsed {
                notebookProtectionUsed = true
                notebookSavedStreak = true
            } else {
                streak = 0
            }
        }
        botAnswer = currentQuestion.options.randomElement()
        if let botAnswer, botAnswer == currentQuestion.correctAnswer {
            botScore += 5
        }
        answerResults.append(
            GameQuestionResult(question: currentQuestion, selectedAnswer: answer)
        )
    }

    private func moveToNextQuestion() {
        guard selectedAnswer != nil else { return }

        let questionsAnswered = questionIndex + 1
        if questionsAnswered.isMultiple(of: Self.questionsPerEventInterval) {
            let unusedEvents = Self.events.filter { !usedEventIDs.contains($0.id) }
            if let event = unusedEvents.randomElement() {
                activeEvent = event
                return
            }
        }

        advanceToNextQuestion()
    }

    private func chooseEventChoice(_ choice: AdventureEvent.Choice, for event: AdventureEvent) {
        guard activeEvent?.id == event.id, eventResult == nil else { return }

        switch choice.effect {
        case .addPoints(let points):
            score += points
            eventResult = "You gained \(points) points!"
        case .addQuestions(let count):
            let usedQuestionIDs = Set(questions.map(\.id))
            let additionalQuestions = MathQuestionBank.questions
                .filter { !usedQuestionIDs.contains($0.id) }
                .shuffled()
                .prefix(count)
            let questionsToAdd = Array(additionalQuestions)
            questions.append(contentsOf: questionsToAdd)
            eventResult = questionsToAdd.count == count
                ? "Added \(count) extra questions to your run."
                : "Added \(questionsToAdd.count) extra questions to your run."
        case .none:
            eventResult = "You left it alone. Nothing happens."
        }
    }

    private func continueAfterEvent() {
        guard let event = activeEvent, eventResult != nil else { return }

        usedEventIDs.insert(event.id)
        activeEvent = nil
        eventResult = nil
        advanceToNextQuestion()
    }

    private func advanceToNextQuestion() {
        if questionIndex == questions.count - 1 {
            history.append(GameRun(answers: answerResults, score: score))
            awardExperience()
            hasFinished = true
        } else {
            questionIndex += 1
            selectedAnswer = nil
            notebookSavedStreak = false
            botAnswer = nil
        }
    }

    private func awardExperience() {
        guard !experienceAwarded else { return }
        experienceAwarded = true

        let flawlessBonus = outcome == .flawlessVictory ? 50.0 : 0
        let baseExperience = Double(score) * 0.5 + flawlessBonus
        experienceEarnedThisRun = PlayerRewards.experienceWithBackpackBonus(
            baseExperience,
            backpackEquipped: appearance.equippedEquipment.contains(.backpack)
        )

        coinsEarnedThisRun = PlayerRewards.awardExperience(
            experienceEarnedThisRun,
            level: &level,
            experience: &experience,
            coins: &coins,
            coinExperienceProgress: &coinExperienceProgress
        )
    }

    private func restartGame() {
        questions = Self.makeQuestionSet()
        questionIndex = 0
        selectedAnswer = nil
        score = 0
        botScore = 0
        correctCount = 0
        streak = 0
        lastPointsEarned = 0
        lastStreakBonus = 0
        notebookProtectionUsed = false
        notebookSavedStreak = false
        activeEvent = nil
        eventResult = nil
        usedEventIDs = []
        botAnswer = nil
        botAppearance = .random
        hasFinished = false
        experienceEarnedThisRun = 0
        coinsEarnedThisRun = 0
        experienceAwarded = false
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

    private enum RunOutcome: Equatable {
        case flawlessVictory
        case clutch
        case victory
        case draw
        case defeat

        var title: String {
            switch self {
            case .flawlessVictory: "Flawless Victory"
            case .clutch: "Clutch"
            case .victory: "Victory"
            case .draw: "Draw"
            case .defeat: "Defeat"
            }
        }

        var symbol: String {
            switch self {
            case .flawlessVictory: "sparkles"
            case .clutch: "bolt.fill"
            case .victory: "trophy.fill"
            case .draw: "equal.circle.fill"
            case .defeat: "xmark.circle.fill"
            }
        }

        var accentColor: Color {
            switch self {
            case .flawlessVictory: Color(red: 0.75, green: 0.49, blue: 0.12)
            case .clutch: Color(red: 0.77, green: 0.38, blue: 0.16)
            case .victory: Color(red: 0.20, green: 0.48, blue: 0.35)
            case .draw: Color(red: 0.30, green: 0.43, blue: 0.63)
            case .defeat: Color(red: 0.62, green: 0.30, blue: 0.30)
            }
        }

        func message(
            totalQuestions: Int,
            scoreDifference: Int,
            userScore: Int
        ) -> String {
            switch self {
            case .flawlessVictory:
                "All \(totalQuestions) answers correct! You beat your opponent."
            case .clutch:
                "A close win—you won by \(scoreDifference) \(scoreDifference == 1 ? "point" : "points")!"
            case .victory:
                "You won by \(scoreDifference) points!"
            case .draw:
                "It's a tie at \(userScore) points!"
            case .defeat:
                "Your opponent won this round. Try again!"
            }
        }
    }
}

#Preview {
    NavigationStack {
        AdventureView(
            appearance: AvatarAppearance(),
            history: .constant([]),
            navigationPath: .constant([]),
            level: .constant(1),
            experience: .constant(0),
            coins: .constant(0),
            coinExperienceProgress: .constant(0)
        )
    }
}
