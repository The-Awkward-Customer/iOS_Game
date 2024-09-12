//
//  Conditional_RenderingApp.swift
//  Conditional Rendering
//
//  Created by Peter Abbott on 09/09/2024.
//

import SwiftUI

@main
struct Conditional_RenderingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(gameState: GameState())
                .preferredColorScheme(.light)
        }
    }
}
