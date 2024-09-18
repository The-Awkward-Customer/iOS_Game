//
//  ContentView.swift
//  Conditional Rendering
//
//  Created by Peter Abbott on 09/09/2024.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var gameState: GameState  // Reference the game state
    
    var body: some View {
        ZStack {
            
            BeeView(gameState: gameState)
            VStack(spacing: 20) {
                ResetBtn(gameState: gameState)
                
                
                Spacer()
                
                
                GameStats(gameState: gameState)
                BuyBtn(gameState: gameState)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(
            Image("backgroundWithSparkles")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }
    
}


#Preview {
    ContentView(gameState: GameState())
}
