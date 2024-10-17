import Foundation
import SwiftUI
import UIKit

class GameState: ObservableObject, GameDelegate {
    
    
    
    
    
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    // ! This section handles the in-app memory storage
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    @Published var Honey: Int = 0
    @Published var HoneyPerTap: Int = 1
    @Published var HoneyPerSecond: Int = 1
    @Published var RandomHoney: Int = 0
    @Published var canBuyBee: Bool = true
    @Published var sequenceProgress: Int = 0
    
    
    @Published var canBuyQueenBee = false
    var queenBeeCost = 200
    @Published var baseSpawnMultiplier: CGFloat = 0.05 // 0.2% chance
    // Conform to GameDelegate
        var spawnMultiplier: CGFloat {
            return baseSpawnMultiplier
        }
    
    @Published var isBoostActive: Bool = false // boolean state of boost
    var boostDuration: TimeInterval = 10.0 // sets boost duration
    var boostTimer: Timer? // tracks boost duration
    
    
    
    @Published var spawnTime: Double = 2.5
    @Published var basicHives: Int = 1
    var basicHiveCost: Int = 100 // Cost of a basic hive
    @Published var buyBasicHiveButton: Bool = false // Controls button state
    @Published var isShopPresented: Bool = false  // Control the visibility of the sheet
    
    init() {
        loadGameState()
        enableBasicHivePurchase()
    }
    
    
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    // ! Methods for saving and loading game state
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    
    // Load the beeGameObjects array from @AppStorage (JSON string)
    // Methods for saving and loading game state
    func loadGameState() {
        let defaults = UserDefaults.standard
        Honey = defaults.integer(forKey: "Honey")
        HoneyPerTap = defaults.integer(forKey: "HoneyPerTap")
        if HoneyPerTap == 0 { HoneyPerTap = 1 }
        
        HoneyPerSecond = defaults.integer(forKey: "HoneyPerSecond")
        if HoneyPerSecond == 0 { HoneyPerSecond = 1 }
        
        RandomHoney = defaults.integer(forKey: "RandomHoney")
        basicHives = defaults.integer(forKey: "basicHives")
        if basicHives == 0 { basicHives = 1 }
    }
    
    func saveGameState() {
        let defaults = UserDefaults.standard
        defaults.set(Honey, forKey: "Honey")
        defaults.set(HoneyPerTap, forKey: "HoneyPerTap")
        defaults.set(HoneyPerSecond, forKey: "HoneyPerSecond")
        defaults.set(RandomHoney, forKey: "RandomHoney")
        defaults.set(spawnTime, forKey: "spawnTime")
        defaults.set(basicHives, forKey: "basicHives")
    }
    
    
    
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    // ! This section handles the generation of honey and rewards.
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    func beeTapped() {
        // Trigger light impact haptic feedback
        let impactLight = UIImpactFeedbackGenerator(style: .light)
        impactLight.impactOccurred()
        
        generateHoney()
    }
    
    func sequenceProgressUpdated(to progress: Int){
        DispatchQueue.main.async {
            self.sequenceProgress = progress
        }
    }
    
    func activateBoost(){
        self.startBoost()
    }
    
    
    func startBoost(){
        if isBoostActive {
            boostTimer?.invalidate() // invalidates timer if boost is false
        }else {
            isBoostActive = true
        }
        
        // Notify SwiftUI views (if needed)
        DispatchQueue.main.async {
            self.isBoostActive = true
        }
        
        // Start Boost Timer
        boostTimer = Timer.scheduledTimer(withTimeInterval: boostDuration, repeats: false) { [weak self] _ in self?.deactivateBoost()}
    }
    
    func deactivateBoost(){
        isBoostActive = false
        
        print("Boost Deactivated")
        // Invalidate and "Nil out" the timer
        boostTimer?.invalidate()
        boostTimer = nil
    }
    
    
    func generateHoney() {
        print("Generating honey")
        
        // Generate a random amount of honey
        let randomHoney = Int.random(in: 1...20)
        RandomHoney = randomHoney
        
        // hold the value of honey to add
        let honeyToAdd = isBoostActive ? randomHoney * 2 : randomHoney
        
        // Update the total honey
        Honey += honeyToAdd
        
        // Save the updated values to UserDefaults
        saveGameState()
        
        enableBasicHivePurchase()  // Check if the purchase button should be enabled
    }
    
    
    //BasicHive
    // Enable or disable the hive purchase button
    func enableBasicHivePurchase() {
        buyBasicHiveButton = Honey >= basicHiveCost
    }
    
    // Handle the purchase of a basic hive
    func purchaseBasicHive() {
        if buyBasicHiveButton {
            Honey -= basicHiveCost
            basicHives += 1
            
            // Save the updated values to UserDefaults
            saveGameState()
            
            enableBasicHivePurchase()  // Re-check if further purchases are allowed
        }
    }
    
    
    //QueenBee
    // Enable or disable the QueenBees purchase button
    func enableQueenBeePurchase() {
        canBuyQueenBee = Honey >= queenBeeCost
    }
    
    func increaseSpawnMultiplier() {
        if canBuyQueenBee {
            Honey -= queenBeeCost
            baseSpawnMultiplier += 0.05
            // Ensure it doesn't exceed a maximum value
            //        baseSpawnMultiplier = min(baseSpawnMultiplier, 1.0)
            print("The odds of an extra bee is \(baseSpawnMultiplier)")
            saveGameState()
            enableQueenBeePurchase()
        }
    }
    
    
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    // ! This section is for handling the shop and rewards
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    func summonShop() {
        isShopPresented.toggle()
        print("The value of shop is \(isShopPresented)")
    }
    
    
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    // ! This section is for development testing functions
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    func hardReset(delay: TimeInterval = 0.2) {
        
        
        Honey = 0
        basicHives = 1
        saveGameState()
        
    }
}

// Notification extension
extension Notification.Name {
    static let hiveCountChanged = Notification.Name("hiveCountChanged")
}

