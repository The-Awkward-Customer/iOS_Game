
//  Created by Peter Abbott on 09/09/2024.
//

import SwiftUI

@main
struct BumbleBoogie: App {
    

    @StateObject private var gameState = GameState()
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(gameState)

        }
    }
}
