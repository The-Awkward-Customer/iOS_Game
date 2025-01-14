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
    
    var gameState: GameState?
    
    // TODO
    /// Implement a timer that runs and triggers events while the game is closed.
    
    // Accumulated (global) time in seconds since the game started.
    private(set) var masterTimer: DispatchSourceTimer?
    
    // Creates empty variables to trigger future functions
    var onConductorTimerIntervalTick: (() -> Void)?
    var onBasicBeeSpawnIntervalTick: (() -> Void)?
    
    // Creates the timeIntervals trackers
    @Published var conductorTimerInterval: TimeInterval = 1.0
//    @Published var basicBeeSpawnInterval: TimeInterval = 1.0
    

    
    var conductorAccumulator: TimeInterval = 0.0
    var basicBeeSpawnAccumulator: TimeInterval = 0.0
    
    // Indicated if the game is paused
    private(set) var isPaused: Bool = false

    // Speed factor that scales time progression.
    // e.g 1.0 = normal speed | 0.5 = half speed.
    var speedFactor: Double = 1.0
    
    
    
    func startMasterTimer() {
        
        guard masterTimer == nil else { return }
        
        // fires every 0.1 seconds
        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now() + 0.1, repeating: 0.1)
        timer.setEventHandler { [weak self] in
            guard let self = self else { return }
            self.update(0.1) /// uses delta time
        }
        timer.resume()
        masterTimer = timer
        print("master timer started")
    }
    
    private func update(_ deltaTime: TimeInterval) {
        guard !isPaused else { return }
        
//        // Applies speefFactor so we can do slow-mo for fast-forward
//        let scaledDelta = deltaTime * speedFactor
//        
        conductorAccumulator += deltaTime
        if conductorAccumulator >= conductorTimerInterval {
            conductorAccumulator = 0
            onConductorTimerIntervalTick?()
        }
        
        basicBeeSpawnAccumulator += deltaTime
        if basicBeeSpawnAccumulator >= gameState!.basicBeeSpawnInterval { // uses force unwrapping as game state is always present
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
    
    func stopMasterTimer() {
        masterTimer?.cancel()
        masterTimer = nil
        print("master timer stopping…")
       }
    
}

    


