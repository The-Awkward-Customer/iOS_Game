import SwiftUI

struct GameControlPanel: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Currency: \(gameState.TotalHoney)")
                    .font(.custom("Bloxic", size: 28))
                Text("spawnRate: \(gameState.basicBeeSpawnInterval)")
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
                    CustomGameButton(title: "Faster Spawn", action: gameState.increaseBasicBeeSpawnRate)
                    
                    CustomGameButton(title: "Slower Spawn", action: gameState.decreaseBasicBeeSpawnRate)
                }
                
                HStack {
                    CustomGameButton(title: "Macro Stop", action: gameState.stopMasterTimer)
                    
                    CustomGameButton(title: "Master Start", action: gameState.startMasterTimer)
                }
            }
            .padding(.horizontal, 24)
            .navigationTitle("Game Controls")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        gameState.resumeGame()
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
}
