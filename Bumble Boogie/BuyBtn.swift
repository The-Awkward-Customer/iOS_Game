//
//  Button.swift
//  Conditional Rendering
//
//  Created by Peter Abbott on 09/09/2024.
//

import SwiftUI

struct BuyBtn: View {
    
    @ObservedObject var gameState: GameState  // Reference the game state
    
    
    var body: some View {
        VStack {
            Button(action: {
                gameState.BuyABee()

            }) {
                Text("buy a 🐝")
            }
            .buttonStyle(CustomButtonStyles(isEnabled: gameState.canBuyBee))  // Apply custom style
            .disabled(!gameState.canBuyBee)  // Disable button when needed
        }
    }
}

#Preview {
    BuyBtn(gameState: GameState())
}
