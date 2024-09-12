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
        
        ZStack{
            Image("backgroundWithSparkles")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("v 0.0.1")
                Text("If you can see this view you have succesfully installed the game")
                    .multilineTextAlignment(.center)
                CookieButton(gameState: gameState)
                GameStats(gameState: gameState)
                ResetBtn(gameState: gameState)
            }
            .padding()
            .frame(maxWidth: 340, maxHeight: .infinity)
            
            .onAppear{
                gameState.startTimer()
            }
        }
        
    }
}

#Preview {
    ContentView(gameState: GameState())
}
