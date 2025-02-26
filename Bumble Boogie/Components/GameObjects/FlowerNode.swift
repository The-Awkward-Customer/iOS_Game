//
//  FlowerNode.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 13/02/2025.
//

import Foundation
import SpriteKit

//MARK: - PowerUpType
enum PowerUpType: String, Codable {
    case speedBoost
    case honeyMultiplier
    
    var duration: TimeInterval {
        switch self {
        case .speedBoost:
            return 5
        case .honeyMultiplier:
            return 10
        }
    }
    
    var description: String {
        switch self {
        case .speedBoost:
            return "Speed Boost"
        case .honeyMultiplier:
            return "x2 Honey"
        }
    }
}

// MARK: - Flower node
class FlowerNode: SKSpriteNode {
    
    //MARK: - Properties
    let powerUpType: PowerUpType
    weak var spawnPoint: SpawnPoint?
    let duration: TimeInterval
    private var isCollected: Bool = false
    private(set) var isPulsing: Bool = false
    private var lifespanRemaining: TimeInterval
    
    var onRemovalComplete: (() -> Void)?
    
    
    //MARK: - Init
    init(powerUpType: PowerUpType, lifeSpan: TimeInterval, size: CGSize = CGSize(width: 80, height: 80)){
        print("Before super.init - lifeSpan: \(lifeSpan)")
        self.powerUpType = powerUpType
        self.duration = powerUpType.duration
        self.lifespanRemaining = lifeSpan
        
        //init with placeholder texture
        let SKTexture = SKTexture(imageNamed: "flower")
        super.init(texture: SKTexture, color: .clear, size: size)
        
        
        setupPhysics()
        setupVisuals()
        startLifespanTimer()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Setup
    private func setupPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width * 0.3)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsCategory.powerup
        physicsBody?.contactTestBitMask = PhysicsCategory.bee
        physicsBody?.collisionBitMask = 0
    }
    
    func setupVisuals() {
        // Add pulsing animation
               let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
               let scaleDown = SKAction.scale(to: 0.9, duration: 0.5)
               let sequence = SKAction.sequence([scaleUp, scaleDown])
               run(SKAction.repeatForever(sequence), withKey: "pulseAnimation")
               
               // Add glow effect
               let glowNode = SKEffectNode()
               glowNode.shouldRasterize = true
               glowNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": 2.0])
               addChild(glowNode)
    }
    
    private func startLifespanTimer() {
        let sequence = SKAction.sequence([
            SKAction.wait(forDuration: lifespanRemaining),
            SKAction.run { [weak self] in
                self?.animateCollection()
            }
        ])
        run(sequence, withKey: "lifespanTimer")
    }
    
    
    //MARK: - Pause / Resume support
    func pause() {
        isPulsing = action(forKey: "pulseAnimation") != nil
        
        if let waitAction = action(forKey: "lifespanTimer") {
            lifespanRemaining = waitAction.duration
        }
        removeAllActions()
    }

    func resume() {
        if isPulsing {
            let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
            let scaleDown = SKAction.scale(to: 0.9, duration: 0.5)
            let sequence = SKAction.sequence([scaleUp, scaleDown])
            run(SKAction.repeatForever(sequence), withKey: "pulseAnimation")
        }
        
        // Simply restart the lifespan timer
            let sequence = SKAction.sequence([
                SKAction.wait(forDuration: lifespanRemaining),
                SKAction.run { [weak self] in
                    self?.animateCollection()
                }
            ])
            run(sequence, withKey: "lifespanTimer")

    }
    
    
    func handleBeeCollision(with bee: BasicBeeSprite) {
        guard !isCollected else { return }
        isCollected = true
        
        print("_Collision with flower handled_")
        
        GameFeedbackManager.shared.trigger(.beeTapped, at: position)
        
        // Apply PowerUpEffect to bee
        applyPowerUpEffect(to: bee)
        
        // Animate collection
        animateCollection()
    }
    
    private func applyPowerUpEffect(to bee: BasicBeeSprite) {
        switch powerUpType {
        case .speedBoost:
            bee.physicsBody?.velocity.dx *= 1.5
            
        case .honeyMultiplier:
            print("Honey multiplier collected")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.removePowerUpEffect(from: bee)
        }
    }
    
    
    private func removePowerUpEffect(from bee: BasicBeeSprite?) {
        guard let bee = bee else { return }
        
        switch powerUpType {
        case .speedBoost:
            bee.physicsBody?.velocity.dx /= 1.5
            
        case .honeyMultiplier:
            print("Honey multiplier removed")
        }
        
    }
    
    private func animateCollection() {
        // Create particle effect
        if let particleEmitter = SKEmitterNode(fileNamed: "pollen") {
            particleEmitter.position = position
            scene?.addChild(particleEmitter)
            
            // Remove particle effect after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                particleEmitter.removeFromParent()
            }
        }
        
        // Animate flower collection
        let scaleUp = SKAction.scale(to: 1.3, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([scaleUp, fadeOut, remove])
        
        run(sequence) { [weak self] in
            if let spawnPoint = self?.spawnPoint {
                // Release the spawn point
                spawnPoint.setOccupied(false)
            }
            self?.onRemovalComplete?()
        }
    }
    
    
    
    // MARK: - Debug
    func getDebugInfo() -> String {
            """
            Position: \(position)
            PowerUp: \(powerUpType)
            Remaining Time: \(lifespanRemaining)
            Is Collected: \(isCollected)
            Is Pulsing: \(isPulsing)
            """
    }
}
