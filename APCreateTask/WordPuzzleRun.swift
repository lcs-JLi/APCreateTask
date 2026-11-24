//
//  WordPuzzleRun.swift
//  APCreateTask
//
//  Created by John Li on 2026-11-20.
//  This code was generated using GitHub Copilot.
//  The existing puzzle result model was not changed.
//

import Foundation

struct WordPuzzleRun: Identifiable, Codable, Equatable {
    let id: UUID
    let completedAt: Date
    let word: String
    let guesses: [String]
    let didWin: Bool

    init(word: String, guesses: [String], didWin: Bool, completedAt: Date = .now) {
        id = UUID()
        self.completedAt = completedAt
        self.word = word
        self.guesses = guesses
        self.didWin = didWin
    }
}
