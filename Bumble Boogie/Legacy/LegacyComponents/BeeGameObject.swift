////
////  BeeGameObject.swift
////  BumbleBoogie
////
////  Created by Peter Abbott on 11/10/2024.
////
//
//import Foundation
//
//import Foundation
//import SwiftUI
//
//class BeeGameObject: Identifiable, ObservableObject, Codable {
//    let id: UUID
//    @Published var xPosition: CGFloat
//    @Published var yPosition: CGFloat
//    var speed: Double
//    var oscillationPhase: Double
//    var amplitude: CGFloat
//    var frequency: CGFloat
//
//    enum CodingKeys: CodingKey {
//        case id, xPosition, yPosition, speed, oscillationPhase, amplitude, frequency
//    }
//
//    init(id: UUID, xPosition: CGFloat, yPosition: CGFloat, speed: Double, oscillationPhase: Double, amplitude: CGFloat, frequency: CGFloat) {
//        self.id = id
//        self.xPosition = xPosition
//        self.yPosition = yPosition
//        self.speed = speed
//        self.oscillationPhase = oscillationPhase
//        self.amplitude = amplitude
//        self.frequency = frequency
//    }
//
//    // Implement Codable manually because of @Published properties
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(UUID.self, forKey: .id)
//        xPosition = try container.decode(CGFloat.self, forKey: .xPosition)
//        yPosition = try container.decode(CGFloat.self, forKey: .yPosition)
//        speed = try container.decode(Double.self, forKey: .speed)
//        oscillationPhase = try container.decode(Double.self, forKey: .oscillationPhase)
//        amplitude = try container.decode(CGFloat.self, forKey: .amplitude)
//        frequency = try container.decode(CGFloat.self, forKey: .frequency)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(xPosition, forKey: .xPosition)
//        try container.encode(yPosition, forKey: .yPosition)
//        try container.encode(speed, forKey: .speed)
//        try container.encode(oscillationPhase, forKey: .oscillationPhase)
//        try container.encode(amplitude, forKey: .amplitude)
//        try container.encode(frequency, forKey: .frequency)
//    }
//}
