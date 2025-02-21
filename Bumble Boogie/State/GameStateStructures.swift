//
//  GameStateStructures.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 19/02/2025.
//

import Foundation


/// Represents the complete saveable game state
struct GameProgress: Codable {
    // MARK: - Game Economy
    var totalHoney: Int
    var nextHiveCost: Int
    
    // MARK: - Game Objects
    var hiveCount: Int
    var basicBeeSpawnInterval: TimeInterval
    var maxConcurrentFlowers: Int
    var flowerSpawnInterval: TimeInterval
    var flowerLifespan: TimeInterval
    
    // MARK: - Game Limits and Steps
    var minBeeSpawnInterval: TimeInterval
    var maxBeeSpawnInterval: TimeInterval
    var spawnIntervalStep: TimeInterval
    var honeyPerTap: Int
    var minFlowerLifespan: TimeInterval
    var maxFlowerLifespan: TimeInterval
    var minFlowerSpawnInterval: TimeInterval
    var maxFlowerSpawnInterval: TimeInterval
    var baseHiveCost: Int
    var hiveCostMultiplier: Double
    
    // MARK: - Game Statistics
    var totalBeesSpawned: Int
    var totalFlowersCollected: Int
    var totalPlayTime: TimeInterval
    
    // MARK: - Initial Values
    static let initialValues = GameProgress(
        // Economy
        totalHoney: 0,
        nextHiveCost: 500,
        
        // Game Objects
        hiveCount: 1,
        basicBeeSpawnInterval: 2.0,
        maxConcurrentFlowers: 3,
        flowerSpawnInterval: 5.0,
        flowerLifespan: 3.0,
        
        // Game Limits and Steps
        minBeeSpawnInterval: 0.5,
        maxBeeSpawnInterval: 5.0,
        spawnIntervalStep: 0.1,
        honeyPerTap: 100,
        minFlowerLifespan: 1.0,
        maxFlowerLifespan: 5.0,
        minFlowerSpawnInterval: 2.0,
        maxFlowerSpawnInterval: 8.0,
        baseHiveCost: 500,
        hiveCostMultiplier: 1.5,
        
        // Statistics
        totalBeesSpawned: 0,
        totalFlowersCollected: 0,
        totalPlayTime: 0
    )
}

