import SwiftUI

struct GameControlPanel: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                
                Spacer()
                
                Text("Currency: \(gameState.totalHoney)")
                    .font(.subheadline)
                Text("spawnRate: \(gameState.basicBeeSpawnInterval)")
                    .font(.subheadline)
                Text("Hives: \(gameState.hiveCount)")
                    .font(.subheadline)
                
                
                Spacer()
                Toggle("Display debug grid", isOn: $gameState.showDebugGrid)
                Toggle("Display physics debugger", isOn: $gameState.showPhysicsDebug)
                
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
