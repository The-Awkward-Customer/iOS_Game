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

    @AppStorage ("Honey") var Honey: Int = 0
    @AppStorage ("HoneyPerTap") var HoneyPerTap: Int = 1
    @AppStorage ("HoneyPerSecond") var HoneyPerSecond: Int = 1
    @Published var canBuyBee: Bool = true
    
    
    var timer: Timer?
    
    
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
            xPosition: CGFloat.random(in: 0...300),
            yPosition: CGFloat.random(in: 0...600),
            speed: Double.random(in: 1...10)
        )
        beeGameObjects.append(newBee)
        saveBeeGameObjects()  // Save to AppStorage after adding
        print("bees in beeGameObject = \(beeGameObjects.count)")
    }
    
    
    // Remove a specific bee from the array
       func removeBee(bee: BeeGameObject) {
           beeGameObjects.removeAll { $0.id == bee.id }
           saveBeeGameObjects()  // Save to AppStorage after removing
           print("bees removed")
           print("bees in beeGameObject = \(beeGameObjects.count)")
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
            }
        }
        
        
        
        
    }
    
}




//
//
//        func HoneyWatcher(){
//            if (Honey >= Bees*2){
//                canBuyBee = true
//            } else {
//                canBuyBee = false
//            }
//        }
//
//        //    func startTimer(){
//        //        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] _ in self?.updateCounter()}
//        //        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) {[weak self] _ in self?.HoneyWatcher()}
//        //    }
//
//        func updateCounter(){
//            Honey += Bees
//        }
//
//        func BuyABee(){
//            Bees += 1
//            Honey -= Bees
//            let generator = UIImpactFeedbackGenerator(style: .heavy)
//            generator.impactOccurred()  // Trigger the haptic feedback
//            print("Bee purchased")
//
//        }
//
//        func HarvestHoney(){
//            Honey += HoneyPerTap
//
//            let generator = UIImpactFeedbackGenerator(style: .medium)
//            generator.impactOccurred()  // Trigger vibration
//        }
//
//        func resetCookies() {
//            Honey = 0
//            Bees = 1
//        }
//
//        func BasicBeeTapped() {
//            print("Bee Tapped")
//        }
