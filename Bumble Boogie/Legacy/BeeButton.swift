////
////  BeeButton.swift
////  BumbleBoogie
////
////  Created by Peter Abbott on 18/09/2024.
////
//
//import SwiftUI
//struct BeeButton: View {
//    
//    @ObservedObject var gameState = GameState()
//    @ObservedObject var bee: BeeGameObject
//    
//    
//    var onRemove: (BeeGameObject) -> Void
//    
//    //    State for Bee Animation
//    @State private var beeSize: CGFloat = 56  // Track the yOffset for the animation
//    @State private var beeOpacity: Double = 0 // sets the initial opacity for the imported badge element
//    
//    
//    
//    
//    var body: some View {
//        ZStack{
//            Button(action: {
//                onRemove(bee)  // Call the remove action
//                gameState.generateHoney()
//                TappedAnimation()
//            }) {
//                Image("beeImage")
//                    .resizable()
//                    .frame(width: beeSize, height: beeSize)
//            }
//            
//            .animation(.spring(duration: 0.3), value: beeSize)  // Smooth animation for y position change
//            .animation(.linear(duration: 0.3), value: beeOpacity)  // Smooth animation for y position change
//            
//            .position(x: bee.xPosition, y: bee.yPosition)
//            .onAppear {
//                gameState.startPositionUpdates()  // Start manual position update when the view appears
//            }
//            .onDisappear {
//                gameState.stopPositionUpdates()  // Stop the timer when the view disappears
//            }
//        }
//    }
//    
////        animates the bee
//    func TappedAnimation(){
//        beeSize = 0
//        beeOpacity = 0
//        
//        // Trigger light impact haptic feedback
//        let impactLight = UIImpactFeedbackGenerator(style: .light)
//        impactLight.impactOccurred()
//        
//        print("animation successfull")
//        
////        // After a delay, end the animation (simulating a rolling effect)
////        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
////            self.beeSize = 0
////            self.beeOpacity = 0
////            
////        }
//        
//    }
//    
//    
//}
//
//
//#Preview {
//    // Create a mock GameState instance and a sample bee
//    let mockGameState = GameState()
//    let mockBee = BeeGameObject(
//        id: UUID(),
//        xPosition: 150,  // Example x position
//        yPosition: 300,  // Example y position
//        speed: 5.0,       // Example speed
//        oscillationPhase: 0,  // Start with a zero phase for the sine wave
//        amplitude: CGFloat.random(in: 0.1...0.5),  // Random amplitude for each bee
//        frequency: CGFloat.random(in: 0.1...0.2)  // Random frequency for each bee
//        
//    )
//    
//    BeeButton(
//        gameState: mockGameState,
//        bee: mockBee,
//        onRemove: { bee in
//            print("Bee removed: \(bee.id)")
//        }
//    )
//}
