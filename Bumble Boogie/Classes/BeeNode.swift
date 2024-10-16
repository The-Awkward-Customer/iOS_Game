//
//  BeeNode.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 12/10/2024.
//


//NOTES:
//assignedValue: An integer property that holds the random value assigned to each bee.
//Initializer:
//init(assignedValue: Int): Custom initializer that accepts an assignedValue.
//imageName: Constructs the image name based on the assignedValue (e.g., "beeImage1").
//texture: Loads the texture using the image name.
//super.init: Calls the superclass initializer with the texture.
//self.name: Sets the name of the node to "bee" for identification in touch events.
//required init?(coder:): Required initializer for cases where you might decode the object from a file (not used here).

import SpriteKit

class BeeNode: SKSpriteNode {
    
    // MARK: - Properties
    
    // Property to store assigned value
    var assignedValue: Int
    
    // indicates if the bee has any unique behaviours for future use <UwU>
    var isSpecialBee: Bool = false
    
    // Placeholder for future properties
    var specialEffect: String?
    
    // MARK: - Initialization
    
    /// Initializes a new BeeNode with a given assigned value
    /// -parameter assignedValue: The value assigned to the bee, used to determine its apparence and matching logic
    init(assignedValue: Int) {
        self.assignedValue = assignedValue
        
        //determine image name based on assigned value
        let imageName = "beeImage\(assignedValue)"
        let texture = SKTexture(imageNamed: imageName)
        
        
        //call the designated init
        super.init(texture: texture, color: .clear, size: texture.size())
        
        //set the node's name for identification
        self.name = "bee"
    }
    
    //required init for decoding (if using archiving)
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mark: - Methods
    
    /// Handles the bees behavior when tapped
    func handleTap(){
        // Adds a tap animation: scales up then back down
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        let scaleSequence = SKAction.sequence([scaleUp,scaleDown])
        self.run(scaleSequence)
        
        // Add particle effect
        if let tapEffect = SKEmitterNode(fileNamed: "BeeTap") {
            tapEffect.position = CGPoint.zero
            tapEffect.zPosition = 1
            self.addChild(tapEffect)
            
            // Remove the particle effect after it completes
            let wait = SKAction.wait(forDuration: 3.0)
            let remove = SKAction.removeFromParent()
            tapEffect.run(SKAction.sequence([wait,remove]))
            
        }
    }
}
