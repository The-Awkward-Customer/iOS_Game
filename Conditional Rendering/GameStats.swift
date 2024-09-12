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
            Text("🍪: \(gameState.Cookies)")  // Display the count value
                .font(.title)
            .padding()
            Text("➕: \(gameState.CookiesPerTap)")  // Display the count value
                .font(.title)
            .padding()
        }
    }
}

#Preview {
    GameStats(gameState: GameState())
}
