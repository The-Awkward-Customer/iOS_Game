//
//  BeeScene.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 11/10/2024.
//


import SpriteKit

protocol GameDelegate: AnyObject {
    func beeTapped()
}

class BeeScene: SKScene {
    
    
    weak var gameDelegate: GameDelegate?
    var spawnInterval: TimeInterval = 1.0
    
    
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.clear
        
        
        // Create the background node with your image
            let background = SKSpriteNode(imageNamed: "backgroundImage") // Replace with your image name

            // Calculate the scaling factors
            let widthRatio = size.width / background.texture!.size().width
            let heightRatio = size.height / background.texture!.size().height

            // Choose the scale factor to maintain the aspect ratio
            let scaleFactor = max(widthRatio, heightRatio) // Use 'min' for Aspect Fit

            // Apply the scale factor
            background.setScale(scaleFactor)

            // Center the background image
            background.position = CGPoint(x: size.width / 2, y: size.height / 2)
            background.zPosition = -1 // Ensure it appears behind other nodes

            // Add the background node to the scene
            addChild(background)
        
        
        startSpawningBees()
        
        // Observe hive count changes
        NotificationCenter.default.addObserver(self, selector: #selector(hiveCountChanged(_:)), name: .hiveCountChanged, object: nil)
    }
    
    
    
    func startSpawningBees() {
        removeAction(forKey: "spawning")
        let spawn = SKAction.run { [weak self] in
            self?.addBee()
        }
        let delay = SKAction.wait(forDuration: spawnInterval)
        let spawnSequence = SKAction.sequence([spawn, delay])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        run(spawnForever, withKey: "spawning")
    }
    
    
    
    @objc func hiveCountChanged(_ notification: Notification) {
        if let basicHives = notification.userInfo?["basicHives"] as? Int {
            spawnInterval = max(0.1, 1.0 / Double(basicHives))
            startSpawningBees()
        }
    }
    
    
    
    //creates bee objects
    func addBee() {
        let bee = SKSpriteNode(imageNamed: "beeImage")
        bee.name = "bee"
        
        // Set the starting position at the bottom of the screen
        bee.position = CGPoint(x: CGFloat.random(in: 0...size.width), y: -bee.size.height)
        addChild(bee)
        
        // Create an oscillating movement along the y-axis (moving upwards)
        let path = CGMutablePath()
        let amplitude: CGFloat = 50
        let frequency: CGFloat = .pi / 300
        var yPosition = bee.position.y
        path.move(to: bee.position)
        
        // Generate the path upwards
        while yPosition < size.height + bee.size.height {
            yPosition += 5  // Move upwards
            let xOffset = sin(yPosition * frequency) * amplitude
            let x = bee.position.x + xOffset
            path.addLine(to: CGPoint(x: x, y: yPosition))
        }
        
        let moveUp = SKAction.follow(path, asOffset: false, orientToPath: false, duration: TimeInterval(CGFloat.random(in: 4...6)))
        let remove = SKAction.removeFromParent()
        bee.run(SKAction.sequence([moveUp, remove]))
    }
    
    
    
    // Move touchesBegan() out of hiveCountChanged
    // Adds touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if node.name == "bee" {
                node.removeFromParent()
                // Inform the game state
                gameDelegate?.beeTapped()
            }
        }
    }
}


