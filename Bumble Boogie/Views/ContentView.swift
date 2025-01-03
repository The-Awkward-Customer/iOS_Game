//
//  ContentView.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 03/01/2025.
//

import Foundation

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var gameState = GameState()
    
    var body: some View {
        VStack {
            Text("Currency: \(gameState.TotalHoney)")
                .padding(24)
                .font(.custom("Bloxic", size: 28))
            
            Spacer()
            
            CustomGameButton(title: "Add Currency", action: {
                gameState.increaseTotalHoney(by: 10)
            })
            
            CustomGameButton(title: "Remove Currency", action: {
                gameState.decreaseTotalHoney(by: 20)
            })
            
            
            SpriteKitContainer(scene: MainGameScene())
                .frame(height: 0)
        }
        .environmentObject(gameState)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(gameState: GameState())
    }
}
