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
