import Foundation

struct MathQuestion: Identifiable, Codable, Equatable {
    let id: Int
    let prompt: String
    let options: [Int]
    let correctAnswer: Int
    let explanation: String
}

enum MathQuestionBank {
    static let questions: [MathQuestion] = [
        MathQuestion(
            id: 1,
            prompt: "What is 7 + 5?",
            options: [10, 11, 12, 13],
            correctAnswer: 12,
            explanation: "7 plus 5 makes 12."
        ),
        MathQuestion(
            id: 2,
            prompt: "What is 14 − 6?",
            options: [6, 7, 8, 9],
            correctAnswer: 8,
            explanation: "Take 6 away from 14 and you have 8."
        ),
        MathQuestion(
            id: 3,
            prompt: "What is 3 × 4?",
            options: [7, 10, 12, 14],
            correctAnswer: 12,
            explanation: "3 groups of 4 make 12."
        ),
        MathQuestion(
            id: 4,
            prompt: "What is 20 ÷ 5?",
            options: [3, 4, 5, 6],
            correctAnswer: 4,
            explanation: "20 split into 5 equal groups gives 4 in each group."
        ),
        MathQuestion(
            id: 5,
            prompt: "What is 9 + 8?",
            options: [15, 16, 17, 18],
            correctAnswer: 17,
            explanation: "9 plus 8 makes 17."
        ),
        MathQuestion(
            id: 6,
            prompt: "What is 6 × 7?",
            options: [36, 40, 42, 48],
            correctAnswer: 42,
            explanation: "6 groups of 7 make 42."
        ),
        MathQuestion(
            id: 7,
            prompt: "What is 36 ÷ 4?",
            options: [8, 9, 10, 12],
            correctAnswer: 9,
            explanation: "36 split into 4 equal groups gives 9 in each group."
        ),
        MathQuestion(
            id: 8,
            prompt: "What is 50 − 23?",
            options: [25, 27, 28, 33],
            correctAnswer: 27,
            explanation: "50 minus 20 is 30, and 30 minus 3 is 27."
        ),
        MathQuestion(
            id: 9,
            prompt: "What is 8 × 8?",
            options: [56, 62, 64, 72],
            correctAnswer: 64,
            explanation: "8 groups of 8 make 64."
        ),
        MathQuestion(
            id: 10,
            prompt: "What is 45 ÷ 5?",
            options: [7, 8, 9, 10],
            correctAnswer: 9,
            explanation: "45 split into 5 equal groups gives 9 in each group."
        ),
        MathQuestion(
            id: 11,
            prompt: "What is 16 + 7?",
            options: [21, 22, 23, 24],
            correctAnswer: 23,
            explanation: "16 plus 7 makes 23."
        ),
        MathQuestion(
            id: 12,
            prompt: "What is 32 − 14?",
            options: [16, 17, 18, 19],
            correctAnswer: 18,
            explanation: "32 minus 14 is 18."
        ),
        MathQuestion(
            id: 13,
            prompt: "What is 5 × 6?",
            options: [25, 30, 35, 40],
            correctAnswer: 30,
            explanation: "5 groups of 6 make 30."
        ),
        MathQuestion(
            id: 14,
            prompt: "What is 42 ÷ 6?",
            options: [6, 7, 8, 9],
            correctAnswer: 7,
            explanation: "42 split into 6 equal groups gives 7 in each group."
        ),
        MathQuestion(
            id: 15,
            prompt: "What is 28 + 15?",
            options: [41, 42, 43, 44],
            correctAnswer: 43,
            explanation: "28 plus 15 makes 43."
        ),
        MathQuestion(
            id: 16,
            prompt: "What is 63 − 27?",
            options: [34, 35, 36, 37],
            correctAnswer: 36,
            explanation: "63 minus 27 is 36."
        ),
        MathQuestion(
            id: 17,
            prompt: "What is 9 × 4?",
            options: [32, 34, 36, 38],
            correctAnswer: 36,
            explanation: "9 groups of 4 make 36."
        ),
        MathQuestion(
            id: 18,
            prompt: "What is 72 ÷ 8?",
            options: [7, 8, 9, 10],
            correctAnswer: 9,
            explanation: "72 split into 8 equal groups gives 9 in each group."
        ),
        MathQuestion(
            id: 19,
            prompt: "What is 35 + 18?",
            options: [51, 52, 53, 54],
            correctAnswer: 53,
            explanation: "35 plus 18 makes 53."
        ),
        MathQuestion(
            id: 20,
            prompt: "What is 81 − 46?",
            options: [33, 34, 35, 36],
            correctAnswer: 35,
            explanation: "81 minus 46 is 35."
        ),
        MathQuestion(
            id: 21,
            prompt: "What is 7 × 8?",
            options: [48, 54, 56, 64],
            correctAnswer: 56,
            explanation: "7 groups of 8 make 56."
        ),
        MathQuestion(
            id: 22,
            prompt: "What is 54 ÷ 9?",
            options: [5, 6, 7, 8],
            correctAnswer: 6,
            explanation: "54 split into 9 equal groups gives 6 in each group."
        ),
        MathQuestion(
            id: 23,
            prompt: "What is 46 + 27?",
            options: [71, 72, 73, 74],
            correctAnswer: 73,
            explanation: "46 plus 27 makes 73."
        ),
        MathQuestion(
            id: 24,
            prompt: "What is 90 − 38?",
            options: [50, 51, 52, 53],
            correctAnswer: 52,
            explanation: "90 minus 38 is 52."
        ),
        MathQuestion(
            id: 25,
            prompt: "What is 12 × 3?",
            options: [30, 33, 36, 39],
            correctAnswer: 36,
            explanation: "12 groups of 3 make 36."
        ),
        MathQuestion(
            id: 26,
            prompt: "What is 64 ÷ 8?",
            options: [6, 7, 8, 9],
            correctAnswer: 8,
            explanation: "64 split into 8 equal groups gives 8 in each group."
        ),
        MathQuestion(
            id: 27,
            prompt: "What is 58 + 16?",
            options: [72, 73, 74, 75],
            correctAnswer: 74,
            explanation: "58 plus 16 makes 74."
        ),
        MathQuestion(
            id: 28,
            prompt: "What is 100 − 57?",
            options: [41, 42, 43, 44],
            correctAnswer: 43,
            explanation: "100 minus 57 is 43."
        ),
        MathQuestion(
            id: 29,
            prompt: "What is 11 × 5?",
            options: [45, 50, 55, 60],
            correctAnswer: 55,
            explanation: "11 groups of 5 make 55."
        ),
        MathQuestion(
            id: 30,
            prompt: "What is 96 ÷ 12?",
            options: [6, 7, 8, 9],
            correctAnswer: 8,
            explanation: "96 split into 12 equal groups gives 8 in each group."
        )
    ]
}
