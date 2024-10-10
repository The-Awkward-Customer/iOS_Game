import Foundation
import SwiftUI
import UIKit

class GameState: ObservableObject {
    
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    // ! This section handles the in-app memory storage
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    @AppStorage("Honey") var Honey: Int = 0
    @AppStorage("HoneyPerTap") var HoneyPerTap: Int = 1
    @AppStorage("HoneyPerSecond") var HoneyPerSecond: Int = 1
    @AppStorage("RandomHoney") var RandomHoney: Int = 0
    @Published var canBuyBee: Bool = true
    
    // Timer for bee position updates
    var timers: [UUID: Timer] = [:]
    
    var spawnTimer: Timer?
    var baseSpawnTime: Double = 0.2  // Base spawn time is 0.5 seconds
    
    //  BeeGameObject
    struct BeeGameObject: Identifiable, Codable {
        let id: UUID
        var xPosition: CGFloat
        var yPosition: CGFloat
        var speed: Double
    }
    
    // Use @AppStorage with a String to store encoded BeeGame objects
    @AppStorage("beeGameObjects") private var beeGameObjectsData: String = ""
    
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    // ! This section handles the management of game objects
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    // In-memory array of BeeGame objects
    @Published var beeGameObjects: [BeeGameObject] = []
    
    // Add a new bee
    
    @AppStorage("spawnTime") var spawnTime: Double = 2.5
    @AppStorage("basicHives") var basicHives: Int = 1
    
    
    
    func addBee() {
        
        let minX: CGFloat = 24
        let maxX: CGFloat = UIScreen.main.bounds.width - 24
        
        let newBee = BeeGameObject(
            id: UUID(),
            xPosition: CGFloat.random(in: minX...maxX),
            yPosition: 1200,
            speed: Double.random(in: 4...6)
        )
        beeGameObjects.append(newBee)
        saveBeeGameObjects()  // Save to AppStorage after adding
        print("bees in beeGameObject = \(beeGameObjects.count)")
        startPositionUpdate(for: newBee)  // Start animating the new bee
    }
    
    // Function to dynamically calculate spawnTime based on number of bees
    func calculateSpawnTime() -> Double {
        // Dynamic spawn time increases by 0.5 seconds per bee
        return baseSpawnTime + (Double(beeGameObjects.count) * 0.05)
    }
    
    // Function to start spawning bees
    func startSpawningBees() {
        
        // If there's an active timer, stop it to restart
        stopSpawningBees()
        
        let maxBees = basicHives * 5
        let spawnTime = calculateSpawnTime()  // Calculate the new spawn time based on the number of bees
        
        
        // Check if the number of bees is already equal to the available hives
        guard beeGameObjects.count < maxBees else {
            print("Max bees reached. Stopping timer.")
            stopSpawningBees()  // Stop the timer if we reach the maximum
            return
        }
        
        
        print("Starting bee spawning with a spawn time of \(spawnTime) seconds...")
        spawnTimer = Timer.scheduledTimer(withTimeInterval: spawnTime, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // If the number of bees is less than available hives, add a new bee
            if self.beeGameObjects.count < maxBees {
                self.addBee()
            } else {
                // Stop the timer when the maximum number of bees is reached
                self.stopSpawningBees()
            }
        }
    }
    
    // Function to stop the timer completely
    func stopSpawningBees() {
        spawnTimer?.invalidate()  // Invalidate the current timer
        spawnTimer = nil
        print("Stopped the spawn timer.")
    }
    
    // Check if we need to restart the timer when a bee is removed
    func checkForRestartSpawningBees() {
        let maxBees = basicHives
        
        if beeGameObjects.count < maxBees {
            print("Bee count below max, restarting spawn timer.")
            startSpawningBees()  // Restart the spawning process
        }
    }
    
    
    
    // Removes bee from the array
    func removeBee(bee: BeeGameObject, delay: TimeInterval = 0.5) {
        // Stop the bee's timer before removing it
        stopPositionUpdate(for: bee)
        
        // Delay the removal of the bee
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            // Remove the bee from the array
            self.beeGameObjects.removeAll { $0.id == bee.id }
            self.saveBeeGameObjects()  // Save to AppStorage after removing
            print("Bees removed")
            print("Bees in beeGameObjects = \(self.beeGameObjects.count)")
            self.GenerateHoney()
            
            // Check if we need to resume spawning bees
            self.checkForRestartSpawningBees()
        }
    }
    
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    // ! This section handles the generation of honey and rewards.
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    func GenerateHoney(){
        // Update addedHoney first before starting the animation
        let randomHoney = Int.random(in: 1...20)
        RandomHoney = randomHoney
        
        // Update the total honey
        Honey += RandomHoney
        
        enableBasicHivePurchase()  // Check if the purchase button should be enabled after honey is generated
        
    }
    
    // a basic function to check the value of honey
    // if the value of honey is >= BasicHiveCost
    // set buyBasicHivebButton = true
    // if the value of honey basicHiveCost < set buyBasicHivebButton = true
    
    var basicHiveCost: Int = 100 // cost of a basic hive
    @Published var buyBasicHiveButton: Bool = false // controls button state
    
    // Enable or disable the hive purchase button
        func enableBasicHivePurchase() {
            buyBasicHiveButton = Honey >= basicHiveCost
        }
        
        // Handle the purchase of a basic hive
        func purchaseBasicHive() {
            if buyBasicHiveButton {
                Honey -= basicHiveCost
                basicHives += 1
                enableBasicHivePurchase()  // Re-check if further purchases are allowed after purchase
            }
            checkForRestartSpawningBees()
        }
    
    
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    // ! This section handles the animation of the bees
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    func startPositionUpdate(for bee: BeeGameObject) {
        let duration = bee.speed
        let stepSize = 0.016  // Approximately 60 FPS
        let totalSteps = duration / stepSize
        let yStep = 1200 / totalSteps  // Amount to move per step
        
        timers[bee.id] = Timer.scheduledTimer(withTimeInterval: stepSize, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // Find the bee by its ID instead of relying on the index
            guard let beeIndex = self.beeGameObjects.firstIndex(where: { $0.id == bee.id }) else {
                self.stopPositionUpdate(for: bee)
                return
            }
            
            // Update the yPosition of the bee
            if self.beeGameObjects[beeIndex].yPosition > -100 {
                self.beeGameObjects[beeIndex].yPosition -= yStep  // Move upward gradually
            } else {
                self.beeGameObjects[beeIndex].yPosition = 1200
            }
        }
    }
    
    
    // Stop the position update (animation) for a specific bee
    func stopPositionUpdate(for bee: BeeGameObject) {
        timers[bee.id]?.invalidate()
        timers.removeValue(forKey: bee.id)
    }
    
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    // ! This Section handles the saving and loading of gamestate variables.
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    // Save the beeGameObjects array to @AppStorage as a JSON string
    func saveBeeGameObjects() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(beeGameObjects) {
            beeGameObjectsData = String(data: encoded, encoding: .utf8) ?? ""
        }
    }
    
    // Load the beeGameObjects array from @AppStorage (JSON string)
    func loadBeeGameObjects() {
        if let jsonData = beeGameObjectsData.data(using: .utf8) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([BeeGameObject].self, from: jsonData) {
                beeGameObjects = decoded
                
                // Restart position updates for existing bees
                for bee in beeGameObjects {
                    startPositionUpdate(for: bee)
                }
            }
        }
    }
    
    
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    // ! This section is for handling the shop and rewards
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    @Published var isShopPresented: Bool = false  // Control the visibility of the sheet
    
    func SummonShop(){
        
        isShopPresented.toggle()
        
        print("the value of shop is \(isShopPresented)")
    }
    
    
    
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    // ! This section is for development testing functions
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    func hardReset(delay: TimeInterval = 0.2){
        // Stop all timers for bees
        for bee in beeGameObjects {
            stopPositionUpdate(for: bee)
            
        }
        
        // Delay the removal of all bees
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            // Clear the array
            self.beeGameObjects.removeAll()
            self.saveBeeGameObjects()  // Save to AppStorage after removing
            print("All bees removed")
            print("Bees in beeGameObjects = \(self.beeGameObjects.count)")
            self.Honey = 0
            self.basicHives = 1
            
            // Check if we need to restart the spawning bees process
            self.checkForRestartSpawningBees()
        }
    }
}
