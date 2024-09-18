//
//  BeeButton.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 18/09/2024.
//

import SwiftUI
struct BeeButton: View {
    
    @ObservedObject var gameState = GameState()
    
    var bee: GameState.BeeGameObject
    var onRemove: (GameState.BeeGameObject) -> Void
    

    
    var body: some View {
        ZStack{
            Button(action: {
                onRemove(bee)  // Call the remove action
            }) {
                Image("beeImage")
                    .resizable()
                    .frame(width: 44, height: 44)
                
            }
            .position(x: bee.xPosition, y: bee.yPosition)
            .onAppear {
                gameState.startPositionUpdate(for:bee)  // Start manual position update when the view appears
            }
            .onDisappear {
                gameState.stopPositionUpdate(for:bee)  // Stop the timer when the view disappears
            }
        }
    }
}
