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
                HStack {
                    GameStats(gameState: gameState)
                    IconButton(iconName: "bolt.fill", action: gameState.SummonShop  )
            }
                .padding(.horizontal, 24)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(
            Image("backgroundWithSparkles")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
        // Present a sheet when isShopPresented is true
        .sheet(isPresented: $gameState.isShopPresented) {
            ShopSheet(gameState: gameState)  // The view that will appear in the sheet
        }
        .onAppear{
            gameState.startSpawningBees()
        }
    }
    
    
    
}



#Preview {
    ContentView(gameState: GameState())
}
