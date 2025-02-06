////
////  GameStateExtenstions.swift
////  BumbleBoogie
////
////  Created by Peter Abbott on 17/01/2025.
////
//
//import Foundation
//
//
//extension GameState {
//    
//    
//    
//    // MARK: - Increases and Decreases total Honey
//    // TODO Need to extend with further logic.
//    func increaseTotalHoney (by amount: Int) {
//        
//        DispatchQueue.main.async {
//            self.TotalHoney += amount
//            print("totalHoney is now \(self.TotalHoney)")
//        }
//        
//    }
//    
//    func decreaseTotalHoney (by amount: Int) {
//        
//        DispatchQueue.main.async {
//            if self.TotalHoney >= amount {
//                self.TotalHoney -= amount
//            }
//        }
//    }
//    
//}
