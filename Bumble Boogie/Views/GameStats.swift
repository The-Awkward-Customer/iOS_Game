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
            Text("🐝 Bees: \(gameState.beeGameObjects.count)")  // Display the count value
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
            .padding()
            Text("🍯 Honey: \(gameState.Honey)")  // Display the count value
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
            .padding()
        }
        .background(Color.white)
        .cornerRadius(100)
        .shadow(color: Color.gray.opacity(0.5), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .padding(.horizontal, 24)
    }
}

#Preview {
    GameStats(gameState: GameState())
}
