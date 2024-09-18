//
//  HoneyHandler.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 18/09/2024.
//

import SwiftUI

struct HoneyHandler: View {
    
    @State private var localHoney: Int = 0
    @State private var addedHoney: Int = 0
    @State private var yOffset: CGFloat = 0  // Track the yOffset for the animation
    @State private var badgeOpacity: Double = 0
    
    var body: some View {
        
        VStack {
            VStack{
                Badge(text: addedHoney)
            }
            .offset(y: yOffset)
            .opacity(badgeOpacity)
            .animation(.easeInOut(duration: 1), value: yOffset)  // Smooth animation for y position change
            .animation(.easeInOut(duration: 1), value: badgeOpacity)
            Text("\(localHoney)")
                .foregroundColor(.blue)
            Button(action: {
                localAddHoney()
            }, label: {
                Text("add one")
            })
        }
    }
    
    
    func localAddHoney(){
        // Update addedHoney first before starting the animation
        let randomHoney = Int.random(in: 1...100)
        addedHoney = randomHoney
        
        // Update the total honey
        localHoney += addedHoney
        
        // Trigger the animation in the next run loop to avoid batching
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            runAnimation()
        }
    }
    
    func runAnimation(){
        yOffset = -50
        badgeOpacity = 1
        
        // After a delay, end the animation (simulating a rolling effect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.yOffset = 0
            self.badgeOpacity = 0
            
        }
        
    }
}


#Preview {
    HoneyHandler()
}
