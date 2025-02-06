
//  Created by Peter Abbott on 09/09/2024.
//

import SwiftUI

@main
struct Conditional_RenderingApp: App {
    

    @StateObject private var gameState = GameState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environmentObject(gameState)

        }
    }
}
