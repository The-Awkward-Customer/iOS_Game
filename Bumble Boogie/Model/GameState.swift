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
    @AppStorage ("Bees") var Bees: Int = 1
    @AppStorage ("Honey") var Honey: Int = 0
    @AppStorage ("HoneyPerTap") var HoneyPerTap: Int = 1
    @AppStorage ("HoneyPerSecond") var HoneyPerSecond: Int = 1
    @Published var canBuyBee: Bool = true
    var timer: Timer?
    
    func HoneyWatcher(){
        if (Honey >= Bees*2){
            print("you can buy a bee")
            canBuyBee = true
        } else {
            print("can't buy bee")
            canBuyBee = false
        }
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] _ in self?.updateCounter()}
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) {[weak self] _ in self?.HoneyWatcher()}
    }
    
    func updateCounter(){
        Honey += Bees
    }
    
    func BuyABee(){
        Bees += 1
        Honey -= Bees
        let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()  // Trigger the haptic feedback
        
    }
    
    func HarvestHoney(){
        Honey += HoneyPerTap
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()  // Trigger vibration
    }
    
    func resetCookies() {
        Honey = 0
        Bees = 1
    }
}
