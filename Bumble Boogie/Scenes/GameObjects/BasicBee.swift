//
//  BasicBee.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 14/01/2025.
//

import Foundation
import SwiftUI
import SpriteKit



class BasicBeeSprite : SKSpriteNode{
    
    var gameState: GameState

    
    //MARK: - Intisalisation of BasicBeeSprite
    init (gameState: GameState) {
        self.gameState = gameState
        // Initialize with a default texture (first frame of the bee animation)
        let texture = SKTexture(imageNamed: "basicBee.00000")
        super.init(texture: texture, color: .clear, size: CGSize(width: 64, height: 64))
        
        // Optionally, enable interactivity if using touch methods in the node
        self.isUserInteractionEnabled = true
        
        runActions()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func runActions() {
        
        // Animate through sprite
        let frames: [SKTexture] = (00...60).map { index in
        // Create a zero-padded string like "00000", "00001", etc.
        let fileName = String(format: "basicBee.%05d", index)
        return SKTexture(imageNamed: fileName)
        }
        
        // Run repeating animation
        let animationAction = SKAction.animate(with: frames, timePerFrame: 0.01)
        let repeatForever = SKAction.repeatForever(animationAction)
        
        //Move Bee
        // (G.3) Optionally move or fade the bee
        // e.g., a float upward + remove
        let moveUp = SKAction.moveBy(x: 0, y: 100, duration: 5.0)
        let remove = SKAction.removeFromParent()
        let moveSequence = SKAction.sequence([moveUp, remove])
        
        // Groups actions into a single variable
        let groupedActions = SKAction.group([repeatForever, moveSequence])
        
        // Intializes SKAction
        self.run(groupedActions)
        print("running actions")

    }
    
    
    func animateRemoval() {
        // Stop any ongoing actions so they won't conflict with the removal animation.
        self.removeAllActions()
        
        // Create the actions:
        // 1. Scale up slightly.
        let scaleUpAction = SKAction.scale(to: self.xScale * 1.2, duration: 0.1)
        
        // 2. Scale down to 0 to simulate disappearing.
        let scaleDownAction = SKAction.scale(to: 0.0, duration: 0.2)
        
        // 3. Remove the bee from its parent.
        let removeAction = SKAction.removeFromParent()
        
        // Combine actions in sequence.
        let removalSequence = SKAction.sequence([scaleUpAction, scaleDownAction, removeAction])
        
        // Run the sequence.
        self.run(removalSequence)
    }
    
    //MARK: - For interactivity within the node
    override func touchesBegan (_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        gameState.increaseTotalHoney(by: 100)
            
        print("bee touched")
        

        HapticFeedbackManager.shared?.playRichHapticEnsemble()
        
      
        GenericHapticFeedback.heavyImpact()
        
        animateRemoval()
    }
    
    
    

    
}
