//
//  BeeView.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 18/09/2024.
//

import SwiftUI

struct BeeView: View {
    
    @ObservedObject var gameState = GameState()
    
    var body: some View {
        ZStack {
            
            // Render a BeeButton for each BeeGame object
            ForEach(gameState.beeGameObjects) { bee in
                BeeButton(bee: bee, onRemove: gameState.removeBee)
            }
        }
        .onAppear(){
            gameState.loadBeeGameObjects()
        }
        
        
    }
}

#Preview {
    BeeView()
}
