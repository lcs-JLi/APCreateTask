import SwiftUI

struct ContentView: View {
    @State private var appearance = AvatarAppearance()
    @State private var history: [GameRun] = []
    @State private var navigationPath: [AppRoute] = []
    @AppStorage("gameHistoryData") private var historyData = Data()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            WardrobeView(appearance: $appearance, history: $history)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .gameMenu:
                        GameMenuView(appearance: $appearance, history: $history)
                    case .subjectSelection:
                        SubjectSelectionView()
                    case .adventure:
                        AdventureView(
                            appearance: appearance,
                            history: $history,
                            navigationPath: $navigationPath
                        )
                    }
                }
        }
        .task {
            guard !historyData.isEmpty else { return }

            do {
                history = try JSONDecoder().decode([GameRun].self, from: historyData)
            } catch {
                print("Unable to load saved game history: \(error)")
            }
        }
        .onChange(of: history) { _, updatedHistory in
            do {
                historyData = try JSONEncoder().encode(updatedHistory)
            } catch {
                print("Unable to save game history: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
