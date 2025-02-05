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
    @EnvironmentObject var gameTimeManager: GameTimeManager
    
    @State private var isControlPanelPresented = false
    
    
    // Computed property that creates and configures the scene using the environment objects.
    var scene: MainGameScene {
        let scene = MainGameScene(size: CGSize(width: 800, height: 600), gameState: gameState)
        scene.scaleMode = .resizeFill
        scene.gameTimeManager = gameTimeManager
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
                    scene.gameTimeManager = gameTimeManager
                }
            VStack {
                Text("Currency: \(gameState.TotalHoney)")
                    .font(.custom("Bloxic", size: 28))
                
                Spacer()
                
                CustomGameButton(title: "Game Controls", action: { gameTimeManager.pauseGame()
                    isControlPanelPresented = true
                })
                .padding(.bottom, 24)
                .padding(.horizontal, 32)
            }
        }
        .sheet(isPresented: $isControlPanelPresented, onDismiss: {
            gameTimeManager.resumeGame()
        }) {
            GameControlPanel()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(GameState())
            .environmentObject(GameTimeManager())
    }
}
