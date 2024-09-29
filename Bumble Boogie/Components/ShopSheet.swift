//
//  ShopView.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 26/09/2024.
//

import SwiftUI

struct ShopSheet: View {
    
    @ObservedObject var gameState = GameState()
    
    
    var body: some View {
            VStack {
                Image("beeImage")
                    .resizable()
                    .frame(width: 44 , height: 44)
                ResetBtn(gameState: gameState)
                RewardsButton(gameState: gameState)
                
                Spacer()
                // Add your shop items or content here
                
                IconButton(iconName: "xmark.circle.fill", action: {
                    gameState.isShopPresented = false  // Directly close the shop
                    print("the value of isShopPresented is: \(gameState.isShopPresented)")
                },
                           showBadge: false)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)  // Ensure full width and height
            .padding(24)
                   .background(Color.white)  // Add a background color
                   .cornerRadius(30)  // Custom corner radius
                   .ignoresSafeArea()  // Remove the default padding in the sheet
        
                
    }
}

#Preview {
    ShopSheet()
}
