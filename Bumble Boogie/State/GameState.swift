import SwiftUI
import Combine

@MainActor
class GameState: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var progress: GameProgress
    @Published var isPaused: Bool = false
    @Published var showDebugGrid: Bool = false
    @Published var showPhysicsDebug: Bool = false
    
    // MARK: - Timer Callbacks
    var onBasicBeeSpawnIntervalTick: (() -> Void)?
    var onFlowerSpawnIntervalTick: (() -> Void)?
    
    // MARK: - Private Properties
    private var timerCancellable: AnyCancellable? {
        willSet {
            timerCancellable?.cancel()
        }
    }
    private var lastTickTime: TimeInterval = CACurrentMediaTime()
    private let memoryManager: UserDefaultsMemoryManager
    private var hasCleanedUp = false
    
    
    // MARK: - Initialization
    init(memoryManager: UserDefaultsMemoryManager = .shared) {
        self.memoryManager = memoryManager
        
        // Load saved progress or use initial values
        if let savedProgress: GameProgress = memoryManager.getCodable(forKey: .GameProgress, as: GameProgress.self) {
            self.progress = savedProgress
        } else {
            self.progress = GameProgress.initialValues
        }
        
        // Delay timer start to next runloop to ensure proper initialization
        DispatchQueue.main.async { [weak self] in
            self?.startMasterTimer()
        }
    }
    
   
    
    // MARK: - Timer Management
    func startMasterTimer() {
        stopMasterTimer()  // Clean up any existing timer
        
        timerCancellable = Timer.publish(every: 0.01, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateGameState()
            }
    }
    
    func stopMasterTimer() {
        timerCancellable = nil
    }
    
    private func performCleanup() {
        guard !hasCleanedUp else { return }
        hasCleanedUp = true
        
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    private func updateGameState() {
        guard !isPaused else { return }
        
        let currentTime = CACurrentMediaTime()
        let deltaTime = currentTime - lastTickTime
        
        progress.totalPlayTime += deltaTime
        
        if progress.totalPlayTime.truncatingRemainder(dividingBy: progress.basicBeeSpawnInterval) < 0.01 {
            onBasicBeeSpawnIntervalTick?()
        }
        
        if progress.totalPlayTime.truncatingRemainder(dividingBy: progress.flowerSpawnInterval) < 0.01 {
            onFlowerSpawnIntervalTick?()
        }
        
        lastTickTime = currentTime
    }
    
    // MARK: - Game Control
    func pauseGame() {
        isPaused = true
        GamePauseManager.shared.pauseGame()
        saveProgress()
    }
    
    func resumeGame() {
        isPaused = false
        GamePauseManager.shared.resumeGame()
    }
    
    // MARK: - Game Progress Management
    private func saveProgress() {
        memoryManager.setCodable(progress, forKey: .GameProgress)
    }
    
    // MARK: - Game Actions
    func increaseTotalHoney(by amount: Int) {
        progress.totalHoney += amount
        saveProgress()
    }
    
    func decreaseTotalHoney(by amount: Int) {
        progress.totalHoney = max(0, progress.totalHoney - amount)
        saveProgress()
    }
    
    func increaseBasicBeeSpawnRate() {
        progress.basicBeeSpawnInterval = max(
            progress.minBeeSpawnInterval,
            progress.basicBeeSpawnInterval - progress.spawnIntervalStep
        )
        saveProgress()
    }
    
    func decreaseBasicBeeSpawnRate() {
        progress.basicBeeSpawnInterval = min(
            progress.maxBeeSpawnInterval,
            progress.basicBeeSpawnInterval + progress.spawnIntervalStep
        )
        saveProgress()
    }
    
    func purchaseHive() -> Bool {
        guard progress.totalHoney >= progress.nextHiveCost else { return false }
        
        progress.totalHoney -= progress.nextHiveCost
        progress.hiveCount += 1
        progress.nextHiveCost = Int(Double(progress.baseHiveCost) * pow(progress.hiveCostMultiplier, Double(progress.hiveCount)))
        
        saveProgress()
        return true
    }
    
    // MARK: - Game State Access
    var totalHoney: Int { progress.totalHoney }
    var hiveCount: Int { progress.hiveCount }
    var basicBeeSpawnInterval: TimeInterval { progress.basicBeeSpawnInterval }
    var nextHiveCost: Int { progress.nextHiveCost }
}
