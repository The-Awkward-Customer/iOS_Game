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


// At the top of MainGameScene.swift, outside the class definition
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
    

    private var cancellables = Set<AnyCancellable>()
      
    private var debugGridSubscription: AnyCancellable?
    
    
    private var gridManager: GridManager?
    private var flowerManager: FlowerManager?
    
    
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
    
    
    private var pausedBees: [BasicBeeSprite: BeeState] = [:]
    
    
    
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
        print("🎮 Setting up pause handling")
            setupPauseHandling()
        
        // Initialize GridManager with debug mode
        gridManager = GridManager(scene: self, columns: 8, rows: 14, cellSize: 50, debugMode: sharedGameState.showDebugGrid)
        
        debugGridSubscription = sharedGameState.objectWillChange.sink { [weak self] _ in
            self?.gridManager?.toggleDebugMode()
        }
        
        // Initialize FlowerManager if we have a valid GridManager
        if let gridManager = gridManager {
            flowerManager = FlowerManager(scene: self, gridManager: gridManager)
            flowerManager?.startSpawningFlowers()
            print("Flower spawning started")
        }
        
        
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
            self?.basicBeeSpawnEvent()
        }
    }
    
    deinit {
        flowerManager?.cleanup()
    }
    
    func debugSpawnFlower() {
        flowerManager?.trySpawnFlower()
        print("manually spawned flower")
        }
    
    func toggleFlowerSpawning(enabled: Bool) {
        if enabled {
            flowerManager?.startSpawningFlowers()
        }else {
            flowerManager?.stopSpawingFlowers()
        }
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
//        print("spawned \(beesToSpawn) bees")
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
        } else {
            print("🟢 Game Resumed - Restoring \(pausedBees.count) bees")
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
    
    
    deinit {
        cancellables.removeAll()
        }
}


