//
//  GameTimeManager.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 04/01/2025.
//

import Foundation

// MARK: - GAME TIME MANAGER
//

class GameTimeManager: ObservableObject {
    
    // TODO
    /// Implement a timer that runs and triggers events while the game is closed.
    
    // Accumulated (global) time in seconds since the game started.
    private(set) var masterTimer: DispatchSourceTimer?
    
    // Creates empty variables to trigger future functions
    var onConductorTimerIntervalTick: (() -> Void)?
    var onBasicBeeSpawnIntervalTick: (() -> Void)?
    
    // Creates the timeIntervals trackers
    @Published var conductorTimerInterval: TimeInterval = 1.0
    var basicBeeSpawnInterval: TimeInterval = 1.0
    
    private var conductorAccumulator: TimeInterval = 0.0
    private var basicBeeSpawnAccumulator: TimeInterval = 0.0
    
    // Indicated if the game is paused
    private(set) var isPaused: Bool = false

    // Speed factor that scales time progression.
    // e.g 1.0 = normal speed | 0.5 = half speed.
    var speedFactor: Double = 1.0
    
    
    func startMasterTimer() {
        // fires every 0.1 seconds
        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now() + 0.1, repeating: 0.1)
        timer.setEventHandler { [weak self] in
            guard let self = self else { return }
            self.update(0.1) /// uses delta time
        }
        timer.resume()
        masterTimer = timer
    }
    
    private func update(_ deltaTime: TimeInterval) {
        guard !isPaused else { return }
        
        // Applies speefFactor so we can do slow-mo for fast-forward
//        let scaledDelta = deltaTime * speedFactor
        
        conductorAccumulator += deltaTime
        if conductorAccumulator >= conductorTimerInterval {
            conductorAccumulator = 0
            onConductorTimerIntervalTick?()
        }
        
        basicBeeSpawnAccumulator += deltaTime
        if basicBeeSpawnAccumulator >= basicBeeSpawnInterval {
            basicBeeSpawnAccumulator = 0
            onBasicBeeSpawnIntervalTick?()
        }
    }
    
    func pauseGame() {
        isPaused = true
        print("Pausing game…")
    }
    
    func resumeGame() {
        isPaused = false
        print("Resuming game…")
    }
    
    
}

    






    
//    
//    // callbacks functions to start timers
//    func startTimers() {
//        startConductorTimer()
//        startBeeSpawnTimer()
//    }
//    
//    // Create and start the conductor timer (if not already active)
//    private func startConductorTimer() {
//        /// If already running do nothing
//        guard conductorTimer == nil else { return }
//        
//        let timer = DispatchSource.makeTimerSource(queue: .main)
//        timer.schedule(deadline: .now() + conductorTimerInterval, repeating: conductorTimerInterval)
//        timer.setEventHandler { [weak self] in
//            guard let self = self else { return }
//            guard !self.isPaused else { return }
//            self.onConductorTimerIntervalTick?()
//        }
//        
//        timer.resume()
//        conductorTimer = timer
//        print("the value of conductorTimerInterval is: \(conductorTimerInterval)")
//    }
//    
//    // Create and start the conductor timer (if not already active)
//    private func startBeeSpawnTimer() {
//        /// If already running do nothing
//        guard conductorTimer == nil else { return }
//        
//        let timer = DispatchSource.makeTimerSource(queue: .main)
//        timer.schedule(deadline: .now() + basicBeeSpawnInterval, repeating: basicBeeSpawnInterval)
//        timer.setEventHandler { [weak self] in
//            guard let self = self else { return }
//            guard !self.isPaused else { return }
//            self.onBasicBeeSpawnIntervalTick?()
//        }
//        
//        timer.resume()
//        beeSpawntimer = timer
//        print("the value of basicBeeSpawnTimerInterval is: \(basicBeeSpawnInterval)")
//    }
//    
//    // Pauses the game (and conductor timers)
//    func pauseGame(){
//        print("Pausing game…")
//        isPaused = true
//        stopAllTimers()
//    }
//    
//    // Resumes the game (and conductor timers)
//    func resumeGame() {
//        print("Resuming game…")
//        isPaused = false
//        startConductorTimer()
//        startBeeSpawnTimer()
//    }
//    
//    func resetGame() {
//        globalTime = 0.0
//    }
//    
//    
//     // Stop the conductor timer and set it to nil
//    private func stopAllTimers() {
//        conductorTimer?.cancel()
//        conductorTimer = nil
//        
//        beeSpawntimer?.cancel()
//        beeSpawntimer = nil
//    }
//    
//    
//    
//    
//    //MARK: - SPAWNRATES
//    // TODO
//    /// impliment gradual slowing over time elsewhere
//    // Increases speedFactor by 1.0
//    func increaseSpawnRate(){
//        /// Reduce spawn rate by subracting from the value of conductorTimerAlphaInterval
//        /// clamped to ensure it never goes below a negative value
//        basicBeeSpawnInterval = max(0.2, basicBeeSpawnInterval - 0.2)
//        reschedualTimers()
//        
//    }
//    
//    // decreases speedFactpr by 1.0
//    func decreaseSpawnRate() {
//        // e.g., increase the spawn interval
//        basicBeeSpawnInterval = min(10.0, basicBeeSpawnInterval + 0.5)
//        reschedualTimers()
//    }
//    
//    private func reschedualTimers(){
//        print("conductorTimerAlpha rescheduled")
//        
//        // Stop the existing timer
//        stopAllTimers()
//        
//        // creates a new timer
//        startTimers()
//    }
//    
//}
