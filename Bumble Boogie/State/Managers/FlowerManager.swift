//
//  FlowerManager.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 13/02/2025.
//

import Foundation
import SpriteKit

@MainActor
class FlowerManager {
    
    // MARK: - Properties
    private let scene: SKScene
    private let gridManager: GridManager
    private let gameState: GameState  // Store GameState reference
    private var activeFlowers: Set<FlowerNode> = []
    
    // Config
    private let maxConcurrentFlowers: Int
    private var pauseObserverId: UUID?
    
    // MARK: - Initialization
      init(scene: SKScene,
           gridManager: GridManager,
           gameState: GameState,
           maxConcurrentFlowers: Int = 5) {
          self.scene = scene
          self.gridManager = gridManager
          self.gameState = gameState
          self.maxConcurrentFlowers = maxConcurrentFlowers
          
          setupCallbacks()
      }
    
    private func setupCallbacks() {
        // Set the callback in GameState
        gameState.onFlowerSpawnIntervalTick = { [weak self] in
            print("Flower spawn interval ticked")
            self?.trySpawnFlower()
        }
        
        pauseObserverId = UUID()
        GamePauseManager.shared.addPauseStateObserver { [weak self] isPaused in
            self?.handlePauseState(isPaused)
        }
    }
    
    
    //MARK: - Flower management
    func trySpawnFlower() {
        
        cleanupInvalidFlowers()
        
        guard activeFlowers.count < maxConcurrentFlowers else {
            print("Max flowers reached \(maxConcurrentFlowers)")
            return
        }
        
        if let spawnPoint = gridManager.getRandomAvailableSpawnPoint() {
            let flower = createFlower(at: spawnPoint)
            activeFlowers.insert(flower)
            scene.addChild(flower)
            print("Flower spawned at \(spawnPoint.position)")
        } else {
            print("No available spawn points")
        }
    }
    
    
    private func createFlower(at spawnPoint: SpawnPoint) -> FlowerNode {
        let powerUpTypes: [PowerUpType] = [.speedBoost, .honeyMultiplier]
        let randomType = powerUpTypes.randomElement()!
        
        let flower = FlowerNode(powerUpType: randomType, lifeSpan: 3.0)
        flower.position = spawnPoint.position
        flower.spawnPoint = spawnPoint
        
        // Set up removal callback
        flower.onRemovalComplete = { [weak self] in
            self?.cleanupInvalidFlowers()
        }
        
        gridManager.occupySpawnPoint(spawnPoint, with: flower)
        
        return flower
    }
    
    
    // MARK: - Pause Handling
    private func handlePauseState(_ isPaused: Bool) {
        activeFlowers.forEach { flower in
            if isPaused {
                flower.pause()
            } else {
                flower.resume()
            }
        }
    }
    

    // MARK: - Cleanup
        func cleanup() {
            activeFlowers.forEach { flower in
                flower.removeFromParent()
                if let spawnPoint = flower.spawnPoint {
                    gridManager.releasePoint(spawnPoint)
                }
            }
            activeFlowers.removeAll()
            
            if let observerId = pauseObserverId {
                GamePauseManager.shared.removePauseStateObservers(observerId)
                pauseObserverId = nil
            }
        }
        
        private func cleanupInvalidFlowers() {
            activeFlowers = activeFlowers.filter { flower in
                if flower.parent == nil {
                    print("Removing invalid flower reference")
                    if let spawnPoint = flower.spawnPoint {
                        gridManager.releasePoint(spawnPoint)
                    }
                    return false
                }
                return true
            }
        }
        
        // MARK: - Debug
        var debugInfo: String {
            """
            Active Flowers: \(activeFlowers.count)
            Max Flowers: \(maxConcurrentFlowers)
            Currently Paused: \(gameState.isPaused)
            """
        }}
