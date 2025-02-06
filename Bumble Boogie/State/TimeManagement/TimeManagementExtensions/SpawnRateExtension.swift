//
//  SpawnRateExtension.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 05/01/2025.
//
//
//import Foundation
//
//
//extension GameTimeManager {
//    
//    // Basic bees spawn more frequently by DECREASING the interval
//    func increaseBasicBeeSpawnRate() {
//        // decrease the interval but clamped to a safe minimum
//        basicBeeSpawnInterval = max(0.2, basicBeeSpawnInterval - 0.5)
//        
//        // Optionally reset the accumulator so the change takes immediate effect.
//        /// (If you want the partial accumulated time to remain, omit this line.)
//        basicBeeSpawnAccumulator = 0
//        print("spawnRate is \(basicBeeSpawnInterval)")
//    }
//    
//    // Basic bees spawn less fequently by INCREASING the interval
//    func decreaseBasicBeeSpawnRate() {
//     basicBeeSpawnInterval = max(10.0, basicBeeSpawnInterval + 0.5)
//        
//        // Optionally reset the accumulator so the change takes immediate effect.
//        /// (If you want the partial accumulated time to remain, omit this line.)
//        basicBeeSpawnAccumulator = 0
//        print("spawnRate is \(basicBeeSpawnInterval)")
//    }
//}
