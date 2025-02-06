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
                        ShopItemView(
                            title: "purchase Bee Spawn",
                            description: "Decrease spawn interval by 0.2 seconds",
                            cost: gameState.UpgradeCost,
                            currentValue: "Current: \(String(format: "%.1f", gameState.basicBeeSpawnInterval))s",
                            canAfford: gameState.TotalHoney >= gameState.UpgradeCost,
                            action: {
                                
                            }
                        )
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
    
    
    
    
    // Reusable shop item component
    struct ShopItemView: View {
        @EnvironmentObject var gameState: GameState
        
        let title: String
        let description: String
        let cost: Int
        let currentValue: String
        let canAfford: Bool
        let action: () -> Void
        
        var body: some View {
            
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                
                
                Text(description)
                    .foregroundColor(.gray)
                
                Text(currentValue)
                
                HStack {
                    HStack {
                        Image(systemName: "honeycomb")
                            .foregroundColor(.yellow)
                        Text("\(cost)")
                    }
                    
                    Spacer()
                    CustomGameButton(title: "Purchase for \(gameState.UpgradeCost)", action: action, isEnabled: canAfford ? true : false)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
}
    
    #Preview {
        ShopView()
            .environmentObject(GameState())
    }
