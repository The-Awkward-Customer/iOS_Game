import Foundation
import SwiftUI
import UIKit

class GameState: ObservableObject {
    
    

    
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    // ! This section handles the in-app memory storage
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    @Published var Honey: Int = 0
    @Published var HoneyPerTap: Int = 1
    @Published var HoneyPerSecond: Int = 1
    @Published var RandomHoney: Int = 0
    @Published var canBuyBee: Bool = true
    
    // Timer for bee position updates
    var positionUpdateTimer: Timer?
    var spawnTimer: Timer?
    var baseSpawnTime: Double = 0.2  // Base spawn time is 0.5 seconds
    
    
    // In-memory array of BeeGame objects
    @Published var beeGameObjects: [BeeGameObject] = []
    
    @Published var spawnTime: Double = 2.5
    @Published var basicHives: Int = 1
    
    var basicHiveCost: Int = 100 // Cost of a basic hive
    @Published var buyBasicHiveButton: Bool = false // Controls button state
    
    @Published var isShopPresented: Bool = false  // Control the visibility of the sheet
    
    init() {
        // Load the game state from UserDefaults
        loadGameState()
        // Start position updates if there are bees
        if !beeGameObjects.isEmpty {
            startPositionUpdates()
        }
        // Start spawning bees
        startSpawningBees()
    }
    
    
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    // ! Methods for saving and loading game state
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    
    // Load the beeGameObjects array from @AppStorage (JSON string)
    func loadGameState() {
        let defaults = UserDefaults.standard
        Honey = defaults.integer(forKey: "Honey")
        HoneyPerTap = defaults.integer(forKey: "HoneyPerTap")
        if HoneyPerTap == 0 {HoneyPerTap = 1 } //Sets default value if not set
        
        HoneyPerSecond = defaults.integer(forKey: "HoneyPerSecond")
        if HoneyPerSecond == 0 { HoneyPerSecond = 1 }  // Default value if not set
        
        RandomHoney = defaults.integer(forKey: "RandomHoney")
        
        spawnTime = defaults.double(forKey: "spawnTime")
        if spawnTime == 0 { spawnTime = 2.5 }  // Default value if not set
        
        basicHives = defaults.integer(forKey: "basicHives")
        if basicHives == 0 { basicHives = 1 }  // Default value if not set
        
        
        // Load beeGameObjects
        if let data = defaults.data(forKey: "beeGameObjectsData") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([BeeGameObject].self, from: data) {
                beeGameObjects = decoded
            }
            
            enableBasicHivePurchase()
            
        }
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
    
    // Save the beeGameObjects array to UserDefaults
    func saveBeeGameObjects() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(beeGameObjects) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "beeGameObjectsData")
        }
    }
    
    
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    // ! This section handles the management of game objects
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    
    func addBee() {
        let minX: CGFloat = 24
        let maxX: CGFloat = UIScreen.main.bounds.width - 24
        
        let newBee = BeeGameObject(
            id: UUID(),
            xPosition: CGFloat.random(in: minX...maxX),
            yPosition: 1200,
            speed: Double.random(in: 2...4),
            oscillationPhase: 0,                        // Start with a zero phase
            amplitude: CGFloat.random(in: -2.0...2.0),  // Random amplitude
            frequency: CGFloat.random(in: 0.01...0.05)  // Random frequency
        )
        beeGameObjects.append(newBee)
        saveBeeGameObjects()  // Save to UserDefaults after adding
        print("Bees in beeGameObjects = \(beeGameObjects.count)")
    }
    
    // Function to start spawning bees
    func startSpawningBees() {
        let maxBees = basicHives * 5
        guard beeGameObjects.count < maxBees else { return }
        
        spawnTimer?.invalidate()
        spawnTimer = Timer.scheduledTimer(withTimeInterval: baseSpawnTime, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.beeGameObjects.count < maxBees {
                self.addBee()
            } else {
                self.spawnTimer?.invalidate()
            }
        }
    }
    
    
    // Function to stop the spawning timer
    func stopSpawningBees() {
        spawnTimer?.invalidate()
        spawnTimer = nil
        print("Stopped the spawn timer.")
    }
    
    // Check if we need to restart the timer when a bee is removed
    func checkForRestartSpawningBees() {
        let maxBees = basicHives * 5
        if beeGameObjects.count < maxBees {
            print("Bee count below max, restarting spawn timer.")
            startSpawningBees()
        }
    }
    
    // Removes a bee from the array
    func removeBee(bee: BeeGameObject) {
        beeGameObjects.removeAll { $0.id == bee.id }
        saveBeeGameObjects()  // Save to UserDefaults after removing
        print("Bee removed")
        print("Bees in beeGameObjects = \(beeGameObjects.count)")
        generateHoney()
        
        // Check if we need to resume spawning bees
        checkForRestartSpawningBees()
    }
    
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    // ! This section handles the generation of honey and rewards.
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    func generateHoney() {
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
        checkForRestartSpawningBees()
    }
    
    
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    // ! This section handles the animation of the bees
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    // Start the single timer for updating positions
    func startPositionUpdates() {
        positionUpdateTimer?.invalidate()
        positionUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
            self?.updateAllBeePositions()
        }
    }
    
    // Stop the position update timer
    func stopPositionUpdates() {
        positionUpdateTimer?.invalidate()
        positionUpdateTimer = nil
    }
    
    // Update positions for all bees
    func updateAllBeePositions() {
        
        for index in beeGameObjects.indices {
            var bee = beeGameObjects[index]
            
            bee.yPosition -= bee.speed 
            bee.xPosition += bee.amplitude * sin(bee.oscillationPhase)
            bee.oscillationPhase += bee.frequency
            
            // Loop back if bee reaches the top
            if bee.yPosition <= -100 {
                bee.yPosition = 1200
            }
            
            beeGameObjects[index] = bee
        }
        
        // Notify SwiftUI of the changes
        DispatchQueue.main.async {
            self.objectWillChange.send()
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
        // Stop all timers for bees
        stopPositionUpdates()
        
        // Delay the removal of all bees
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            // Clear the array
            self.beeGameObjects.removeAll()
            self.saveBeeGameObjects()  // Save to UserDefaults after removing
            print("All bees removed")
            print("Bees in beeGameObjects = \(self.beeGameObjects.count)")
            self.Honey = 0
            self.basicHives = 1
            
            // Save updated properties
            self.saveGameState()
            
            // Check if we need to restart the spawning bees process
            self.checkForRestartSpawningBees()
        }
    }
}
