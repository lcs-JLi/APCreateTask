import SwiftUI

struct ContentView: View {
    @State private var appearance = AvatarAppearance()
    @State private var history: [GameRun] = []
    @AppStorage("gameHistoryData") private var historyData = Data()

    var body: some View {
        NavigationStack {
            WardrobeView(appearance: $appearance, history: $history)
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
