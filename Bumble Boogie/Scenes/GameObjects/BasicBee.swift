//
//  BasicBee.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 14/01/2025.
//

import Foundation
import SpriteKit



class BasicBeeSprite : SKSpriteNode{
    
    //MARK: - Intisalisation of BasicBeeSprite
    init () {
        // Initialize with a default texture (first frame of the bee animation)
        let texture = SKTexture(imageNamed: "basicBee.00000")
        super.init(texture: texture, color: .clear, size: CGSize(width: 64, height: 64))
        
        // Optionally, enable interactivity if using touch methods in the node
        self.isUserInteractionEnabled = true
        
        runActions()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
                self.isUserInteractionEnabled = true
                runActions()
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
    
    //MARK: - For interactivity within the node
    override func touchesBegan (_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("bee touched")
        
        // guard let touch = touches.first else { return }
        // let location = touch.location(in: self)
        //
        // if let node = nodes(at: location).first {
            
        // }
    }
    
    
    

    
}
