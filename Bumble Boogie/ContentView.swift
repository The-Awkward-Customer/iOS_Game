//
//  ContentView.swift
//  Conditional Rendering
//
//  Created by Peter Abbott on 09/09/2024.
//

import SwiftUI
import SpriteKit
import AVFoundation

struct ContentView: View {
    
    @ObservedObject var gameState: GameState  // Reference the game state
    @State private var scene: BeeScene
    
    init(gameState: GameState) {
        self.gameState = gameState
        let beeScene = BeeScene()
        beeScene.size = UIScreen.main.bounds.size
        beeScene.scaleMode = .resizeFill
        beeScene.gameDelegate = gameState
        _scene = State(initialValue: beeScene)
    }
    
    var body: some View {
        ZStack {
            
            SpriteView(scene: scene)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                HStack {
                    Spacer()
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
                        IconButton(iconName: "bolt.fill", action: gameState.summonShop, showBadge: gameState.buyBasicHiveButton  )
                    }
                }
                .padding(.horizontal, 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        // Present a sheet when isShopPresented is true
        .sheet(isPresented: $gameState.isShopPresented) {
            ShopSheet(gameState: gameState)  // The view that will appear in the sheet
        }
        
    }
    
    
    
}



#Preview {
    ContentView(gameState: GameState())
}
