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
    
    private var lastSpawnTime: TimeInterval = 0
    private let minTimeBetweenSpawns: TimeInterval = 0.5
    private var flowerSpawnQueue: Int = 0
    
    // For task cancellation
    private var spawnProcessingTask: Task<Void, Never>? = nil
    
    //debug vars
    private var tickCount = 0
    
    // MARK: - Initialization
    init(scene: SKScene,
         gridManager: GridManager,
         gameState: GameState,
         maxConcurrentFlowers: Int) {
        self.scene = scene
        self.gridManager = gridManager
        self.gameState = gameState
        self.maxConcurrentFlowers = maxConcurrentFlowers
        
        setupCallbacks()
    }
    
    private func setupCallbacks() {
        // Set the callback in GameState
        gameState.onFlowerSpawnIntervalTick = { [weak self] in
            guard let self = self else { return }
            self.tickCount += 1
            print("🌸 Flower spawn interval ticked (#\(self.tickCount))")
            self.queueFlowerSpawn()
        }
        
        pauseObserverId = UUID()
        GamePauseManager.shared.addPauseStateObserver { [weak self] isPaused in
            self?.handlePauseState(isPaused)
        }
        
        setupSpawnProcessing()
    }
    
    
    private func setupSpawnProcessing() {
        /// creates a repeating task on the main actor to process the queue
        spawnProcessingTask = Task {
            while !Task.isCancelled {
                processFlowerSpawnQueue()
                try? await Task.sleep(nanoseconds: 500_000_000 ) // 0.5 seconds
            }
        }
    }
    
    // MARK: - Flower Spawning System
    
    // Queue a flower spawn when a tick happens
    private func queueFlowerSpawn() {
        let spaceAvailable = maxConcurrentFlowers - activeFlowers.count
        if spaceAvailable > 0 {
            let flowersToQueue = spaceAvailable
            flowerSpawnQueue += flowersToQueue
            print ("max concurrent flowers is \(maxConcurrentFlowers)")
            print("🌸 Queued \(flowersToQueue) flowers, queue size: \(flowerSpawnQueue), active flowers: \(activeFlowers.count)")
        } else {
            print("🌸 Max flowers reached, not queing any more")
        }
    }
    
    private func processFlowerSpawnQueue() {
        guard !gameState.isPaused && flowerSpawnQueue > 0  else { return }
        
        let currentTime = CACurrentMediaTime()
        if currentTime - lastSpawnTime >= minTimeBetweenSpawns {
            spawnSingleFlower()
            flowerSpawnQueue -= 1
            print("🌸 Processed queue: remaining in queue: \(flowerSpawnQueue)")
        }
    }
    
    
    //MARK: - Flower management
    
    private func spawnSingleFlower() {
        
        cleanupInvalidFlowers( )
        
        guard activeFlowers.count < maxConcurrentFlowers else {
            print ("Max flowers reached \(maxConcurrentFlowers)")
            return
        }
        
        if let spawnPoint = gridManager.getRandomAvailableSpawnPoint() {
            let flower = createFlower(at: spawnPoint)
            activeFlowers.insert(flower)
            scene.addChild(flower)
            lastSpawnTime = CACurrentMediaTime()
            print( "Flower spawned at \(spawnPoint.position), total active: \(activeFlowers.count)" )
        } else {
            print( "No available spawn points" )
        }
    }
    
    
    func trySpawnFlowers() {
        
        queueFlowerSpawn()
    }
    
    
    private func createFlower(at spawnPoint: SpawnPoint) -> FlowerNode {
        let powerUpTypes: [PowerUpType] = [.speedBoost, .honeyMultiplier]
        let randomType = powerUpTypes.randomElement()!
        
        let flower = FlowerNode(powerUpType: randomType, lifeSpan: gameState.progress.flowerLifespan)
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
                // Cancel any ongoing spawn tasks
                spawnProcessingTask?.cancel()
                spawnProcessingTask = nil
                
                activeFlowers.forEach { flower in
                    flower.removeFromParent()
                    if let spawnPoint = flower.spawnPoint {
                        gridManager.releasePoint(spawnPoint)
                    }
                }
                activeFlowers.removeAll()
                
                if let ObserverId = pauseObserverId {
                    GamePauseManager.shared.removePauseStateObservers(ObserverId)
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
