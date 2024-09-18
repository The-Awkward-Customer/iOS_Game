import Foundation
import SwiftUI
import UIKit

class GameState: ObservableObject {
    
    @AppStorage ("Honey") var Honey: Int = 0
    @AppStorage ("HoneyPerTap") var HoneyPerTap: Int = 1
    @AppStorage ("HoneyPerSecond") var HoneyPerSecond: Int = 1
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
    
    // In-memory array of BeeGame objects
    @Published var beeGameObjects: [BeeGameObject] = []
    
    // Add a new bee
    func addBee() {
        let newBee = BeeGameObject(
            id: UUID(),
            xPosition: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            yPosition: 0,
            speed: Double.random(in: 4...8)
        )
        beeGameObjects.append(newBee)
        saveBeeGameObjects()  // Save to AppStorage after adding
        print("bees in beeGameObject = \(beeGameObjects.count)")
        startPositionUpdate(for: newBee)  // Start animating the new bee
    }
    
    func removeBee(bee: BeeGameObject) {
        // Stop the bee's timer before removing it
        stopPositionUpdate(for: bee)
        
        // Remove the bee from the array
        beeGameObjects.removeAll { $0.id == bee.id }
        saveBeeGameObjects()  // Save to AppStorage after removing
        print("Bees removed")
        print("Bees in beeGameObjects = \(beeGameObjects.count)")
        harvestHoney()
    }
    
    
    func harvestHoney(){
        Honey += Int.random(in: 1...10)
    }
    
    
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
}
