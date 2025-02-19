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
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
            
            VStack (spacing: 16){
                HStack {
                    Spacer()
                    ProgressView(
                        isButton: true,
                        canUpgrade: true,
                        action: {
                            print ("Upgrade!")
                            isShopViewPresented = true }
                    )
                }
                
                
                Spacer()
                // In ContentView - Add a test button
                CustomGameButton(title: "Test Pause", action: {
                    gameState.pauseGame()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        gameState.resumeGame()
                    }
                })
                
                HStack {
                    CustomGameButton(title: "Game Controls", action: { gameState.pauseGame()
                        isControlPanelPresented = true
                    })
                    
                    CustomGameButton(title: "Start Master", action: {
                        gameState.startMasterTimer()
                        
                    })
                }
                
            }
            .padding(.horizontal, 32)
        }
        ///Opens control dev control panel
        .sheet(isPresented: $isControlPanelPresented, onDismiss: {
            gameState.resumeGame()
        }) {
            GameControlPanel()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        ///Opens control dev control panel
        .sheet(isPresented: $isShopViewPresented, onDismiss: {
            gameState.resumeGame()
        }) {
            ShopView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .environmentObject(GameState())
        }
    }

