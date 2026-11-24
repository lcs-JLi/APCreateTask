import SwiftUI

struct ContentView: View {
    @State private var appearance = AvatarAppearance()
    @State private var history: [GameRun] = []
    @State private var wordPuzzleHistory: [WordPuzzleRun] = []
    @State private var unlockedAvatarItems: Set<String> = []
    @State private var navigationPath: [AppRoute] = []
    @AppStorage("gameHistoryData") private var historyData = Data()
    @AppStorage("wordPuzzleHistoryData") private var wordPuzzleHistoryData = Data()
    @AppStorage("playerLevel") private var level = 1
    @AppStorage("playerExperience") private var experience = 0.0
    @AppStorage("playerCoins") private var coins = 0
    @AppStorage("coinExperienceProgress") private var coinExperienceProgress = 0.0
    @AppStorage("unlockedAvatarItemsData") private var unlockedAvatarItemsData = Data()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            WardrobeView(
                appearance: $appearance,
                history: $history,
                level: $level,
                coins: $coins,
                unlockedItems: $unlockedAvatarItems
            )
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
                            coinExperienceProgress: $coinExperienceProgress,
                            unlockedItems: $unlockedAvatarItems
                        )
                    case .subjectSelection:
                        SubjectSelectionView(level: level)
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
                            navigationPath: $navigationPath,
                            level: $level,
                            experience: $experience,
                            coins: $coins,
                            coinExperienceProgress: $coinExperienceProgress,
                            backpackEquipped: appearance.equippedEquipment.contains(.backpack)
                        )
                    case .shop:
                        ShopView(
                            level: level,
                            coins: $coins,
                            unlockedItems: $unlockedAvatarItems
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
            if !unlockedAvatarItemsData.isEmpty {
                do {
                    unlockedAvatarItems = try JSONDecoder().decode(
                        Set<String>.self,
                        from: unlockedAvatarItemsData
                    )
                } catch {
                    print("Unable to load avatar unlocks: \(error)")
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
        .onChange(of: unlockedAvatarItems) { _, updatedItems in
            do {
                unlockedAvatarItemsData = try JSONEncoder().encode(updatedItems)
            } catch {
                print("Unable to save avatar unlocks: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
