
//  Created by Peter Abbott on 09/09/2024.
//

import SwiftUI

@main
struct Conditional_RenderingApp: App {
    
    // Create one manager for the entire app
    @StateObject private var gameTimeManager = GameTimeManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(gameState: GameState())
                .preferredColorScheme(.light)
            
                // Provide it to the entire SwiftUI environment
                .environmentObject(gameTimeManager)
        }
    }
}
