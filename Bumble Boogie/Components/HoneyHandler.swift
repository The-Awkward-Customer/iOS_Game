//
//  HoneyHandler.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 18/09/2024.
//

import SwiftUI

struct HoneyHandler: View {
    
    @ObservedObject var gameState = GameState()
    
    var body: some View {
        
        VStack {
            VStack{
                Badge(text: gameState.RandomHoney)
            }
            .offset(y: gameState.yOffset)
            .opacity(gameState.badgeOpacity)
            .animation(.easeInOut(duration: 1), value: gameState.yOffset)  // Smooth animation for y position change
            .animation(.easeInOut(duration: 1), value: gameState.badgeOpacity)
            Text("\(gameState.Honey)")
                .foregroundColor(.blue)
            Button(action: {
                gameState.GenerateHoney() // calls localAddHoney function -> move to gameState functions
            }, label: {
                Text("add one")
            })
        }
    }
    
    
//    func localAddHoney(){
//        // Update addedHoney first before starting the animation
//        let randomHoney = Int.random(in: 1...100)
//        addedHoney = randomHoney
//        
//        // Update the total honey
//        gameState.Honey += addedHoney
//        
//        // Trigger the animation in the next run loop to avoid batching
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            runAnimation() // applies a 0.1ms delay to give the
//        }
//    }
//    
    // move this into the BeeButton Component along with associated variables that do not need to be stored globally
//    func runAnimation(){
//        yOffset = -50
//        badgeOpacity = 1
//        
//        // After a delay, end the animation (simulating a rolling effect)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.yOffset = 0
//            self.badgeOpacity = 0
//            
//        }
//        
//    }
}


#Preview {
    HoneyHandler()
}
