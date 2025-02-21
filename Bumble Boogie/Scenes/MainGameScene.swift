import Foundation
import SwiftUI
import SpriteKit
import Combine

//TODO
//Prepare for Data base Storage





class MainGameScene: SKScene, SKPhysicsContactDelegate {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var debugGridSubscription: AnyCancellable?
    
    private var gridManager: GridManager?
    private var flowerManager: FlowerManager?
    private var beeManager: BeeManager?
    
    private var isCleaningUp = false
    let sharedGameState: GameState
    
    // MARK: - Initialization
    init(size: CGSize, gameState: GameState) {
        self.sharedGameState = gameState
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Scene Lifecycle
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupScene()
        setupManagers()
        setupCallbacks()
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        performCleanup()
    }
    
    deinit {
        performCleanup()
    }
    
    // MARK: - Setup Methods
    private func setupScene() {
        backgroundColor = .white
        view?.allowsTransparency = true
        
        // Basic Physics setup
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
    }
    
    private func setupManagers() {
        setupGridManager()
        setupFlowerManager()
        setupBeeManager()
        setupFeedbackManager()
    }
    
    private func setupGridManager() {
        gridManager = GridManager(
            scene: self,
            columns: 8,
            rows: 14,
            cellSize: 50,
            debugMode: sharedGameState.showDebugGrid
        )
        
        debugGridSubscription = sharedGameState.$showDebugGrid
            .sink { [weak self] showDebugGrid in
                self?.gridManager?.setDebugMode(showDebugGrid)
            }
    }
    
    private func setupFlowerManager() {
        guard let gridManager = gridManager else { return }
        
        flowerManager = FlowerManager(
            scene: self,
            gridManager: gridManager,
            gameState: sharedGameState,
            maxConcurrentFlowers: 3
        )
    }
    
    private func setupBeeManager() {
        beeManager = BeeManager(
            scene: self,
            gameState: sharedGameState
        )
    }
    
    private func setupFeedbackManager() {
        let visualFeedback = VisualFeedbackComponent(scene: self)
        let hapticFeedback = HapticFeedbackComponent()
        
        GameFeedbackManager.shared.register(component: visualFeedback)
        GameFeedbackManager.shared.register(component: hapticFeedback)
    }
    
    private func setupCallbacks() {
        sharedGameState.$isPaused
            .sink { [weak self] isPaused in
                self?.isPaused = isPaused
            }
            .store(in: &cancellables)
        
        // Add physics debug subscription
        sharedGameState.$showPhysicsDebug
            .sink { [weak self] showDebug in
                self?.view?.showsPhysics = showDebug
            }
            .store(in: &cancellables)
    }
    
    
    //MARK: - Physics handling
    func togglePhysicsDebug() {
        view?.showsPhysics.toggle()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("collision detected between \(contact.bodyA.node?.name ?? "unknown") and \(contact.bodyB.node?.name ?? "Unknown")")
        
        if contact.bodyA.node is BasicBeeSprite && contact.bodyB.node is FlowerNode ||
            contact.bodyB.node is BasicBeeSprite && contact.bodyA.node is FlowerNode {
            print("✅ Bee and Flower collision confirmed!")
            GameFeedbackManager.shared.trigger(.flowerCollisionDetected)
        }
    }
    
    // MARK: - Cleanup
    private func performCleanup() {
        guard !isCleaningUp else { return }
        isCleaningUp = true
        
        debugGridSubscription?.cancel()
        cancellables.removeAll()
        
        flowerManager?.cleanup()
        beeManager?.cleanup()
        
        flowerManager = nil
        beeManager = nil
        gridManager = nil
    }
}
