//
//  GameState.swift
//  Conditional Rendering
//
//  Created by Peter Abbott on 09/09/2024.
//

import Foundation
import SwiftUI
import UIKit

class GameState: ObservableObject {
    @AppStorage ("Bees") var Bees: Int = 0
    @AppStorage ("Honey") var Honey: Int = 0
    @AppStorage ("HoneyPerTap") var HoneyPerTap: Int = 1
    @AppStorage ("HoneyPerSecond") var HoneyPerSecond: Int = 1
    var timer: Timer?
    
    
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] _ in self?.updateCounter()}
    }
    
    func updateCounter(){
        Honey += Bees
    }
    
    func BuyABee(){
        Bees += 1
        
    }
    
    func HarvestHoney(){
        Honey += HoneyPerTap
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()  // Trigger vibration
    }
    
    func resetCookies() {
        Honey = 0
        Bees = 0
    }
}
