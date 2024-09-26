//
//  BeeButton.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 18/09/2024.
//

import SwiftUI
struct BeeButton: View {
    
    @ObservedObject var gameState = GameState()
    
    var bee: GameState.BeeGameObject
    var onRemove: (GameState.BeeGameObject) -> Void
    
    //    State for Bee Animation
    @State private var beeSize: CGFloat = 44  // Track the yOffset for the animation
    @State private var beeOpacity: Double = 0 // sets the initial opacity for the imported badge element
    
    
    
    
    var body: some View {
        ZStack{
            Button(action: {
                onRemove(bee)  // Call the remove action
                gameState.GenerateHoney()
                TappedAnimation()
            }) {
                Image("beeImage")
                    .resizable()
                    .frame(width: beeSize, height: beeSize)
            }
            
            .animation(.spring(duration: 0.3), value: beeSize)  // Smooth animation for y position change
            .animation(.linear(duration: 0.3), value: beeOpacity)  // Smooth animation for y position change
            
            .position(x: bee.xPosition, y: bee.yPosition)
            .onAppear {
                gameState.startPositionUpdate(for:bee)  // Start manual position update when the view appears
            }
            .onDisappear {
                gameState.stopPositionUpdate(for:bee)  // Stop the timer when the view disappears
            }
        }
    }
    
//        animates the bee
    func TappedAnimation(){
        beeSize = 0
        beeOpacity = 0
        
        // Trigger light impact haptic feedback
        let impactLight = UIImpactFeedbackGenerator(style: .light)
        impactLight.impactOccurred()
        
        print("animation successfull")
        
//        // After a delay, end the animation (simulating a rolling effect)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.beeSize = 0
//            self.beeOpacity = 0
//            
//        }
        
    }
    
    
}


#Preview {
    // Create a mock GameState instance and a sample bee
    let mockGameState = GameState()
    let mockBee = GameState.BeeGameObject(
        id: UUID(),
        xPosition: 150,  // Example x position
        yPosition: 300,  // Example y position
        speed: 5.0       // Example speed
    )
    
    return BeeButton(
        gameState: mockGameState,
        bee: mockBee,
        onRemove: { bee in
            print("Bee removed: \(bee.id)")
        }
    )
}
