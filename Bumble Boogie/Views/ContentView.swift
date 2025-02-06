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
            VStack {
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
                .padding(.horizontal, 32)
            }
        }
        .sheet(isPresented: $isControlPanelPresented, onDismiss: {
            gameState.resumeGame()
        }) {
            GameControlPanel()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(GameState())
    }
}
