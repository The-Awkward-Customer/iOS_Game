//
//  BasicBeeManager.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 19/02/2025.
//

import Foundation
import SpriteKit




class BeeManager {
    // MARK: - Properties
    private let scene: SKScene
    private let gameState: GameState
    private var activeBees: Set<BasicBeeSprite> = []
    private var pausedBees: [BasicBeeSprite: BeeState] = [:]
    private var pauseObserverId: UUID?
    
    
    init(scene: SKScene, gameState: GameState){
        self.scene = scene
        self.gameState = gameState
        
        
        setupCallbacks()
    }
    
    //MARK: - Private methods
    private func setupCallbacks() {
        // Bee Spawn Callback
        gameState.onBasicBeeSpawnIntervalTick = { [weak self] in
            self?.handleBeeSpawnEvent( )
        }
        
        pauseObserverId = UUID()
        GamePauseManager.shared.addPauseStateObserver { [ weak self ] isPaused in self?.handleBeeSpawnEvent()}
    }
    
    private func handleBeeSpawnEvent() {
        let beesToSpawn = max(1, gameState.hiveCount)
        
        for _ in 0..<beesToSpawn {
            let spawnPosition = getSpawnPosition()
            let basicBee = BasicBeeSprite(gameState: gameState, parentScene: scene)
            scene.addChild(basicBee)
            activeBees.insert(basicBee)
        }
        
    }
    
    private func getSpawnPosition() -> CGPoint {
        let horizontalMargin = scene.size.width * 0.1
        let safeXRange = horizontalMargin...(scene.size.width - horizontalMargin)
        let verticalOffset = -(scene.size.height * 0.1)
        
        return CGPoint(
            x: CGFloat.random(in: safeXRange),
            y: verticalOffset
        )
    }
    
    
    
    //MARK: - Pause handling
    private func handlePauseState(_ isPaused: Bool) {
        if isPaused {
            storeBeeStates()
            pauseAllBees()
        } else {
            resumeAllBees()
        }
    }
    
    private func storeBeeStates() {
        activeBees.forEach { bee in
            pausedBees[bee] = BeeState(bee: bee)
        }
    }
    
    
    private func pauseAllBees() {
        activeBees.forEach { bee in
            bee.pause()
        }
    }
    
    
    private func resumeAllBees() {
        pausedBees.forEach { bee, state in
            bee.resume(
                at: state.position,
                velocity: state.velocity,
                resumeAnimation: state.wasAnimating,
                resumeEmitter: state.emitterState)
        }
        pausedBees.removeAll()
    }
    
    
    
    //MARK: - Cleanup
    func cleanup() {
        activeBees.forEach { bee in
            bee.removeFromParent() }
        
        activeBees.removeAll()
        pausedBees.removeAll()
        
        if let observerId = pauseObserverId {
            GamePauseManager.shared.removePauseStateObservers(observerId)
            pauseObserverId = nil
        }
    }
}



//MARK: - Bee State
private struct BeeState {
    let position: CGPoint
    let velocity: CGVector
    let wasAnimating: Bool
    let emitterState: Bool
    
    init(bee: BasicBeeSprite) {
        self.position = bee.position
        if let physicsBody = bee.physicsBody {
            self.velocity = physicsBody.velocity
        } else {
            self.velocity = .zero
        }
        self.wasAnimating = bee.action(forKey: "beeAnimation") != nil
        self.emitterState = !(bee.trailEmitter?.isPaused ?? true)
    }
}
