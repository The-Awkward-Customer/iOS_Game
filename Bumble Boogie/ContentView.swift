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
                    ResetBtn(gameState: gameState)
                    Spacer()
                    IconButton(iconName: "bolt.fill", action: gameState.SummonShop  )
                }
                .padding(24)
                
                
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
        // Present a sheet when isShopPresented is true
        .sheet(isPresented: $gameState.isShopPresented) {
            ShopSheet(gameState: gameState)  // The view that will appear in the sheet
                }
    }
    
    
}



#Preview {
    ContentView(gameState: GameState())
}
