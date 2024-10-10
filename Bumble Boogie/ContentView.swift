//
//  ContentView.swift
//  Conditional Rendering
//
//  Created by Peter Abbott on 09/09/2024.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @ObservedObject var gameState: GameState  // Reference the game state
    
    var body: some View {
        ZStack {
            
            BeeView(gameState: gameState)
            VStack(spacing: 20) {
                HStack {
                    GameStats(gameState: gameState)
                    
                }
                .padding(.horizontal, 24)
                .onAppear {
                    gameState.enableBasicHivePurchase()  // Check if the button should be enabled when the view appears
                }
                Spacer()
                
                
                HStack{
                    Spacer()
                    VStack(spacing: 24) {
                        MusicToggle()
                        IconButton(iconName: "bolt.fill", action: gameState.SummonShop, showBadge: gameState.buyBasicHiveButton  )
                    }
                }
                .padding(.horizontal, 24)
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
