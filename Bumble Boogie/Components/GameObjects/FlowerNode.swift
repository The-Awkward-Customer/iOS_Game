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
    private(set) var remainingLifespan: TimeInterval = 3.00
    private var isCollected: Bool = false
    private(set) var isPulsing: Bool = false
    private var removalScheduled: Bool = false
    
    var onRemovalComplete: (() -> Void)?
    
    
    //MARK: - Init
    init(powerUpType: PowerUpType, size: CGSize = CGSize(width: 40, height: 40)){
        self.powerUpType = powerUpType
        self.duration = powerUpType.duration
        
        //init with placeholder texture
        let SKTexture = SKTexture(imageNamed: "flower")
        super.init(texture: SKTexture, color: .clear, size: size)
        
        setupPhysics()
        setupVisuals()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    private func setupPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width * 0.1)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsCategory.powerup
        physicsBody?.contactTestBitMask = PhysicsCategory.bee
        physicsBody?.collisionBitMask = 0
    }
    
    
    func setupVisuals(restartPulsing: Bool = true) {
        if restartPulsing {
            isPulsing = true
            // Add a subtle pulsing animation
            let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
            let scaleDown = SKAction.scale(to: 0.9, duration: 0.5)
            let sequence = SKAction.sequence([scaleUp, scaleDown])
            run(SKAction.repeatForever(sequence), withKey: "pulseAnimation")
            
        }
        
        
        if !children.contains(where: { $0 is SKEffectNode }) {
            let glowNode = SKEffectNode()
            glowNode.shouldRasterize = true
            glowNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": 2.0])
            addChild(glowNode)
        }
    }
    
    func pauseAnimations() {
           isPulsing = action(forKey: "pulseAnimation") != nil
           removeAllActions()
       }
       
       func resumeAnimations() {
           if isPulsing {
               setupVisuals(restartPulsing: true)
           }
           
           // If removal was scheduled, reschedule it with remaining time
           if removalScheduled && remainingLifespan > 0 {
               scheduleRemoval(after: remainingLifespan)
           }
       }
       
    func scheduleRemoval(after timeInterval: TimeInterval) {
            removalScheduled = true
            remainingLifespan = timeInterval
            
            removeAllActions()  // Clear any existing removal schedules
            
            let wait = SKAction.wait(forDuration: timeInterval)
            let remove = SKAction.run { [weak self] in
                self?.animateCollection()
                self?.onRemovalComplete?()
            }
            
            run(SKAction.sequence([wait, remove]), withKey: "removalSequence")
        }
       
       func updateRemainingLifespan() {
           if let action = action(forKey: "removalSequence") {
               remainingLifespan = action.duration
           }
       }
   
    
    //MARK: - Collision handling
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            [weak bee] in
            self.removePowerUpEffect(from: bee)
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
            if let particleEmitter = SKEmitterNode(fileNamed: "FlowerCollected") {
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
            }
        }
    }
    
    


