import SwiftUI

struct GameControlPanel: View {
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var gameTimeManager: GameTimeManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("spawnRate: \(gameTimeManager.basicBeeSpawnInterval)")
                    .frame(width:375)
                    .padding(24)
                    .font(.custom("Bloxic", size: 16))
                Spacer()
                HStack {
                    CustomGameButton(title: "Add Currency", action: {
                        gameState.increaseTotalHoney(by: 10)
                    })
                    
                    CustomGameButton(title: "Remove Currency", action: {
                        gameState.decreaseTotalHoney(by: 20)
                    })
                }
                
                HStack {
                    CustomGameButton(title: "Faster Spawn", action: gameTimeManager.increaseBasicBeeSpawnRate)
                    
                    CustomGameButton(title: "Slower Spawn", action: gameTimeManager.decreaseBasicBeeSpawnRate)
                }
                
                HStack {
                    CustomGameButton(title: "Macro Stop", action: gameTimeManager.stopMasterTimer)
                    
                    CustomGameButton(title: "Master Start", action: gameTimeManager.startMasterTimer)
                }
            }
            .padding(.horizontal, 24)
            .navigationTitle("Game Controls")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        gameTimeManager.resumeGame()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    GameControlPanel()
        .environmentObject(GameState())
        .environmentObject(GameTimeManager())
}
