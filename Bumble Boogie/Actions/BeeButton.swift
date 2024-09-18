//
//  BeeButton.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 18/09/2024.
//

import SwiftUI
struct BeeButton: View {
    var bee: GameState.BeeGameObject
    var onRemove: (GameState.BeeGameObject) -> Void
    
    var body: some View {
        Button(action: {
            onRemove(bee)  // Call the remove action
        }) {
            Image("beeImage")
                .resizable()
                .frame(width: 44, height: 44)
        }
        .position(x: bee.xPosition, y: bee.yPosition)
    }
}

