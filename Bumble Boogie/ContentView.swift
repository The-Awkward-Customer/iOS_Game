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
            VStack (spacing: 20) {
                Text("v 0.0.1")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text(" If you can see this view you have succesfully installed the game")
                    .multilineTextAlignment(.center)
                Text("Buy a bee to start collecting Honey")
                    .multilineTextAlignment(.center)
                BuyBtn(gameState: gameState)
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
