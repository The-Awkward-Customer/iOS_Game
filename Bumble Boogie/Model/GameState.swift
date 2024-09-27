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
    func addBee() {
        let newBee = BeeGameObject(
            id: UUID(),
            xPosition: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            yPosition: 1200,
            speed: Double.random(in: 4...8)
        )
        beeGameObjects.append(newBee)
        saveBeeGameObjects()  // Save to AppStorage after adding
        print("bees in beeGameObject = \(beeGameObjects.count)")
        startPositionUpdate(for: newBee)  // Start animating the new bee
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
        }
    }
    
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    // ! This section handles the generation of honey and rewards.
    // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    func GenerateHoney(){
        // Update addedHoney first before starting the animation
        let randomHoney = Int.random(in: 1...100)
        RandomHoney = randomHoney
        
        // Update the total honey
        Honey += RandomHoney
        
        
//        // Trigger the animation in the next run loop to avoid batching
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.runAnimation() // applies a 0.1ms delay to give the
//        }
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
            }
    }
}
