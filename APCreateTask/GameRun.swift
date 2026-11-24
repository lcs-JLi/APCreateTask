//
//  GameRun.swift
//  APCreateTask
//
//  Created by John Li on 2026-11-20.
//  This code was generated using GitHub Copilot.
//  The existing game result model was not changed.
//

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
    let score: Int

    var correctCount: Int {
        answers.filter(\.isCorrect).count
    }

    init(answers: [GameQuestionResult], score: Int? = nil, completedAt: Date = .now) {
        id = UUID()
        self.completedAt = completedAt
        self.answers = answers
        self.score = score ?? Self.calculatedScore(for: answers)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case completedAt
        case answers
        case score
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        completedAt = try container.decode(Date.self, forKey: .completedAt)
        answers = try container.decode([GameQuestionResult].self, forKey: .answers)
        score = try container.decodeIfPresent(Int.self, forKey: .score)
            ?? Self.calculatedScore(for: answers)
    }

    private static func calculatedScore(for answers: [GameQuestionResult]) -> Int {
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
}
