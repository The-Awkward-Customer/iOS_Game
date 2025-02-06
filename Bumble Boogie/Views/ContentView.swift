//
//  ContentView.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 03/01/2025.
//

import Foundation

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    @EnvironmentObject var gameState: GameState
    
    @State private var isControlPanelPresented = false
    @State private var isShopViewPresented = false
    
    
    // Computed property that creates and configures the scene using the environment objects.
    var scene: MainGameScene {
        let scene = MainGameScene(size: CGSize(width: 800, height: 600), gameState: gameState)
        scene.scaleMode = .resizeFill
        scene.gameState = gameState
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
                .onAppear {
                    // Inject the manager so the scene can set up the callback
                    scene.gameState = gameState
                }
            VStack (spacing: 16){
                Text("Currency: \(gameState.TotalHoney)")
                    .font(.custom("Bloxic", size: 28))
                
                Spacer()
                
                HStack {
                    CustomGameButton(title: "Game Controls", action: { gameState.pauseGame()
                        isControlPanelPresented = true
                    })
                    
                    CustomGameButton(title: "Start Master", action: {
                        gameState.startMasterTimer()
                        
                    })
                }
                
                CustomGameButton(title: "Shop", action: {
                    gameState.pauseGame()
                    isShopViewPresented = true
                })
            }
            .padding(.horizontal, 32)
        }
        ///Opens control dev control panel
        .sheet(isPresented: $isControlPanelPresented, onDismiss: {
            gameState.resumeGame()
        }) {
            GameControlPanel()
        }
        ///Opens control dev control panel
        .sheet(isPresented: $isShopViewPresented, onDismiss: {
            gameState.resumeGame()
        }) {
            ShopView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(GameState())
    }
}
