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
    
    @ObservedObject var gameState = GameState()
    @ObservedObject var gameTimeManager = GameTimeManager()
    
    @State private var scene: MainGameScene = {
        let scene = MainGameScene(size: CGSize(width: 800, height: 600))
        scene.scaleMode = .aspectFit
        return scene
    }()
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .frame(maxWidth: .infinity, maxHeight: 600)
            VStack {
                Text("Currency: \(gameState.TotalHoney)")
                    .font(.custom("Bloxic", size: 28))
                Text("spawnRate: \(gameTimeManager.basicBeeSpawnInterval)")
                    .frame(width:375)
                    .padding(24)
                    .font(.custom("Bloxic", size: 16))
        
                Spacer()
                
                CustomGameButton(title: "Add Currency", action: {
                    gameState.increaseTotalHoney(by: 10)
                })
                
                CustomGameButton(title: "Remove Currency", action: {
                    gameState.decreaseTotalHoney(by: 20)
                })
                
                
                HStack {
                    
                    Button("Pause") {
                        scene.pauseScene()
                    }
                    Button("Resume") {
                        scene.resumeScene()
                    }
                  
                    
                    
                }
                .padding(.horizontal, 24.0)
                Text("Speed Factor: \(scene.timeManager.speedFactor, specifier: "%.1f")")
                
                
            }
        }
        
        .environmentObject(gameState)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(gameState: GameState())
    }
}
