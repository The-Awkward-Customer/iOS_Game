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
import Combine

//TODO
//Prepare for Data base Storage





class MainGameScene: SKScene {
    // MARK: - Properties
       private var cancellables = Set<AnyCancellable>()
       private var debugGridSubscription: AnyCancellable?
       private var gridManager: GridManager?
       private var flowerManager: FlowerManager?
       private var beeManager: BeeManager?
    
    
    
    // MARK: - Shared GameState
    let sharedGameState: GameState
    
    // Track the last frames time for calculating deltaTime.
    private var lastUpdateTime: TimeInterval = 0.0
    
    
    
    //MARK: - Init
    init(size: CGSize, gameState: GameState ){
        self.sharedGameState = gameState
        super.init(size: size)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Scene setup
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        print("did move to view")
        
        setupScene()
        setupManagers()
        setupCallbacks()
    }
    
    private func setupScene() {
        backgroundColor = .white
        view?.allowsTransparency = true
    }
    
    private func setupManagers() {
        // GridManager
        gridManager = GridManager(
            scene: self,
            columns: 8,
            rows: 14,
            cellSize: 50,
            debugMode: sharedGameState.showDebugGrid
        )
        
        // Debug subscription
        debugGridSubscription = sharedGameState.$showDebugGrid.sink { [weak self] showDebugGrid in
            if let gridManager = self?.gridManager {
                gridManager.setDebugMode(showDebugGrid)
            }
        }
        
        // Flower manager init
        if let gridManager = gridManager {
            flowerManager = FlowerManager(
                scene: self,
                gridManager: gridManager,
                gameState: sharedGameState,
                maxConcurrentFlowers: 3
            )
        }
        
        // Bee manager init
        beeManager = BeeManager(
            scene: self,
            gameState: sharedGameState
        )
        
        // Feedback components
        let visualFeedback = VisualFeedbackComponent(scene: self)
        let hapticFeedback = HapticFeedbackComponent()
        GameFeedbackManager.shared.register(component: visualFeedback)
        GameFeedbackManager.shared.register(component: hapticFeedback)
    }
    
    
    private func setupCallbacks() {
        setupPauseHandling()
    }
    
    
    
    
    //MARK: - Pause game functions
    private func setupPauseHandling() {
        sharedGameState.$isPaused
            .sink { [weak self] isPaused in
                self?.scene?.isPaused = isPaused
            }
            .store(in: &cancellables)
    }
    
    
    
    
    //MARK: - Debug methods
    func debugSpawnFlower() {
        flowerManager?.trySpawnFlower()
        print("manually spawned flower")
    }
    
    
    func toggleFlowerSpawning(enabled : Bool) {
        // Note: This is maintained for backwards compatibility
        // but doesn't do anything in the new implementation
        print("Flower spawning is now controlled by GameState timing")
    }
    
    
    
    //MARK: - Cleanup
    deinit {
        debugGridSubscription?.cancel()
        cancellables.removeAll()
        flowerManager?.cleanup()
        beeManager?.cleanup()
    }
    
    
    
}


