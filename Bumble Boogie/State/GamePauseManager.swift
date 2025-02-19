//
//  GamePauseManager.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 12/02/2025.
//

import Foundation

import Foundation

class GamePauseManager {
    static let shared = GamePauseManager()
    
    private(set) var isGamePaused: Bool = false
    private var pauseStateObservers: [(Bool) -> Void] = []
    
    private init() {}
    
    func addPauseStateObserver(_ observer: @escaping (Bool) -> Void) {
        pauseStateObservers.append(observer)
    }
    
    func removePauseStateObservers(_ id: UUID) {
        pauseStateObservers.removeAll()
    }
    
    func pauseGame() {
        isGamePaused = true
        notifyObservers()
    }
    
    func resumeGame() {
        isGamePaused = false
        notifyObservers()
    }
    
    private func notifyObservers() {
        pauseStateObservers.forEach { observer in
            observer(isGamePaused)
        }
    }
}
