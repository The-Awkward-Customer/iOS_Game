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
    @AppStorage ("Cookies") var Cookies: Int = 0
    @AppStorage ("CookiesPerTap") var CookiesPerTap: Int = 1
    @AppStorage ("CookiesPerSecond") var CookiesPerSecond: Int = 1
    var timer: Timer?
    
    
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] _ in self?.updateCounter()}
    }
    
    func updateCounter(){
        Cookies += CookiesPerSecond
        print("Cookies Updated to \(Cookies)")
    }
    
    
    func buyCookies(){
        Cookies += CookiesPerTap
        print("Cookie Purchased")
        print(Cookies)
        print(CookiesPerTap)
        let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()  // Trigger vibration
    }
    
    func resetCookies() {
        Cookies = 0
    }
}
