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
        VStack {
            CookieButton(gameState: gameState)
            GameStats(gameState: gameState)
            ResetBtn(gameState: gameState)
        }
        .padding()
        
        .onAppear{
            gameState.startTimer()
        }
    }
}

#Preview {
    ContentView(gameState: GameState())
}
