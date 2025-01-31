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
    
    // Computed property that creates and configures the scene using the environment objects.
    var scene: MainGameScene {
        let scene = MainGameScene(size: CGSize(width: 800, height: 600), gameState: gameState)
        scene.scaleMode = .aspectFill
        scene.gameTimeManager = gameTimeManager
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
                .onAppear {
                               // Inject the manager so the scene can set up the callback
                    scene.gameTimeManager = gameTimeManager
                           }
            VStack {
                Text("Currency: \(gameState.TotalHoney)")
                    .font(.custom("Bloxic", size: 28))
                Text("spawnRate: \(gameState.basicBeeSpawnInterval)")
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
                        gameTimeManager.increaseBasicBeeSpawnRate()
                    }
                    Button("Pause") {
                        gameTimeManager.pauseGame()
                    }
                    Button("Resume") {
                        gameTimeManager.resumeGame()
                    }
                    Button("- SpawnRate"){
                        gameTimeManager.decreaseBasicBeeSpawnRate()
                    }
                    Button("stop"){
                        gameTimeManager.stopMasterTimer()
                    }
                    Button("start"){
                        gameTimeManager.startMasterTimer()
                    }
                    
                    
                }
                .padding(.horizontal, 24.0)

                
            }
            
        }

//        .environmentObject(gameState)
        .onAppear {
                    // Assign the environment’s manager to the scene, so the scene can reference it before actions can occur…
        
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
