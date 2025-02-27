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
    private(set) var trailEmitter: SKEmitterNode?
    private var debugMode: Bool = false
    
    private var honeyMultiplier: Double = 1.0
    
    private var isProcessingTouch: Bool = false
    
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
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        print("Animating bee")
    }
    
    private func setupParticles() {
        
        let emitter = SKEmitterNode()
        
        emitter.particleTexture = SKTexture(imageNamed: "drag")
        emitter.particleBirthRate = 4
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
    
    //MARK: - Powerup methods
    
    func setHoneyMultiplier(_ multiplier: Double) {
        honeyMultiplier = multiplier
        
        if multiplier > 1 {
            print("⚡️ Mutilpier triggered ⚡️")
        }
    }
    
    func applyVerticalBoost(factor: CGFloat = 1.5) {
        guard let physics = physicsBody else { return }
        
        physics.velocity.dy *= factor
        
        let originalScale = xScale
        let pusleAction = SKAction.sequence([
        SKAction.scale(to: originalScale * 1.2, duration: 0.1),
        SKAction.scale(to: originalScale, duration: 0.1)
        ])
        run(pusleAction)
    }
    
    func animateRemoval() {
        print("bee removed")
        self.removeAllActions()
        let scaleUpAction = SKAction.scale(to: self.xScale * 1.2, duration: 0.1)
        let scaleDownAction = SKAction.scale(to: 0.0, duration: 0.2)
        let removeAction = SKAction.run { [weak self] in
            self?.cleanUp()
        }
        
        let removalSequence = SKAction.sequence([scaleUpAction, scaleDownAction, removeAction])
        
        self.run(removalSequence)
    }
    
    
    
    //MARK: - For interactivity within the node
    override func touchesBegan (_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isProcessingTouch,
              let touch = touches.first,
              let scene = self.scene else { return }
        
        // Set flag
        isProcessingTouch = true
        
        //convert touch position into passable coordinates
        let touchPostionInNode = touch.location(in: self)
        let positionInScene = self.convert(touchPostionInNode, to: scene)
        
        print("bee touched at scene postion: \(positionInScene)")
        
        let baseHoney = 100
        let honeyReward = Int(Double(baseHoney) * honeyMultiplier)
        // adjust gamestate value
        gameState.increaseTotalHoney(by: honeyReward)
        
        // Show feedback with appropriate effect based on multiplier
                if honeyMultiplier > 1.0 {
                    // Special feedback for multiplier effect
                    let specialFeedback = SKLabelNode(text: "+\(honeyReward)")
                    specialFeedback.fontColor = .orange
                    specialFeedback.fontSize = 18
                    specialFeedback.position = CGPoint(x: 0, y: size.height/2)
                    addChild(specialFeedback)
                    
                    let moveUp = SKAction.moveBy(x: 0, y: 30, duration: 0.5)
                    let fade = SKAction.fadeOut(withDuration: 0.5)
                    let remove = SKAction.removeFromParent()
                    specialFeedback.run(SKAction.sequence([SKAction.group([moveUp, fade]), remove]))
                }
        
        
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
        isProcessingTouch = false
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
        case PhysicsCategory.powerup:
            handlePowerUpContact(with: node)
        default:
            break
        }
    }
 
    
    private func handlePowerUpContact(with node: SKNode) {
        if let flower = node as? FlowerNode {
            flower.handleBeeCollision(with: self)
        }
    }
    
}

//MARK: - pause extension
extension BasicBeeSprite {
    func pause() {
        // store current state
        physicsBody?.velocity = .zero
        removeAction(forKey: "oscillation")
        removeAction(forKey: "beeAnimation")
        trailEmitter?.isPaused = true
    }
    
    
    func resume(at position: CGPoint,
                velocity: CGVector,
                resumeAnimation: Bool,
                resumeEmitter: Bool) {
        //restore state
        self.position = position
        physicsBody?.velocity = velocity
        
        if resumeAnimation {
            setupAnimations()
        }
        
        
        setupOscilation()
        
        trailEmitter?.isPaused = !resumeEmitter
        
    }
}
