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
    
    @EnvironmentObject var gameTimeManager: GameTimeManager
    
    @State private var scene: MainGameScene = {
        let scene = MainGameScene(size: CGSize(width: 800, height: 600))
        scene.scaleMode = .aspectFit
        return scene
    }()
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .frame(maxWidth: .infinity, maxHeight: 100)
            VStack {
                Text("Currency: \(gameState.TotalHoney)")
                    .font(.custom("Bloxic", size: 28))
                Text("spawnRate: \(gameTimeManager.basicBeeSpawnInterval, specifier: "%.1f")")
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
        
        .environmentObject(gameState)
        .onAppear {
                    // Assign the environment’s manager to the scene, so the scene can reference it
                    scene.gameTimeManager = gameTimeManager
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(gameState: GameState())
            .environmentObject(GameTimeManager())
    }
}
