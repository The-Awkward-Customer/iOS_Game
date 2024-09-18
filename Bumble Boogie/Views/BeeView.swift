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
        VStack {
            
            // Render a BeeButton for each BeeGame object
            ForEach(gameState.beeGameObjects) { bee in
                BeeButton(bee: bee, onRemove: gameState.removeBee)
            }
            
//            // Button to add a new bee
//            Button(action: gameState.addBee) {
//                Text("Add Bee")
//                    .padding()
//                    .background(Color.green)
//                    .cornerRadius(10)
//            }
        }
    }
}

#Preview {
    BeeView()
}
