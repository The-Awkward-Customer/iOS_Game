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
    
    
    func generateHoney() {
        print("generating honey")
        
        // Generate a random amount of honey
        let randomHoney = Int.random(in: 1...20)
        RandomHoney = randomHoney
        
        // Update the total honey
        Honey += RandomHoney
        
        // Save the updated values to UserDefaults
        saveGameState()
        
        enableBasicHivePurchase()  // Check if the purchase button should be enabled
    }
    
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

