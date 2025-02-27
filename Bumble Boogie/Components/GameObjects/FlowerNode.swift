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
    case verticalBoost
    case slowEffect
    
    var duration: TimeInterval {
        switch self {
        case .speedBoost:
            return 5
        case .honeyMultiplier:
            return 10
        case .verticalBoost:
            return 3
        case .slowEffect:
            return 7
        }
    }
    
    var description: String {
        switch self {
        case .speedBoost:
            return "Speed Boost"
        case .honeyMultiplier:
            return "x2 Honey"
        case .verticalBoost:
            return "Vertical Boost"
        case .slowEffect:
            return "Slow Down"
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
    
    // Track bees with active effects applied
    private var affectedBees: [ObjectIdentifier: PowerUpType] = [:]
    
    
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
        physicsBody = SKPhysicsBody(circleOfRadius: size.width * 0.4)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsCategory.powerup
        physicsBody?.contactTestBitMask = PhysicsCategory.bee
        
        // Set collision mask to 0 to prevent physical collision interactions
        // This allows us to handle the physics response programmatically
        physicsBody?.collisionBitMask = 0
    }
    
    func setupVisuals() {
        let textureName: String
        
        switch powerUpType {
        case.speedBoost:
            textureName = "powerupflower_1"
        case.honeyMultiplier:
            textureName = "powerupflower_2"
        case.verticalBoost:
            textureName = "powerupflower_3"
        case.slowEffect:
            textureName = "powerupflower_4"
        }
        
        let newTexture = SKTexture(imageNamed: textureName)
        self.texture = newTexture
        
        
        // Add pulsing animation
               let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
               let scaleDown = SKAction.scale(to: 0.9, duration: 0.5)
               let sequence = SKAction.sequence([scaleUp, scaleDown])
               run(SKAction.repeatForever(sequence), withKey: "pulseAnimation")

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
        
        print("_Collision with flower handled - Powerup: \(powerUpType)")
        
        GameFeedbackManager.shared.trigger(.beeTapped, at: position)
        
        // Apply PowerUpEffect to bee
        applyPowerUpEffect(to: bee)
        
        // Track affected bees
        let beeId = ObjectIdentifier(bee)
        affectedBees[beeId] = powerUpType
        
        // Animate collection
        animateCollection()
    }
    
    private func applyPowerUpEffect(to bee: BasicBeeSprite) {
        
        guard let physicsBody = bee.physicsBody else {
            print("WARNING: Could not apply powerup effect to bee as it has no physics body!")
            return
        }
        
        switch powerUpType {
        case .speedBoost:
            // horizontal speed boost
            bee.physicsBody?.velocity.dx *= 1.5
            
        case .honeyMultiplier:
            // Apply honey multiplier effect
            bee.setHoneyMultiplier(2.0)
            print("Honey multiplier applied - will return 2x honey when tapped")
            
        case .verticalBoost:
            // New: Boost vertical momentum by 150%
            let currentVelocity = physicsBody.velocity.dy
            physicsBody.velocity.dy = currentVelocity * 1.5
            print("Vertical boost applied: \(currentVelocity) -> \(physicsBody.velocity.dy)")
                        
            
        case .slowEffect:
            // New: Slow down effect (50% reduction)
            physicsBody.velocity.dy *= 0.5
            print("Slow effect applied: Speed reduced by 50%")
                        
        }
        
        let beeId = ObjectIdentifier(bee)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self, weak bee] in
            guard let self = self, let bee = bee else { return }
            self.removePowerUpEffect(from: bee)
            self.affectedBees.removeValue(forKey: beeId)
        }
    }
    
    
    private func removePowerUpEffect(from bee: BasicBeeSprite?) {
        
        guard let bee = bee else {
            print("Warning: Bee is nil when trying to remove power-up effect")
            return
        }
        
        // Get bee identifier
        let beeId = ObjectIdentifier(bee)
        
        // Check if the bee exists in affected bees dictionary
        guard let powerUp = affectedBees[beeId] else { return }
        
        // Safely unwrap physics body
        guard let physicsBody = bee.physicsBody else {
            print("WARNING: Could not remove powerup effect from bee as it has no physics body!")
            return
        }
        

        switch powerUp {
        case .speedBoost:
            physicsBody.velocity.dx /= 1.5
            
        case .honeyMultiplier:
            bee.setHoneyMultiplier(10.0)
            print("Honey multiplier removed")
            
        case .verticalBoost:
            // No need to revert velocity as it's a one-time boost
            print("Vertical boost effect duration ended")
            
        case .slowEffect:
            // Restore normal speed (assuming original was 2x current)
            physicsBody.velocity.dy *= 2.0
            print("Slow effect removed, speed restored")
            bee.setPoweredUp(true)  // Restore visual
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
