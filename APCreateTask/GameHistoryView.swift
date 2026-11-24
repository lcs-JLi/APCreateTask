//
//  GameHistoryView.swift
//  APCreateTask
//
//  Created by John Li on 2026-11-20.
//  This code was generated using GitHub Copilot:
//  Main functions: wordPuzzleRunCard, runCard, and answerRow for rendering game history.
//  Copilot change in this session: added a dismiss-based Back to menu button.
//

import SwiftUI

struct GameHistoryView: View {
    @Environment(\.dismiss) private var dismiss

    let runs: [GameRun]
    let wordPuzzleRuns: [WordPuzzleRun]

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
                VStack(alignment: .leading, spacing: 18) {
                    Text("Game History")
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                        .accessibilityAddTraits(.isHeader)

                    if runs.isEmpty && wordPuzzleRuns.isEmpty {
                        emptyState
                    }

                    if !wordPuzzleRuns.isEmpty {
                        Text("English")
                            .font(.system(size: 23, weight: .heavy, design: .rounded))
                            .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                            .accessibilityAddTraits(.isHeader)

                        ForEach(Array(wordPuzzleRuns.reversed().enumerated()), id: \.element.id) { index, run in
                            wordPuzzleRunCard(run, number: wordPuzzleRuns.count - index)
                        }
                    }

                    if !runs.isEmpty {
                        Text("Math Adventures")
                            .font(.system(size: 23, weight: .heavy, design: .rounded))
                            .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                            .accessibilityAddTraits(.isHeader)

                        ForEach(Array(runs.reversed().enumerated()), id: \.element.id) { index, run in
                            runCard(run, number: runs.count - index)
                        }
                    }

                    Button {
                        dismiss()
                    } label: {
                        returnToMenuLabel
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 4)
                }
                .padding(20)
                .frame(maxWidth: 720)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Game History")
    }

    private var returnToMenuLabel: some View {
        Label("Back to menu", systemImage: "arrow.left")
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color(red: 0.20, green: 0.48, blue: 0.45), in: Capsule())
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 42, weight: .medium))
                .foregroundStyle(Color(red: 0.20, green: 0.48, blue: 0.45))
                .accessibilityHidden(true)

            Text("No games yet")
                .font(.system(size: 23, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))
                .accessibilityAddTraits(.isHeader)

            Text("Complete a math adventure or English game to see your games here.")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(red: 0.33, green: 0.42, blue: 0.44))
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 26))
    }

    private func wordPuzzleRunCard(_ run: WordPuzzleRun, number: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("Run \(number)")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))

                Spacer()

                Text(run.completedAt, format: .dateTime.month(.abbreviated).day().hour().minute())
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            Text(run.didWin
                 ? "Solved in \(run.guesses.count) \(run.guesses.count == 1 ? "guess" : "guesses")"
                 : "Not solved in \(run.guesses.count) guesses")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.20, green: 0.48, blue: 0.45))

            Text("Answer: \(run.word)")
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.55, green: 0.40, blue: 0.09))

            Divider()

            Text("Your guesses: \(run.guesses.map { $0.uppercased() }.joined(separator: ", "))")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Color(red: 0.33, green: 0.42, blue: 0.44))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color(red: 0.33, green: 0.43, blue: 0.37).opacity(0.08), radius: 12, y: 6)
    }

    private func runCard(_ run: GameRun, number: Int) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                Text("Run \(number)")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))

                Spacer()

                Text(run.completedAt, format: .dateTime.month(.abbreviated).day().hour().minute())
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            Text("\(run.correctCount) of \(run.answers.count) correct")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.20, green: 0.48, blue: 0.45))

            Text("\(run.score) points")
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 0.55, green: 0.40, blue: 0.09))

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                ForEach(run.answers) { answer in
                    answerRow(answer)
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color(red: 0.33, green: 0.43, blue: 0.37).opacity(0.08), radius: 12, y: 6)
    }

    private func answerRow(_ answer: GameQuestionResult) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: answer.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(
                    answer.isCorrect
                        ? Color(red: 0.20, green: 0.58, blue: 0.38)
                        : Color(red: 0.78, green: 0.34, blue: 0.29)
                )
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(answer.question.prompt)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.15, green: 0.26, blue: 0.30))

                Text(answer.isCorrect
                     ? "Your answer: \(answer.selectedAnswer) — Correct"
                     : "Your answer: \(answer.selectedAnswer) · Correct answer: \(answer.question.correctAnswer)")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(answer.isCorrect
                                     ? Color(red: 0.20, green: 0.48, blue: 0.45)
                                     : Color(red: 0.65, green: 0.29, blue: 0.25))
            }

            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack {
        GameHistoryView(runs: [], wordPuzzleRuns: [])
    }
}
