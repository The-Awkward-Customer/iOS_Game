//
//  UpgradeTile.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 06/02/2025.
//

import SwiftUI




struct UpgradeTile: View {
    @EnvironmentObject var gameState: GameState
    
    let title: String
    let description: String
    let cost: Int
    let currentValue: String
    let canAfford: Bool
    let action: () -> Void
    
    
    private let cornerRadius: CGFloat = 12
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text(title)
                .font(.custom("Bloxic", size: 20))
            
            Text(description)
                .font(.custom("Bloxic", size: 16))
                .foregroundColor(.gray)
            
            Text(currentValue)
                .font(.custom("Bloxic", size: 16))
            
            HStack {
                HStack {
                    costview
                }
                
                Spacer()
                
                purchaseButton
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    
    
    //MARK: - Subviews
    private var costview: some View {
        HStack(spacing: 8) {
            Image("honeyIcon")
                .resizable()
                .frame(width: 24, height: 24)
            
            Text("\(cost)")
                .font(.custom("Bloxic", size: 18))
                .foregroundStyle(ColorSet.semantic.foregroundAccentPrimary)
        }
    }
    
    private var purchaseButton: some View {
        CustomGameButton(
            title: "Purchase",
            action: action,
            isEnabled: canAfford
        )
    }
}



// MARK: - Preview Provider
struct UpgradeTile_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Affordable Preview
            UpgradeTile(
                title: "Faster Bees",
                description: "Increases bee spawn rate",
                cost: 100,
                currentValue: "Current: 1.0s",
                canAfford: true,
                action: { print("Purchase action") }
            )
            .previewDisplayName("Can Afford")
            
            // Cannot Afford Preview
            UpgradeTile(
                title: "Faster Bees",
                description: "Increases bee spawn rate",
                cost: 1000,
                currentValue: "Current: 1.0s",
                canAfford: false,
                action: { print("Purchase action") }
            )
            .previewDisplayName("Cannot Afford")
        }
        .padding()
        .environmentObject(GameState())
        .previewLayout(.sizeThatFits)
    }
}
