//
//  ResetBtn.swift
//  Conditional Rendering
//
//  Created by Peter Abbott on 11/09/2024.
//

import SwiftUI


struct ResetBtn: View {
    
    @ObservedObject var gameState: GameState  // Reference the game state

    
    var body: some View {
        Button (action: {
            gameState.hardReset()
        }) {
            Text("reset game")
                .foregroundColor(Color.gray)
                .fontWeight(.bold)
        }
        
    }
}

#Preview {
    ResetBtn(gameState: GameState())
}
