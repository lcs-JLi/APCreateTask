import SwiftUI

struct ContentView: View {
    @State private var appearance = AvatarAppearance()
    @State private var history: [GameRun] = []
    @State private var wordPuzzleHistory: [WordPuzzleRun] = []
    @State private var navigationPath: [AppRoute] = []
    @AppStorage("gameHistoryData") private var historyData = Data()
    @AppStorage("wordPuzzleHistoryData") private var wordPuzzleHistoryData = Data()
    @AppStorage("playerLevel") private var level = 1
    @AppStorage("playerExperience") private var experience = 0.0
    @AppStorage("playerCoins") private var coins = 0
    @AppStorage("coinExperienceProgress") private var coinExperienceProgress = 0.0

    var body: some View {
        NavigationStack(path: $navigationPath) {
            WardrobeView(appearance: $appearance, history: $history)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .gameMenu:
                        GameMenuView(
                            appearance: $appearance,
                            history: $history,
                            wordPuzzleHistory: $wordPuzzleHistory,
                            level: $level,
                            experience: $experience,
                            coins: $coins,
                            coinExperienceProgress: $coinExperienceProgress
                        )
                    case .subjectSelection:
                        SubjectSelectionView()
                    case .adventure:
                        AdventureView(
                            appearance: appearance,
                            history: $history,
                            navigationPath: $navigationPath,
                            level: $level,
                            experience: $experience,
                            coins: $coins,
                            coinExperienceProgress: $coinExperienceProgress
                        )
                    case .wordPuzzle:
                        WordPuzzleView(
                            gameHistory: history,
                            history: $wordPuzzleHistory,
                            level: $level,
                            experience: $experience,
                            coins: $coins,
                            coinExperienceProgress: $coinExperienceProgress
                        )
                    }
                }
        }
        .task {
            if !historyData.isEmpty {
                do {
                    history = try JSONDecoder().decode([GameRun].self, from: historyData)
                } catch {
                    print("Unable to load saved game history: \(error)")
                }
            }
            if !wordPuzzleHistoryData.isEmpty {
                do {
                    wordPuzzleHistory = try JSONDecoder().decode(
                        [WordPuzzleRun].self,
                        from: wordPuzzleHistoryData
                    )
                } catch {
                    print("Unable to load saved word puzzle history: \(error)")
                }
            }
        }
        .onChange(of: history) { _, updatedHistory in
            do {
                historyData = try JSONEncoder().encode(updatedHistory)
            } catch {
                print("Unable to save game history: \(error)")
            }
        }
        .onChange(of: wordPuzzleHistory) { _, updatedHistory in
            do {
                wordPuzzleHistoryData = try JSONEncoder().encode(updatedHistory)
            } catch {
                print("Unable to save word puzzle history: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
