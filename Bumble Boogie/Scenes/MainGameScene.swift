//
//  BeeScene.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 11/10/2024.
//
//
import Foundation
import SwiftUI
import SpriteKit

//TODO
//Prepare for Data base Storage

class MainGameScene: SKScene {
    
    // MARK: - Shared GameState
    let sharedGameState: GameState
    
    // Require init
    init (size: CGSize, gameState: GameState) {
        self.sharedGameState = gameState
        super.init(size: size)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - GAME TIME MANAGER
    // We'll assign this from outside. It's not an EnvironmentObject here
    // because SpriteKit isn't a SwiftUI view.
    var gameState: GameState?
    
    
    // Track the last frames time for calculating deltaTime.
    private var lastUpdateTime: TimeInterval = 0.0
    
    // LEARN
    /// Better undertand didMove && override functions
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        print("Setting up spawn callback")
        
        
        let visualFeedback = VisualFeedbackComponent(scene: self)
        let hapticFeedback = HapticFeedbackComponent()
        
        // Register with manager
           GameFeedbackManager.shared.register(component: visualFeedback)
           GameFeedbackManager.shared.register(component: hapticFeedback)
        
        //TODO
        ///Is this relevant?
        // Scene Styling
        // Make the scene’s background transparent
        backgroundColor = .white
            
        // Also allow the underlying SKView to render transparency
        view.allowsTransparency = true
        
        
        // Set up a callback for basic bee spawn.
        sharedGameState.onBasicBeeSpawnIntervalTick = { [weak self] in
            print("SpawnTickReceived")
            self?.basicBeeSpawnEvent()
        }
        
        // Example of starting at double speed.
//        gameState?.speedFactor = 0.0
    }
    
    

    // MARK: - BASIC BEE
    
    
    private struct SpawnConfiguration {
        
        static let horizontalMarginPercentage: CGFloat = 0.1
        static let verticalMarginPercentage: CGFloat = 0.1
        
        static func calculateHorizontalMargin(for width: CGFloat) -> CGFloat {
            return width * horizontalMarginPercentage
        }
        
        static func calculateVerticalMargin(for height: CGFloat) -> CGFloat {
            return height * verticalMarginPercentage
        }
        
        // Calculates vertical offset
        static func calculateVerticalOffset(for height: CGFloat) -> CGFloat {
            let verticalMargin = calculateVerticalMargin(for: height)
            return height - (height + verticalMargin)
        }
    
    }

    
    private func getSpawnPositionWithMargins() -> CGPoint {
        
        // Create margins of 10% of screen size width
        let horizontalMargin = SpawnConfiguration.calculateHorizontalMargin(for: size.width)
        let safeXRange = horizontalMargin...(size.width - horizontalMargin)
        
        let verticalOffset = SpawnConfiguration.calculateVerticalOffset(for: size.height)
        
        return CGPoint(
            x: CGFloat.random(in: safeXRange),
            y: verticalOffset
        )
    }
    
    
    /// Called every time the onBasicBeeAccumulator triggers  onBasicBeeSpawnIntervalTick "ticks".
    private func basicBeeSpawnEvent() {
        
        let beesToSpawn = max(1, sharedGameState.hiveCount)

        
        for _ in 0..<beesToSpawn {
            let spawnPosition = getSpawnPositionWithMargins()
            let basicBee = BasicBeeSprite(gameState: sharedGameState, parentScene: self)
            basicBee.position = spawnPosition
            addChild(basicBee)
        }
        print("spawned \(beesToSpawn) bees")
    }
    
    
    
    
    // TODO
    private func conductorTickEvent() {
        /// Called ever time the onBasicBeeAccumulator ticks.
        
        
        print("tick")
    }
    
}

