//
//  BeeScene.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 11/10/2024.
//

import SpriteKit

// Protocol to communicate events from BeeScene to another class (e.g., GameState)
protocol GameDelegate: AnyObject {
    func beeTapped() // Method to handle when a bee is tapped
    var spawnMultiplier: CGFloat { get } // Gets the value from gameState
}

// BeeScene class inherits from SKScene and manages the game's visual elements
class BeeScene: SKScene {
    
    
    
    // Weak reference to prevent retain cycles; allows communication with GameState
    weak var gameDelegate: GameDelegate?
    
    // Interval between spawning bees; will be adjusted based on the number of hives
    var spawnInterval: TimeInterval = 1.0
    
    // Bees per spawn
    var beesPerSpawn: Int = 1
    
    // Called when the scene is first presented by the view
    override func didMove(to view: SKView) {
        // Set the background color of the scene to transparent
        backgroundColor = SKColor.clear
        
        // -----------------------------
        // Background Image Setup
        // -----------------------------
        
        // Create an SKSpriteNode using the background image asset
        let background = SKSpriteNode(imageNamed: "backgroundImage") // Replace with your image name
        
        // Calculate scaling factors to maintain the image's aspect ratio
        let widthRatio = size.width / background.texture!.size().width
        let heightRatio = size.height / background.texture!.size().height
        
        // Choose the larger scale factor to ensure the image fills the screen (Aspect Fill)
        let scaleFactor = max(widthRatio, heightRatio) // Use 'min' for Aspect Fit
        
        // Apply the scale factor to the background image
        background.setScale(scaleFactor)
        
        // Position the background image at the center of the scene
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        // Set the zPosition to -1 so the background appears behind all other nodes
        background.zPosition = -1
        
        // Add the background node to the scene's node tree
        addChild(background)
        
        // -----------------------------
        // Bee Spawning Setup
        // -----------------------------
        
        // Start the process of spawning bees at regular intervals
        startSpawningBees()
        
        // Register to observe notifications for hive count changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hiveCountChanged(_:)),
            name: .hiveCountChanged,
            object: nil
        )
    }
    
    // Function to start spawning bees at intervals defined by spawnInterval
    func startSpawningBees() {
        // Remove any existing spawning actions to prevent duplication
        removeAction(forKey: "spawning")
        
        // Define an action to run the addBee() method
        let spawn = SKAction.run { [weak self] in
            guard let self = self else { return }
            
            
            var beesToSpawn = self.beesPerSpawn
            
            // Access spawnMultiplier from gameDelegate
            let spawnMultiplier = self.gameDelegate?.spawnMultiplier ?? 0
            
            // Random chance to spawn an extra bee
            if CGFloat.random(in: 0...1) < spawnMultiplier {
                beesToSpawn += 1
                print("Extra bee spawned! Total bees this spawn: \(beesToSpawn)")
            }
            
            for _ in 0..<beesToSpawn {
                self.addBee()
            }
        }
        
        // Define a delay action using the current spawnInterval
        let delay = SKAction.wait(forDuration: spawnInterval)
        
        // Create a sequence of spawning and delaying
        let spawnSequence = SKAction.sequence([spawn, delay])
        
        // Repeat the spawning sequence indefinitely
        let spawnForever = SKAction.repeatForever(spawnSequence)
        
        // Run the spawning action with a key for potential future reference or removal
        run(spawnForever, withKey: "spawning")
    }
    
    // Function called when the hive count changes; adjusts the spawnInterval accordingly
    @objc func hiveCountChanged(_ notification: Notification) {
        // Extract the number of basic hives from the notification's userInfo dictionary
        if let basicHives = notification.userInfo?["basicHives"] as? Int {
            // Calculate the new spawnInterval inversely proportional to the number of hives
            // Ensures that the interval doesn't go below 0.1 seconds
            spawnInterval = max(0.01, 0.5 / Double(basicHives))
            
            // Restart the bee spawning process with the new interval
            startSpawningBees()
        }
    }
    
    // Function to create and add a bee sprite to the scene
    func addBee() {
        // Create an SKSpriteNode using the bee image asset
        let bee = SKSpriteNode(imageNamed: "beeImage") // Replace with your image name
        bee.name = "bee" // Assign a name to identify the bee node
        
        // Set the starting position of the bee at a random x-coordinate just below the screen
        bee.position = CGPoint(
            x: CGFloat.random(in: 0...size.width),
            y: -bee.size.height
        )
        
        // Add the bee node to the scene's node tree
        addChild(bee)
        
        // -----------------------------
        // Bee Movement Path Setup
        // -----------------------------
        
        // Create a mutable path for the bee to follow
        let path = CGMutablePath()
        
        // Define the amplitude and frequency for the oscillating movement
        let amplitude: CGFloat = CGFloat.random(in: -50...50) // Controls the width of oscillation
        let frequency: CGFloat = .pi / 300 // Controls the frequency of oscillation
        
        // Random phase shift of 0 or π
        let phaseShift: CGFloat = Bool.random() ? 0 : .pi
        
        // Initialize the y-position starting from the bee's current position
        var yPosition = bee.position.y
        
        // Move the path's starting point to the bee's initial position
        path.move(to: bee.position)
        
        // Generate the path upwards until the bee moves off the top of the screen
        while yPosition < size.height + bee.size.height {
            yPosition += 5 // Move upwards in small increments
            
            // Calculate the horizontal offset using a sine wave for oscillation
            let xOffset = sin(yPosition * frequency + phaseShift) * amplitude
            
            // Calculate the new x-coordinate with the oscillation applied
            let x = bee.position.x + xOffset
            
            // Add the new point to the path
            path.addLine(to: CGPoint(x: x, y: yPosition))
        }
        
        // -----------------------------
        // Bee Movement Action Setup
        // -----------------------------
        
        // Create an action for the bee to follow the generated path
        let moveUp = SKAction.follow(
            path,
            asOffset: false, // Path coordinates are absolute positions
            orientToPath: false, // Bee does not rotate to match the path's direction
            duration: TimeInterval(CGFloat.random(in: 2...5)) // Random duration between 4 to 6 seconds
        )
        
        // Create an action to remove the bee from the scene after it completes its path
        let remove = SKAction.removeFromParent()
        
        // Run the sequence of moving up and then removing the bee
        bee.run(SKAction.sequence([moveUp, remove]))
    }
    
    // Function to handle touch events in the scene
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Safely unwrap the first touch in the set
        guard let touch = touches.first else { return }
        
        // Get the location of the touch within the scene
        let location = touch.location(in: self)
        
        // Retrieve all nodes at the touch location
        let nodesAtPoint = nodes(at: location)
        
        // Iterate through the nodes to check for bees
        for node in nodesAtPoint {
            // Check if the node is a bee by comparing its name
            if node.name == "bee" {
                // Remove the bee from the scene
                node.removeFromParent()
                
                // Notify the game delegate that a bee has been tapped
                gameDelegate?.beeTapped()
            }
        }
    }
}
