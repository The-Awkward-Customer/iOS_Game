//
//  BasicBee.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 14/01/2025.
//

import Foundation
import SwiftUI
import SpriteKit

// MARK: - PhysicsCategories
struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let bee       : UInt32 = 0b1
    static let obstacle  : UInt32 = 0b10
    static let powerup   : UInt32 = 0b100
    static let boundary  : UInt32 = 0b1000
}


class BasicBeeSprite : SKSpriteNode{
    
    //MARK: - properties
    var gameState: GameState
    
    private let oscilationAmplitude: CGFloat
    private let oscilationDuration: TimeInterval
    private let verticalSpeed: CGFloat
    private var trailEmitter: SKEmitterNode?
    private var debugMode: Bool = false
    
    //MARK: - Animation properties
    private var spriteFrames: [SKTexture] = []
    
    
    //MARK: - Intisalizion
    init (gameState: GameState, parentScene: SKScene, debugMode: Bool = false) {
        self.gameState = gameState
        self.debugMode = debugMode
        self.oscilationAmplitude = CGFloat.random(in: 20...50)
        self.oscilationDuration = TimeInterval.random(in: 1.0...2.5)
        
        self.verticalSpeed = BasicBeeSprite.calculateIntialSpeed(gameState: gameState)
        
        // Set default init texture
        let texture = SKTexture(imageNamed: "basicBee.00000")
        let size = CGSize(width: 64, height: 64)
        
        
        super.init(texture: texture, color: .clear, size: size)
        
        
        setupSprite(in: parentScene)
        setupPhysics()
        setupAnimations()
        setupParticles()
        
        if debugMode {
            visualizePhysicsBody()
        }
        
        
        // Optionally, enable interactivity if using touch methods in the node
         self.isUserInteractionEnabled = true
        
        // runActions()
        
        
    }
    
    private static func calculateIntialSpeed(gameState: GameState) -> CGFloat {
        
        // Base speed range
        let minBaseSpeed: CGFloat = 100
        let maxBaseSpeed: CGFloat = 250
        
        // optional modifier for later
        //let speedMultiplier = min(1.0 + (Double(gameState.hiveCount) * 0.1), 2.0) // caps at 2x speed
        //        
        //let adjustedMinSpeed = minBaseSpeed * CGFloat(speedMultiplier)
        //let adjustedMaxSpeed = maxBaseSpeed * CGFloat(speedMultiplier)
        
        return CGFloat.random(in: minBaseSpeed...maxBaseSpeed)
        
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setup methods
    
    private func setupSprite(in parentScene: SKScene) {
        name = "bee"
        zPosition = 10
        let xPos = CGFloat.random(in: size.width...(parentScene.size.width - size.width))
        position = CGPoint(x: xPos, y: -size.height)
    }
    
    private func setupPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width * 0.1)
        guard let physics = physicsBody else { return }
        
        physics.isDynamic = true
        physics.affectedByGravity = false
        physics.allowsRotation = false
        physics.mass = 0.1
        physics.linearDamping = 0.1
        
        
        physics.categoryBitMask = PhysicsCategory.bee
        physics.collisionBitMask = PhysicsCategory.obstacle
        physics.contactTestBitMask = PhysicsCategory.obstacle | PhysicsCategory.powerup
        
        
        physics.velocity = CGVector(dx: 0, dy: verticalSpeed)
        
        setupOscilation()
        setupBoundryCheck()
        
    }
    
    /// ocillates bee
    private func setupOscilation() {
        
        let oscillateRight = SKAction.moveBy(x: oscilationAmplitude, y: 0, duration: oscilationDuration)
        let oscillateLeft = oscillateRight.reversed()
        let sequence = SKAction.sequence([oscillateRight, oscillateLeft])
        run(SKAction.repeatForever(sequence), withKey: "oscillation")
        
    }
    
    /// removes bee from scene once boundry is breached
    private func setupBoundryCheck() {
        let check = SKAction.run { [weak self] in
            guard let self = self,
                let scene = self.scene else { return }
            
            if self.position.y > scene.size.height + self.size.height {
                self.removeFromParent()
                print("boundry detected & bee removed")
            }
        }
        
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 0.01),
            check
        ])),withKey: "boundryCheck")
        

    }
    
    
    private func setupAnimations() {
        spriteFrames = (0...60).map { index in
            SKTexture(imageNamed: String(format: "basicBee.%05d", index))
        }
        
        let animation = SKAction.animate(with: spriteFrames, timePerFrame: 0.1)
        run(SKAction.repeatForever(animation), withKey: "beeAnimation")
    }
    
    private func setupParticles() {
        
        let emitter = SKEmitterNode()
        
        emitter.particleTexture = SKTexture(imageNamed: "Pollen")
                emitter.particleBirthRate = 20
                emitter.numParticlesToEmit = 0
                
                emitter.particleColor = .yellow
                emitter.particleAlpha = 0.3
                emitter.particleAlphaRange = 0.2
                emitter.particleScale = 0.5
                emitter.particleScaleRange = 0.1
                
                emitter.particleLifetime = 0.5
                emitter.particleLifetimeRange = 0.2
                emitter.particleSpeed = 10
                emitter.particleSpeedRange = 5
                emitter.emissionAngle = .pi * 1.5
                emitter.emissionAngleRange = .pi / 8
                
                emitter.targetNode = self
                emitter.position = CGPoint(x: 0, y: -size.height/2)
                
                trailEmitter = emitter
                addChild(emitter)
        
    }
    
    // Optional: Add method to adjust particle effect based on speed
//        private func updateParticleEffects() {
//            let speedRatio = (verticalSpeed - 100) / 100 // Normalized to 0-1 range
//            trailEmitter?.particleBirthRate = 20 + (20 * speedRatio)
//            trailEmitter?.particleSpeed = 10 + (5 * speedRatio)
//        }
    
    
    func animateRemoval() {
        
            print("bee removed")
            self.removeAllActions()
            let scaleUpAction = SKAction.scale(to: self.xScale * 1.2, duration: 0.1)
            let scaleDownAction = SKAction.scale(to: 0.0, duration: 0.2)
            let removeAction = SKAction.removeFromParent()
            let removalSequence = SKAction.sequence([scaleUpAction, scaleDownAction, removeAction])
        
            self.run(removalSequence)
        }
    
    
    
    //MARK: - For interactivity within the node
    override func touchesBegan (_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              let scene = self.scene else { return }
        
        //convert touch position into passable coordinates
        let touchPostionInNode = touch.location(in: self)
        let positionInScene = self.convert(touchPostionInNode, to: scene)
        
        print("bee touched at scene postion: \(positionInScene)")
        
        // adjust gamestate value
        gameState.increaseTotalHoney(by: 100)
        
        GameFeedbackManager.shared.trigger(.beeTapped, at: positionInScene)
        
        animateRemoval()
        
    }
    
    
    //MARK: - Debug Methods
    private func visualizePhysicsBody() {
        let shape = SKShapeNode(circleOfRadius: size.width * 0.3)
        shape.strokeColor = .red
        shape.lineWidth = 2
        addChild(shape)
        
    }
    
    
    //MARK: - Public Methods
    // TODO
    func adjustForGyroscope(tilt: CGFloat){
        position.x += tilt * 10
    }
    
    func setPoweredUp(_ isPowered: Bool) {
        trailEmitter?.particleColor = isPowered ? .orange : .yellow
        trailEmitter?.particleBirthRate = isPowered ? 40 : 20
        trailEmitter?.particleAlpha = isPowered ? 0.8 : 0.3
    }
    
    func cleanUp() {
        removeAllActions()
        trailEmitter?.removeFromParent()
        removeFromParent()
    }
    
}





//MARK: - Contact Handler Extension
extension BasicBeeSprite{
    
    func handleContact(with node: SKNode) {
        guard let category = node.physicsBody?.categoryBitMask else { return }
        
        switch category {
        case PhysicsCategory.obstacle:
            handleObsticleContact()
        case PhysicsCategory.powerup:
            handlePowerUpContact()
        default:
            break
        }
    }
    
    private func handleObsticleContact() {
        
        //TODO
        
    }
    
    private func handlePowerUpContact() {
        // TODO
    }

}

