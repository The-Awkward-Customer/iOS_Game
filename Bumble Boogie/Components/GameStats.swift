//
//  GameStats.swift
//  Conditional Rendering
//
//  Created by Peter Abbott on 11/09/2024.
//

import SwiftUI

struct GameStats: View {
    
    @ObservedObject var gameState: GameState  // Reference the game state
    
    var body: some View {
        HStack(alignment: .center) {
            HStack (alignment: .center)  {
                Image("icon-honey")
                    .resizable()
                    .frame(width: 24, height: 24)
                Spacer()
                    .frame(width:4)
                Text("\(gameState.Honey)")  // Display the count value
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            .padding(.leading, 12)
            .padding(.trailing, 16)
        }
        .frame(height: 40)
        .background(Color("bg-basic"))
        .cornerRadius(100)
        .overlay(
            RoundedRectangle(cornerRadius: 100)
                .stroke(Color("bdr-primary"), lineWidth: 2)
        )
        

    }
}

#Preview {
    GameStats(gameState: GameState())
}
