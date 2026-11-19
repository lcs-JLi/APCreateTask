import Foundation

struct GameQuestionResult: Identifiable, Codable, Equatable {
    let question: MathQuestion
    let selectedAnswer: Int

    var id: Int {
        question.id
    }

    var isCorrect: Bool {
        selectedAnswer == question.correctAnswer
    }
}

struct GameRun: Identifiable, Codable, Equatable {
    let id: UUID
    let completedAt: Date
    let answers: [GameQuestionResult]

    var correctCount: Int {
        answers.filter(\.isCorrect).count
    }

    var score: Int {
        var streak = 0
        var total = 0

        for answer in answers {
            if answer.isCorrect {
                streak += 1
                total += streak > 3 ? 5 + (streak - 3) : 5
            } else {
                streak = 0
            }
        }

        return total
    }

    init(answers: [GameQuestionResult], completedAt: Date = .now) {
        id = UUID()
        self.completedAt = completedAt
        self.answers = answers
    }
}
