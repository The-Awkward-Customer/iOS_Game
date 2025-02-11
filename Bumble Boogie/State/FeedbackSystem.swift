//
//  FeedbackSystem.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 10/02/2025.
//

import Foundation
import SpriteKit


// MARK: - Feedback Types
enum FeedbackType {
    case beeTapped
    case hiveUpgrade
    // Add more as needed
}

// MARK: - Feedback Components Protocol
protocol FeedbackComponent: AnyObject {
    func trigger(for type: FeedbackType, at position: CGPoint?)
}

// MARK: - Particle Effects
class ParticleEffectLibrary {
    static let shared = ParticleEffectLibrary()
    
    private var cachedEmitters: [String: SKEmitterNode] = [:]
    
    func emitter(named name: String) -> SKEmitterNode {
        if let cached = cachedEmitters[name] {
            return cached.copy() as! SKEmitterNode
        }
        
        // Create and cache new emitter
        let emitter = createEmitter(named: name)
        cachedEmitters[name] = emitter
        return emitter.copy() as! SKEmitterNode
    }
    
    private func createEmitter(named name: String) -> SKEmitterNode {
        let emitter = SKEmitterNode()
        
        switch name {
        case "beeTapped":
            configureBeeTappedEmitter(emitter)
        case "hiveUpgrade":
            configureHiveUpgradeEmitter(emitter)
        default:
            configureDefaultEmitter(emitter)
        }
        
        return emitter
    }
    
    private func configureHoneyCollectEmitter(_ emitter: SKEmitterNode) {
        emitter.particleTexture = SKTexture(imageNamed: "Pollen")
        emitter.particleBirthRate = 30
        emitter.numParticlesToEmit = 15
        emitter.particleLifetime = 0.75
        emitter.particleColor = .yellow
        emitter.particleAlpha = 0.8
        emitter.particleScale = 0.4
        emitter.particleScaleRange = 0.2
        emitter.emissionAngle = 0
        emitter.emissionAngleRange = .pi * 2
        emitter.particleSpeed = 100
        emitter.particleSpeedRange = 50
        emitter.xAcceleration = 0
        emitter.yAcceleration = -150
    }
    
    private func configureBeeTappedEmitter(_ emitter: SKEmitterNode) {
        emitter.particleTexture = SKTexture(imageNamed: "honeyIcon")
        emitter.particleBirthRate = 30
        emitter.numParticlesToEmit = 15
        emitter.particleLifetime = 0.75
        emitter.particleColor = .yellow
        emitter.particleAlpha = 0.8
        emitter.particleScale = 0.4
        emitter.particleScaleRange = 0.2
        emitter.emissionAngle = 0
        emitter.emissionAngleRange = .pi * 2
        emitter.particleSpeed = 100
        emitter.particleSpeedRange = 50
        emitter.xAcceleration = 0
        emitter.yAcceleration = -150
    }
    
    private func configureHiveUpgradeEmitter(_ emitter: SKEmitterNode) {
        // Configure for hive upgrade effect
    }
    
    private func configureDefaultEmitter(_ emitter: SKEmitterNode) {
        // Basic default configuration
    }
}

// MARK: - Visual Feedback Component
class VisualFeedbackComponent: FeedbackComponent {
    weak var scene: SKScene?
    private let particleLibrary: ParticleEffectLibrary
    
    init(scene: SKScene, particleLibrary: ParticleEffectLibrary = .shared) {
        self.scene = scene
        self.particleLibrary = particleLibrary
    }
    
    func trigger(for type: FeedbackType, at position: CGPoint?) {
        guard let position = position, let scene = scene else { return }
        
        switch type {
        case .beeTapped:
            triggerBeeTappedEffect(at: position, in: scene)
        case .hiveUpgrade:
            triggerHiveUpgradeEffect(at: position, in: scene)
        }
    }
    
    private func triggerBeeTappedEffect(at position: CGPoint, in scene: SKScene) {
        let emitter = particleLibrary.emitter(named: "beeTapped")
        emitter.position = position
        scene.addChild(emitter)
        
        // Create a subtle expansion effect
        let expand = SKAction.scale(to: 1.5, duration: 0.2)
        let fade = SKAction.fadeOut(withDuration: 0.3)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([expand, fade, remove])
        
        emitter.run(sequence)
    }
    
    private func triggerHiveUpgradeEffect(at position: CGPoint, in scene: SKScene) {
        let emitter = particleLibrary.emitter(named: "hiveUpgrade")
        emitter.position = position
        scene.addChild(emitter)
        
        // Create a burst effect
        let burst = SKAction.group([
            SKAction.scale(to: 2.0, duration: 0.5),
            SKAction.fadeOut(withDuration: 0.5)
        ])
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([burst, remove])
        
        emitter.run(sequence)
    }
}

// MARK: - Haptic Feedback Component
class HapticFeedbackComponent: FeedbackComponent {
    func trigger(for type: FeedbackType, at position: CGPoint?) {
        switch type {
        case .beeTapped:
            HapticFeedbackManager.shared?.testCustomFeedback()
        case .hiveUpgrade:
            GenericHapticFeedback.lightImpact()
        }
    }
}

// MARK: - Game Feedback Manager
class GameFeedbackManager {
    static let shared = GameFeedbackManager()
    
    private var components: [FeedbackComponent] = []
    
    private init() {}
    
    func register(component: FeedbackComponent) {
        components.append(component)
    }
    
    func unregister(component: FeedbackComponent) {
        components.removeAll { $0 === component as AnyObject }
    }
    
    func trigger(_ type: FeedbackType, at position: CGPoint? = nil) {
        components.forEach { component in
            component.trigger(for: type, at: position)
        }
    }
}
