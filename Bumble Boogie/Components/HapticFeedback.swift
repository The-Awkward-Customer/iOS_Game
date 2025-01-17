//
//  HapticFeedback.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 17/01/2025.
//

import Foundation
import UIKit

class GenericHapticFeedback {
    
    /// Generates a light impact haptic feedback.
        static func lightImpact() {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
        
        /// Generates a medium impact haptic feedback.
        static func mediumImpact() {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
        }
        
        /// Generates a heavy impact haptic feedback.
        static func heavyImpact() {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()
        }
        
        /// Generates a notification haptic feedback.
        static func notificationFeedback(of type: UINotificationFeedbackGenerator.FeedbackType) {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    
}
