
import SwiftUI
import Combine
// MARK: - Main GameState Class
class GameState: ObservableObject {
    // MARK: - Game Properties
    @Published var TotalHoney: Int = 0 {
        didSet {
            print("did set TotalHoney: \(TotalHoney)")
            UserDefaultsMemoryManager.shared.set(TotalHoney, forKey: .TotalHoney)
        }
    }
    
    @Published var UpgradeCost: Int = 1000
    
    // MARK: - Timer Properties
    @Published var conductorTimerInterval: TimeInterval = 1.0
    @Published var basicBeeSpawnInterval: TimeInterval = 1.0 {
        didSet {
            print("did set basicBeeSpawnInterval: \(basicBeeSpawnInterval)")
            UserDefaultsMemoryManager.shared.set(basicBeeSpawnInterval, forKey: .basicBeeSpawnInterval)
        }
    }
    
    
    @Published var hiveCount: Int = 1 {
        didSet {
            print("did set hiveCount: \(hiveCount)")
            UserDefaultsMemoryManager.shared.set(hiveCount, forKey: .hiveCount)
        }
    }
    
    @Published var nextHiveCost: Int = 500 {
        didSet {
            UserDefaultsMemoryManager.shared.set(nextHiveCost, forKey: .nextHiveCost)
        }
    }
    
    
    private(set) var masterTimer: DispatchSourceTimer?
    private(set) var isPaused: Bool = false
    var speedFactor: Double = 1.0
    
    // MARK: - Accumulators
    var conductorAccumulator: TimeInterval = 0.0
    var basicBeeSpawnAccumulator: TimeInterval = 0.0
    
    // MARK: - Callbacks
    var onConductorTimerIntervalTick: (() -> Void)?
    var onBasicBeeSpawnIntervalTick: (() -> Void)?
    
    // MARK: - Initialization
    init() {
        loadSavedState()
    }
    
    private func loadSavedState() {
        if let savedTotalHoney: Int = UserDefaultsMemoryManager.shared.get(forKey: .TotalHoney) {
            TotalHoney = savedTotalHoney
            print(">>>>>> Loaded saved state: TotalHoney = \(TotalHoney)")
        }
        if let savedBasicBeeSpawnInterval: TimeInterval = UserDefaultsMemoryManager.shared.get(forKey: .basicBeeSpawnInterval) {
            basicBeeSpawnInterval = savedBasicBeeSpawnInterval
            print(">>>>>> Loaded saved state: basicBeeSpawnInterval = \(basicBeeSpawnInterval)")
        }
    }
}

// MARK: - Timer Management Extension
extension GameState {
    func startMasterTimer() {
        guard masterTimer == nil else { return }
        
        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now() + 0.1, repeating: 0.1)
        timer.setEventHandler { [weak self] in
            guard let self = self else { return }
            self.update(0.1)
        }
        timer.resume()
        masterTimer = timer
        print("master timer started")
    }
    
    private func update(_ deltaTime: TimeInterval) {
        guard !isPaused else { return }
        
        let scaledDelta = deltaTime * speedFactor
        print("Update called: delta=\(scaledDelta)")
        
        basicBeeSpawnAccumulator += scaledDelta
        print("Accumulator: \(basicBeeSpawnAccumulator)")
        
    
        if basicBeeSpawnAccumulator >= basicBeeSpawnInterval {
            print("Triggering spawn...")
            basicBeeSpawnAccumulator = 0
            onBasicBeeSpawnIntervalTick?()
        }
    }
    
    func stopMasterTimer() {
        masterTimer?.cancel()
        masterTimer = nil
        print("master timer stopping...")
    }
    
    func pauseGame() {
        isPaused = true
        print("Pausing game...")
    }
    
    func resumeGame() {
        isPaused = false
        print("Resuming game...")
    }
}
// MARK: - Hive Management
extension GameState {
    func purchaseHive() -> Bool {
        if TotalHoney >= nextHiveCost {
            decreaseTotalHoney(by: nextHiveCost)
            print("Hive purchased!")
            hiveCount += 1
            print("hiveCount is: \(hiveCount)")
            // increase nextHiveost
            nextHiveCost = Int(Double(nextHiveCost) * 1.5)
            return true
        }
        return false
    }
}



// MARK: - Spawn Rate Management Extension
extension GameState {
    func increaseBasicBeeSpawnRate() {
        basicBeeSpawnInterval = max(0.2, basicBeeSpawnInterval - 0.2)
        basicBeeSpawnAccumulator = 0
        print("spawnRate is \(basicBeeSpawnInterval)")
    }
    
    func decreaseBasicBeeSpawnRate() {
        basicBeeSpawnInterval = min(10.0, basicBeeSpawnInterval + 0.5)
        basicBeeSpawnAccumulator = 0
        print("spawnRate is \(basicBeeSpawnInterval)")
    }
}

// MARK: - Currency Management Extension
extension GameState {
    func increaseTotalHoney(by amount: Int) {
        DispatchQueue.main.async {
            self.TotalHoney += amount
            print("totalHoney is now \(self.TotalHoney)")
        }
    }
    
    func decreaseTotalHoney(by amount: Int) {
        DispatchQueue.main.async {
            if self.TotalHoney >= amount {
                self.TotalHoney -= amount
            }
        }
    }
}
