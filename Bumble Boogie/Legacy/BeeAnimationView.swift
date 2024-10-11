//import SwiftUI
//
//struct BeeAnimationView: View {
//    var bee: GameState.BeeGameObject
//    var onRemove: (GameState.BeeGameObject) -> Void
//
//    @State private var currentYPosition: CGFloat = 600
//
//    var body: some View {
//        ZStack {
//            // Fixed hit area (transparent background for tap detection)
//            Button(action: {
//                onRemove(bee)  // Call the remove action
//            }) {
//                Text("🐝 Bee")
//                    .padding()
//                    .background(Color.yellow)
//                    .cornerRadius(10)
//            }
//            .allowsHitTesting(true)  // Allows hit testing regardless of animation
//            .opacity(0)  // Keep the hit area transparent
//            .frame(width: 100, height: 100)  // Define the interactive hitbox area
//            
//            // Animating bee element (just for visual animation)
//            Text("🐝 Bee")
//                .padding()
//                .background(Color.yellow)
//                .cornerRadius(10)
//                .position(x: bee.xPosition, y: currentYPosition)  // Position bee by currentYPosition
//                .onAppear {
//                    withAnimation(.easeInOut(duration: bee.speed)) {
//                        currentYPosition = 0  // Animate upwards
//                    }
//                }
//        }
//    }
//}
//
//#Preview {
//    let mockBee = GameState.BeeGameObject(
//        id: UUID(),
//        xPosition: 150,
//        yPosition: 600,
//        speed: 3.0
//    )
//
//    BeeAnimationView(bee: mockBee, onRemove: { _ in
//        print("Bee removed!")
//    })
//}
