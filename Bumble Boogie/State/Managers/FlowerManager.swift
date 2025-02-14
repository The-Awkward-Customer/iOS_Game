//
//  FlowerManager.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 13/02/2025.
//

import Foundation
import SpriteKit

class FlowerManager {
    
    private let scene: SKScene
    private let gridManager: GridManager
    private var spawnTimer: Timer?
    private var activeFlowers: Set<FlowerNode> = []
    
    // Config
    private let maxActiveFlowers: Int = 3
    private let spawnInterval: TimeInterval = 5.0
    
    //MARK: - Init
    init(scene: SKScene, gridManager: GridManager){
        self.scene = scene
        self.gridManager = gridManager
    }
    
    //MARK: - Flower Manager
    func startSpawningFlowers(){
        spawnTimer = Timer.scheduledTimer(withTimeInterval: spawnInterval, repeats: true) { [ weak self] _ in
            self?.trySpawnFlower()
        }
    }
    
    func stopSpawingFlowers(){
        spawnTimer?.invalidate()
        spawnTimer = nil
    }
    
    func trySpawnFlower(){
        guard activeFlowers.count < maxActiveFlowers else {
            print ("Max flowerd reached \(maxActiveFlowers)")
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
    
    private func scheduleFlowerRemoval(_ flower: FlowerNode) {
        // Remove flower after 10 seconds if not collected
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [weak self] in
            guard let self = self else { return }
            
            if self.activeFlowers.contains(flower) {
                self.removeFlower(flower)
            }
        }
        
        // Add debug info
            var debugInfo: String {
                """
                Active Flowers: \(activeFlowers.count)
                Max Flowers: \(maxActiveFlowers)
                Spawn Interval: \(spawnInterval)s
                Timer Active: \(spawnTimer?.isValid == true)
                """
            }
    }
    
    private func removeFlower(_ flower: FlowerNode) {
        activeFlowers.remove(flower)
        
        // Release the spawn point
        if let spawnPoint = flower.spawnPoint {
            gridManager.releasePoint(spawnPoint)
        }
        
        // Animate removal
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.removeFromParent()
        flower.run(SKAction.sequence([fadeOut, remove]))
    }
    
    // MARK: - Cleanup
    func cleanup() {
        stopSpawingFlowers()
        activeFlowers.forEach { removeFlower($0) }
        activeFlowers.removeAll()
        
    }
}
