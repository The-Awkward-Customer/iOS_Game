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


class MainGameScene: SKScene {
    
    // TODO maybe the deglate can be removed.
    // handles connection to the GameDelegate.
    weak var gameDelegate: GameDelegate?
    
    
    
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
    
    // TODO
    // MARK: - BASIC BEE
    private func basicBeeSpawnEvent() {
        /// Called every time the onBasicBeeAccumulator triggers  onBasicBeeSpawnIntervalTick "ticks".
        
        // Nodes initial position
        let xPos = CGFloat.random(in:0...size.width)
        let yPos = CGFloat.random(in:0...size.height)
        let basicBee = BasicBeeSprite(gameState: sharedGameState, parentScene: self)
        basicBee.position = CGPoint(x: xPos, y: yPos)
        addChild(basicBee)
        
        print("Basic Bee Spawned")
    }
    
    // TODO
    // MARK: - BASIC BEE
    private func conductorTickEvent() {
        /// Called ever time the onBasicBeeAccumulator ticks.
        
        
        print("tick")
    }
    
}

