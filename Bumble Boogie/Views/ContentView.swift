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
    
    @State private var scene: MainGameScene = {
        let scene = MainGameScene(size: CGSize(width: 800, height: 600))
        scene.scaleMode = .aspectFit
        scene.timeManager.startMasterTimer()
        return scene
    }()
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .frame(maxWidth: .infinity, maxHeight: 100)
            VStack {
                Text("Currency: \(gameState.TotalHoney)")
                    .font(.custom("Bloxic", size: 28))
                Text("spawnRate: \(scene.timeManager.basicBeeSpawnInterval)")
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
                
                
                VStack {
                    Button("+ SpawnRate"){
                        scene.timeManager.increaseBasicBeeSpawnRate()
                    }
                    Button("Pause") {
                        scene.pauseScene()
                    }
                    Button("Resume") {
                        scene.resumeScene()
                    }
                    Button("- SpawnRate"){
                        scene.timeManager.decreaseBasicBeeSpawnRate()
                    }
                    Button("stop"){
                        scene.timeManager.stopMasterTimer()
                    }
                    Button("start"){
                        scene.timeManager.startMasterTimer()
                    }
                    
                    
                }
                .padding(.horizontal, 24.0)
                
                
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
