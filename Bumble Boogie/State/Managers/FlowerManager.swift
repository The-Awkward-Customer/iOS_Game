//
//  FlowerManager.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 13/02/2025.
//

import Foundation
import SpriteKit

class FlowerManager {
    
    private struct FlowerState {
        let position: CGPoint
        let isPulsing: Bool
        let remainingLifespan: TimeInterval
    }
    
    private var isPaused: Bool = false // bool
    private var activeFlowers: Set<FlowerNode> = [] // array
    private var pausedFlowerStates: [FlowerNode: FlowerState] = [:] // dictionary
    
        
    private let scene: SKScene
    private let gridManager: GridManager
    private var spawnTimer: Timer?
   
    
    // Config
    private let maxConcurrentFlowers: Int
    private let spawnInterval: TimeInterval
    
    
    //MARK: - Init
    init(scene: SKScene, gridManager: GridManager, maxConcurrentFlowers: Int, spawnInterval: TimeInterval){
        self.scene = scene
        self.gridManager = gridManager
        self.maxConcurrentFlowers = maxConcurrentFlowers
        self.spawnInterval = spawnInterval
        
        
        GamePauseManager.shared.addPauseStateObserver { [ weak self] isPaused in
            self?.handlePauseState(isPaused)
        }
    }
    
    //MARK: - Flower Manager
    func startSpawningFlowers(){
        guard !isPaused else { return }
        
        spawnTimer = Timer.scheduledTimer(withTimeInterval: spawnInterval, repeats: true) { [ weak self] _ in
            self?.trySpawnFlower()
        }
    }
    
    func stopSpawingFlowers(){
        spawnTimer?.invalidate()
        spawnTimer = nil
    }
    
    func trySpawnFlower(){
        guard !isPaused else { return }
        
        // Clean up any invalid flowers first
        cleanupInvalidFlowers()
        
        guard activeFlowers.count < maxConcurrentFlowers else {
            print ("Max flowerd reached \(maxConcurrentFlowers)")
            return
        }
        
        if let spawnPoint = gridManager.getRandomAvailableSpawnPoint(){
            let flower = createFlower(at: spawnPoint)
            activeFlowers.insert(flower)
            scene.addChild(flower)
            print ("Flower spawned at \(spawnPoint.position)")
            
            // Scheduale removal
            scheduleFlowerRemoval(flower)
        } else {
            print ("no available spawn points")
        }
    }
    
    
    
    //MARK: - Pause Handling
    private func handlePauseState(_ isPaused: Bool){
        self.isPaused = isPaused
        
        if isPaused {
            storeFlowerStates()
            pauseAllFlowers()
            spawnTimer?.invalidate()
            spawnTimer = nil
        } else {
            restoreFlowerStates()
            startSpawningFlowers()
        }
    }
    
    private func storeFlowerStates() {
        pausedFlowerStates.removeAll()
        
        for flower in activeFlowers {
            flower.updateRemainingLifespan()
            pausedFlowerStates[flower] = FlowerState(
                position: flower.position,
                isPulsing: flower.isPulsing,
                remainingLifespan: flower.remainingLifespan
            )
            flower.pauseAnimations()
        }
    }
    
    
    private func pauseAllFlowers(){
        for flower in activeFlowers {
            flower.removeAllActions()
        }
    }
    
    private func restoreFlowerStates(){
        for (flower, state) in pausedFlowerStates {
            flower.position = state.position
            flower.resumeAnimations()
            
                  // Reschedule removal if needed
                  if state.remainingLifespan > 0 {
                      flower.scheduleRemoval(after: state.remainingLifespan)
                  }
              }
              pausedFlowerStates.removeAll()
          }
    
    private func scheduleFlowerRemoval(_ flower: FlowerNode) {
            // Set up completion handler to ensure proper cleanup
            flower.onRemovalComplete = { [weak self] in
                self?.cleanupInvalidFlowers()
            }
            flower.scheduleRemoval(after: 3.0)
        }
    
    

    
    
    
    private func createFlower(at spawnPoint: SpawnPoint) -> FlowerNode {
        // Randomly select a power-up type
        let powerUpTypes: [PowerUpType] = [.speedBoost, .honeyMultiplier]
        let randomType = powerUpTypes.randomElement()!
        
        let flower = FlowerNode(powerUpType: randomType)
        flower.position = spawnPoint.position
        flower.spawnPoint = spawnPoint
        
        // Mark spawn point as occupied
        gridManager.occupySpawnPoint(spawnPoint, with: flower)
        
        return flower
    }
    
    private func removeFlower(_ flower: FlowerNode) {
            activeFlowers.remove(flower)
            
            // Release the spawn point
            if let spawnPoint = flower.spawnPoint {
                gridManager.releasePoint(spawnPoint)
            }
            
            // Animate removal and ensure cleanup
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let remove = SKAction.run { [weak self] in
                flower.removeFromParent()
                self?.cleanupInvalidFlowers()
            }
            
            flower.run(SKAction.sequence([fadeOut, remove]))
            print("Flower removed. Active count: \(activeFlowers.count)/\(maxConcurrentFlowers)")
        }
    
        // MARK: - Cleanup
        func cleanup() {
            stopSpawingFlowers()
            pausedFlowerStates.removeAll()
            activeFlowers.forEach { removeFlower($0) }
            activeFlowers.removeAll()
            GamePauseManager.shared.removePauseStateObservers()
    
        }
    
    private func cleanupInvalidFlowers() {
            // Remove any flowers that are no longer in the scene
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
    

        
        // Add debug info
            var debugInfo: String {
                """
                Active Flowers: \(activeFlowers.count)
                Max Flowers: \(maxConcurrentFlowers)
                Spawn Interval: \(spawnInterval)s
                Timer Active: \(spawnTimer?.isValid == true)
                """
            }
    }
    
    


