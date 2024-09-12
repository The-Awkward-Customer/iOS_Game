//
//  GameStats.swift
//  Conditional Rendering
//
//  Created by Peter Abbott on 11/09/2024.
//

import SwiftUI

struct GameStats: View {
    
    @ObservedObject var gameState: GameState  // Reference the game state
    
    var body: some View {
        HStack {
            Text("🐝 Bees: \(gameState.Bees)")  // Display the count value
                .font(.subheadline)
                .fontWeight(.bold)
            .padding()
            Text("🍯 Honey: \(gameState.Honey)")  // Display the count value
                .font(.subheadline)
                .fontWeight(.bold)
            .padding()
        }
    }
}

#Preview {
    GameStats(gameState: GameState())
}
