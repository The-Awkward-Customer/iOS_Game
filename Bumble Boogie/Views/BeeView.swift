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
        GeometryReader { geometry in
            ZStack {
                
                // Render a BeeButton for each BeeGame object
                ForEach(gameState.beeGameObjects) { bee in
                    BeeButton(bee: bee, onRemove: gameState.removeBee)
                }
            }
            .background(Color.red.opacity(0.2))
            .onAppear(){
                gameState.loadBeeGameObjects()
            }
            .frame(height: geometry.size.height + 100 )
            .ignoresSafeArea(.all)
            
            
        }
    }
}

#Preview {
    BeeView()
}
