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
            Text("🍯 Honey: \(gameState.Honey)")  // Display the count value
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 4)
            Text("🏡 Hives: \(gameState.basicHives)")  // Display the count value
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 4)
        }
        .frame(height: 40)
        .background(Color.white)
        .cornerRadius(100)
        .shadow(color: Color.gray.opacity(0.5), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        

    }
}

#Preview {
    GameStats(gameState: GameState())
}
