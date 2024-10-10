//
//  RewardsButton.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 29/09/2024.
//

import SwiftUI

struct RewardsButton: View {
    
    @ObservedObject var gameState = GameState()
    
    var body: some View {
        Text("Tap the button to buy a hive")
        Text("The value of honey is: \(gameState.Honey)")
        Text("The value of basic hives is: \(gameState.basicHives)")
        Button(action:{
            gameState.purchaseBasicHive()
        }){
            Image(systemName: "cart.badge.plus")
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundColor(gameState.buyBasicHiveButton ? .blue : .gray)  // Change color based on availability
        }
        .disabled(!gameState.buyBasicHiveButton)  // Disable button when `buyBasicHiveButton` is false
        .onAppear {
            gameState.enableBasicHivePurchase()
        }
    }
    
}




#Preview {
    RewardsButton(gameState: GameState())
}
