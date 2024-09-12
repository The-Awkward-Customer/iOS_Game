//
//  Button.swift
//  Conditional Rendering
//
//  Created by Peter Abbott on 09/09/2024.
//

import SwiftUI

struct CookieButton: View {
    
    @ObservedObject var gameState: GameState  // Reference the game state
    
    var body: some View {
        VStack {
            Button(action: {
                gameState.BuyABee()

            }) {
                Text("buy a 🐝")
                    .font(.title)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .foregroundColor(Color.black)
                    .background(Color("PrimaryYellow"))
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    CookieButton(gameState: GameState())
}
