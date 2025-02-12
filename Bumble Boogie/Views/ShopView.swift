//
//  ShopView.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 06/02/2025.
//

import SwiftUI

//TODO
/// Refactor to accept an array of child objects without having to define each one manually if possible
/// Implement horizontal "paginated" like scrolling to any "slim HStack children that uses a FR or Grid like approach for layout
/// Move almost everything out of the navigation view by possibly implementing a "large navigation bar" or custom navigation view

struct ShopView: View {
    
    @EnvironmentObject var gameState: GameState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Image("honeyIcon")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("\(gameState.TotalHoney)")
                        .font(.custom("JetBrainsMono-Bold", size: 24))
                        .foregroundStyle(ColorSet.semantic.foregroundInverse)
                }
                .padding(.top, 32)
                
                
                Spacer(minLength: 32)
                
                ScrollView {
                    VStack (spacing : 24){
                        UpgradeTile(
                            content: UpgradeTileContent(
                                image: "placeholderIMGH",
                                description: "Increases number of bees that spawn",
                                cost: 500,
                                currentValue: "Current Hives: 1"
                            ),
                            style: .wide,
                            canAfford: true,
                            action: { print("Purchase action") }
                        )
                        
                        HStack{
                            UpgradeTile(
                                content: UpgradeTileContent(
                                    image: "placeholderIMGV",
                                    description: "Increases number of bees that spawn",
                                    cost: 500,
                                    currentValue: "Current Hives: 1"
                                ),
                                style: .slim,
                                canAfford: true,
                                action: { print("Purchase action") }
                            )
                            UpgradeTile(
                                content: UpgradeTileContent(
                                    image: "placeholderIMGV",
                                    description: "Increases number of bees that spawn",
                                    cost: 500,
                                    currentValue: "Current Hives: 1"
                                ),
                                style: .slim,
                                canAfford: true,
                                action: { print("Purchase action") }
                            )
                            
                        }
                        HStack{
                            UpgradeTile(
                                content: UpgradeTileContent(
                                    image: "placeholderIMGV",
                                    description: "Increases number of bees that spawn",
                                    cost: 500,
                                    currentValue: "Current Hives: 1"
                                ),
                                style: .slim,
                                canAfford: true,
                                action: { print("Purchase action") }
                            )
                            UpgradeTile(
                                content: UpgradeTileContent(
                                    image: "placeholderIMGV",
                                    description: "Increases number of bees that spawn",
                                    cost: 500,
                                    currentValue: "Current Hives: 1"
                                ),
                                style: .slim,
                                canAfford: true,
                                action: { print("Purchase action") }
                            )
                            
                        }
                    }
                    
                }
                
            }
            .padding(.horizontal, 24)
            //TODO
            ///Make a resuseable style
            .background(
            LinearGradient(
            stops: [
            Gradient.Stop(color: Color(red: 0.31, green: 0.04, blue: 0.58), location: 0.00),
            Gradient.Stop(color: Color(red: 0.53, green: 0.11, blue: 0.71), location: 0.20),
            Gradient.Stop(color: Color(red: 1, green: 0.41, blue: 0.33), location: 0.40),
            Gradient.Stop(color: Color(red: 1, green: 0.68, blue: 0.24), location: 0.60),
            Gradient.Stop(color: Color(red: 0.98, green: 0.82, blue: 0.65), location: 0.80),
            Gradient.Stop(color: Color(red: 1, green: 0.92, blue: 0.8), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
            )
            )
                
            }
            
        }
    }

    
    #Preview {
        ShopView()
            .environmentObject(GameState())
    }
