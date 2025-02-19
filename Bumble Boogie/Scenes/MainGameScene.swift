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



// Bee state tracking structure
private struct BeeState {
    let position: CGPoint
    let velocity: CGVector
    let wasAnimating: Bool
    let emitterState: Bool
    
    init(bee: BasicBeeSprite) {
        self.position = bee.position
        if let physicsBody = bee.physicsBody {
            self.velocity = physicsBody.velocity
        } else {
            self.velocity = .zero
        }
        self.wasAnimating = bee.action(forKey: "beeAnimation") != nil
        self.emitterState = !(bee.trailEmitter?.isPaused ?? true)
    }
}

class MainGameScene: SKScene {
    // MARK: - Properties
       private var cancellables = Set<AnyCancellable>()
       private var debugGridSubscription: AnyCancellable?
       private var gridManager: GridManager?
       private var flowerManager: FlowerManager?
       private var pausedBees: [BasicBeeSprite: BeeState] = [:]
    
    
    
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
        
        // Feedback components
        let visualFeedback = VisualFeedbackComponent(scene: self)
        let hapticFeedback = HapticFeedbackComponent()
        GameFeedbackManager.shared.register(component: visualFeedback)
        GameFeedbackManager.shared.register(component: hapticFeedback)
    }
    
    
    private func setupCallbacks() {
        // Bee Spawn Callback
        sharedGameState.onBasicBeeSpawnIntervalTick = { [weak self] in
            self?.basicBeeSpawnEvent( )
        }
        
        setupPauseHandling()
    }
    
    
    
    // MARK: - Bee spawing
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
    
    
    private func basicBeeSpawnEvent() {
        let beesToSpawn = max(1, sharedGameState.hiveCount)
        
        for _ in 0..<beesToSpawn {
            let spawnPosition = getSpawnPositionWithMargins()
            let basicBee = BasicBeeSprite(gameState: sharedGameState, parentScene: self)
            basicBee.position = spawnPosition
            addChild(basicBee)
        }
    }
    
    
    
    //MARK: - Pause game functions
    private func setupPauseHandling() {
        sharedGameState.$isPaused
            .sink { [weak self] isPaused in
                self?.handlePauseState(isPaused)
            }
            .store(in: &cancellables)
    }
    
    
    private func handlePauseState(_ isPaused: Bool) {
        if isPaused {
            print("🔴 Game Paused - Storing \(children.compactMap { $0 as? BasicBeeSprite }.count) bees")
            storeBeeStates()
            pauseAllBees()
            self.isPaused = true
        } else {
            print("🟢 Game Resumed - Restoring \(pausedBees.count) bees")
            self.isPaused = false
            resumeAllBees()
        }
    }
    
    
    private func storeBeeStates() {
        children.compactMap { $0 as? BasicBeeSprite }.forEach { bee in
            pausedBees[bee] = BeeState(bee: bee)
        }
    }
    
    
    private func pauseAllBees() {
        children.compactMap { $0 as? BasicBeeSprite }.forEach { bee in
            bee.pause()
        }
    }
    
    
    private func resumeAllBees() {
        pausedBees.forEach { bee, state in
            bee.resume(
                at: state.position,
                velocity: state.velocity,
                resumeAnimation: state.wasAnimating,
                resumeEmitter: state.emitterState
            )
        }
        pausedBees.removeAll()
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
    }
    
    
    
}


