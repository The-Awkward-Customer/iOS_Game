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
    
    //Property to store assigned value
    var assignedValue: Int
    
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
}
