import SwiftUI

struct WordPuzzleView: View {
    private enum LetterFeedback: Equatable {
        case correct
        case misplaced
        case absent
    }

    private static let maximumGuesses = 6

    let gameHistory: [GameRun]
    @Binding var history: [WordPuzzleRun]
    @Binding var navigationPath: [AppRoute]
    @Binding var level: Int
    @Binding var experience: Double
    @Binding var coins: Int
    @Binding var coinExperienceProgress: Double
    let backpackEquipped: Bool

    @State private var targetWord = WordPuzzleWordBank.words.randomElement() ?? "apple"
    @State private var guesses: [String] = []
    @State private var currentGuess = ""
    @State private var message: String?
    @State private var experienceEarnedThisRun = 0.0
    @State private var coinsEarnedThisRun = 0

    private var hasWon: Bool {
        guesses.last == targetWord
    }

    private var isFinished: Bool {
        hasWon || guesses.count == Self.maximumGuesses
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

            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("ENGLISH")
                                .font(.system(size: 15, weight: .heavy, design: .rounded))
                                .tracking(1)
                                .foregroundStyle(Color(red: 0.49, green: 0.39, blue: 0.56))

                            Text("Guess the 5-letter word!")
                                .font(.system(size: 24, weight: .heavy, design: .rounded))
                                .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                                .accessibilityAddTraits(.isHeader)
                        }

                        Spacer()

                        NavigationLink {
                            GameHistoryView(runs: gameHistory, wordPuzzleRuns: history)
                        } label: {
                            Label("History", systemImage: "clock.arrow.circlepath")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(red: 0.20, green: 0.48, blue: 0.45))
                        }
                        .accessibilityHint("See your past math and English games")
                    }

                    Text("You have 6 tries. Green means the letter is in the right spot; yellow means it belongs somewhere else.")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(red: 0.33, green: 0.42, blue: 0.44))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    guessBoard

                    if let message {
                        Text(message)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(red: 0.65, green: 0.29, blue: 0.25))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    if isFinished {
                        resultCard
                    } else {
                        guessEntry
                    }
                }
                .padding(20)
                .frame(maxWidth: 520)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("English")
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }

    private var guessBoard: some View {
        VStack(spacing: 8) {
            ForEach(0..<Self.maximumGuesses, id: \.self) { row in
                let letters = lettersForRow(row)
                let feedback = row < guesses.count ? Self.feedback(for: guesses[row], target: targetWord) : []

                HStack(spacing: 8) {
                    ForEach(0..<5, id: \.self) { column in
                        let letter = column < letters.count ? String(letters[column]).uppercased() : ""
                        let status = column < feedback.count ? feedback[column] : nil

                        Text(letter)
                            .font(.system(size: 23, weight: .heavy, design: .rounded))
                            .foregroundStyle(status == nil ? Color(red: 0.15, green: 0.26, blue: 0.30) : .white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(tileColor(for: status), in: RoundedRectangle(cornerRadius: 12))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(
                                        status == nil
                                            ? Color(red: 0.72, green: 0.78, blue: 0.75)
                                            : .clear,
                                        lineWidth: 2
                                    )
                            }
                            .accessibilityLabel(letter.isEmpty ? "Empty letter" : letter)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(accessibilityLabel(for: row, letters: letters, feedback: feedback))
            }
        }
        .padding(16)
        .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 24))
    }

    private var guessEntry: some View {
        VStack(spacing: 12) {
            TextField("Type a 5-letter word", text: $currentGuess)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .autocorrectionDisabled()
                .submitLabel(.go)
                .padding(16)
                .background(.white, in: RoundedRectangle(cornerRadius: 16))
                .onChange(of: currentGuess) { _, newValue in
                    let letters = newValue.uppercased().filter { $0 >= "A" && $0 <= "Z" }
                    let limitedLetters = String(letters.prefix(5))
                    if limitedLetters != currentGuess {
                        currentGuess = limitedLetters
                    }
                }
                .onSubmit(submitGuess)
                .accessibilityHint("Enter five letters, then tap Guess")

            Button(action: submitGuess) {
                Text("Guess")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color(red: 0.20, green: 0.48, blue: 0.45), in: Capsule())
            }
            .buttonStyle(.plain)
            .disabled(currentGuess.count != 5)
            .opacity(currentGuess.count == 5 ? 1 : 0.55)
        }
    }

    private var resultCard: some View {
        VStack(spacing: 12) {
            Text(hasWon ? "Great job!" : "Good try!")
                .font(.system(size: 25, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                .accessibilityAddTraits(.isHeader)

            Text(hasWon
                 ? "You found \(targetWord.uppercased()) in \(guesses.count) \(guesses.count == 1 ? "guess" : "guesses")!"
                 : "The word was \(targetWord.uppercased()).")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(red: 0.20, green: 0.48, blue: 0.45))

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

            Button(action: startNewPuzzle) {
                Label("Play again", systemImage: "arrow.clockwise")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color(red: 0.49, green: 0.39, blue: 0.56), in: Capsule())
            }
            .buttonStyle(.plain)

            Button {
                navigationPath = [.gameMenu]
            } label: {
                Label("Back to menu", systemImage: "arrow.left")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.20, green: 0.48, blue: 0.45))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 24))
    }

    private func lettersForRow(_ row: Int) -> [Character] {
        if row < guesses.count {
            return Array(guesses[row])
        }
        if row == guesses.count && !isFinished {
            return Array(currentGuess)
        }
        return []
    }

    private func tileColor(for feedback: LetterFeedback?) -> Color {
        switch feedback {
        case .correct:
            Color(red: 0.20, green: 0.58, blue: 0.38)
        case .misplaced:
            Color(red: 0.80, green: 0.61, blue: 0.16)
        case .absent:
            Color(red: 0.38, green: 0.42, blue: 0.43)
        case nil:
            Color.white.opacity(0.7)
        }
    }

    private func accessibilityLabel(
        for row: Int,
        letters: [Character],
        feedback: [LetterFeedback]
    ) -> String {
        guard row < guesses.count else {
            return "Guess \(row + 1), \(letters.count) of 5 letters entered"
        }

        let letterDescriptions = zip(letters, feedback).enumerated().map { index, pair in
            let position = pair.1 == .correct
                ? "correct spot"
                : pair.1 == .misplaced ? "in the word, different spot" : "not in the word"
            return "letter \(index + 1), \(pair.0), \(position)"
        }
        return "Guess \(row + 1): " + letterDescriptions.joined(separator: ", ")
    }

    private static func feedback(for guess: String, target: String) -> [LetterFeedback] {
        let guessLetters = Array(guess)
        let targetLetters = Array(target)
        var result = Array(repeating: LetterFeedback.absent, count: guessLetters.count)
        var remainingLetters = Dictionary(grouping: targetLetters, by: { $0 })
            .mapValues(\.count)

        for index in guessLetters.indices where guessLetters[index] == targetLetters[index] {
            result[index] = .correct
            remainingLetters[guessLetters[index], default: 0] -= 1
        }

        for index in guessLetters.indices where result[index] != .correct {
            let letter = guessLetters[index]
            if remainingLetters[letter, default: 0] > 0 {
                result[index] = .misplaced
                remainingLetters[letter, default: 0] -= 1
            }
        }

        return result
    }

    private func submitGuess() {
        guard !isFinished else { return }

        let guess = currentGuess.lowercased()
        guard guess.count == 5 else {
            message = "Type 5 letters before you guess."
            return
        }

        guesses.append(guess)
        currentGuess = ""
        message = nil

        if guesses.last == targetWord || guesses.count == Self.maximumGuesses {
            experienceEarnedThisRun = PlayerRewards.experienceWithBackpackBonus(
                75,
                backpackEquipped: backpackEquipped
            )
            coinsEarnedThisRun = PlayerRewards.awardExperience(
                experienceEarnedThisRun,
                level: &level,
                experience: &experience,
                coins: &coins,
                coinExperienceProgress: &coinExperienceProgress
            )
            history.append(
                WordPuzzleRun(word: targetWord, guesses: guesses, didWin: guesses.last == targetWord)
            )
        }
    }

    private func startNewPuzzle() {
        let possibleWords = WordPuzzleWordBank.words.filter { $0 != targetWord }
        targetWord = possibleWords.randomElement() ?? WordPuzzleWordBank.words[0]
        guesses = []
        currentGuess = ""
        message = nil
        experienceEarnedThisRun = 0
        coinsEarnedThisRun = 0
    }
}

#Preview {
    NavigationStack {
        WordPuzzleView(
            gameHistory: [],
            history: .constant([]),
            navigationPath: .constant([]),
            level: .constant(1),
            experience: .constant(0),
            coins: .constant(0),
            coinExperienceProgress: .constant(0),
            backpackEquipped: false
        )
    }
}
