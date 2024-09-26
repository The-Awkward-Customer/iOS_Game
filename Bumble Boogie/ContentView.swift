//
//  ContentView.swift
//  Conditional Rendering
//
//  Created by Peter Abbott on 09/09/2024.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var gameState: GameState  // Reference the game state
    
    @State private var isShopPresented: Bool = false  // Control the visibility of the sheet
    
    var body: some View {
        ZStack {
            
            BeeView(gameState: gameState)
            VStack(spacing: 20) {
                HStack {
                    ResetBtn(gameState: gameState)
                    IconButton(iconName: "bolt.fill", action: SummonShop  )
                }
                
                
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
                .sheet(isPresented: $isShopPresented) {
                    ShopView()  // The view that will appear in the sheet
                }
    }
    
    func SummonShop(){
        print("Open shop")
        
        isShopPresented = true
    }
    
}

struct ShopView: View {
    var body: some View {
        VStack {
            Text("Welcome to the Shop!")
                .font(.largeTitle)
                .padding()

            // Add your shop items or content here

            Button("Close Shop") {
                // Dismiss the shop by swiping down or programmatically if needed
            }
            .padding()
        }
    }
}


#Preview {
    ContentView(gameState: GameState())
}
