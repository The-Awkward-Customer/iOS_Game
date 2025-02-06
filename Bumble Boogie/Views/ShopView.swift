//
//  ShopView.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 06/02/2025.
//

import SwiftUI

struct ShopView: View {
    
    @EnvironmentObject var gameState: GameState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Text("Honey: \(gameState.TotalHoney)")
                        .font(.custom("Bloxic", size: 24))
                        .foregroundStyle(ColorSet.semantic.foregroundAccentPrimary)
                    Image("honeyIcon")
                        .resizable()
                        .frame(width: 48, height: 48)
                }
                
                
                Spacer()
                
                ScrollView{
                    VStack (spacing : 24){
                        
                        UpgradeTile(title: "upgrade 1", description: "Does what?", cost: 1000, currentValue: "2000", canAfford: true, action: {print("purchased 1")})
                        
                        UpgradeTile(title: "upgrade 2", description: "Does what?", cost: 1000, currentValue: "2000", canAfford: true, action: {print("purchased 2")})
                        
                        UpgradeTile(title: "upgrade 3", description: "Does what?", cost: 1000, currentValue: "2000", canAfford: true, action: {print("purchased 1")})
                        
                        UpgradeTile(title: "upgrade 4", description: "Does what?", cost: 1000, currentValue: "2000", canAfford: true, action: {print("purchased 4")})
                        
                    }
                }
                
            }
            .padding(24)
            .navigationTitle("Upgrade Shops")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        gameState.resumeGame()
                        dismiss()
                    }
                    .foregroundStyle(ColorSet.semantic.foregroundAccentPrimary)
                }
                
            }
        }
    }
}
    
    #Preview {
        ShopView()
            .environmentObject(GameState())
    }
