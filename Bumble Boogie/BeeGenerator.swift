import SwiftUI

// Bee model to track position and speed
struct Bee: Identifiable {
    let id = UUID()  // Unique ID for each bee
    var xPosition: CGFloat  // X position (randomized)
    var yPosition: CGFloat  // Y position (starts at screen bottom)
    var speed: Double  // Speed of animation
}

struct BeeGenerator: View {
    @ObservedObject var gameState = GameState()  // Track the number of bees
    
    @State private var beeObjects: [Bee] = []  // Bee objects for animation
    @State private var screenHeight: CGFloat = 0  // Screen height for animation
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Render the bees as Image views
                ForEach(beeObjects) { bee in
                    Image("beeImage")  // Replace with actual bee image
                        .resizable()
                        .frame(width: 40 , height: 40)
                        .position(x: bee.xPosition, y: bee.yPosition)  // Dynamic position
                        .onAppear {
                            moveBeeUpwards(bee: bee)
                        }
                }
            }
            .onAppear {
                screenHeight = geometry.size.height  // Get screen height on appear
                updateBees()  // Initialize the bees based on game state
            }
            .onChange(of: gameState.Bees) { newBeeCount in
                updateBees()  // Adjust bees when the number changes
            }
        }
    }
    
    // Function to adjust the bees to match gameState.Bees
    func updateBees() {
        let currentBeeCount = beeObjects.count
        let newBeeCount = gameState.Bees
        
        if newBeeCount > currentBeeCount {
            // Append new bees if the count increased
            let newBees = (0..<(newBeeCount - currentBeeCount)).map { _ in
                Bee(xPosition: randomXPosition(),
                    yPosition: screenHeight,  // Start at the bottom of the screen
                    speed: randomSpeed())
            }
            beeObjects.append(contentsOf: newBees)
        } else if newBeeCount < currentBeeCount {
            // Remove excess bees if the count decreased
            beeObjects.removeLast(currentBeeCount - newBeeCount)
        }
    }
    
    // Function to randomly generate an X position for bees
    func randomXPosition() -> CGFloat {
        CGFloat.random(in: 0...UIScreen.main.bounds.width)
    }
    
    // Function to randomly generate a speed for bees
    func randomSpeed() -> Double {
        Double.random(in: 3...6)  // Random speed between 3 to 6 seconds
    }
    
    // Function to animate the bee moving upwards off the screen, then reset its position
    func moveBeeUpwards(bee: Bee) {
        if let index = beeObjects.firstIndex(where: { $0.id == bee.id }) {
            // Animate the bee to the top of the screen
            withAnimation(.linear(duration: bee.speed)) {
                beeObjects[index].yPosition = 0  // Move to the top
            }
            
            // After the bee reaches the top, reset its Y position to the bottom
            DispatchQueue.main.asyncAfter(deadline: .now() + bee.speed) {
                beeObjects[index].yPosition = screenHeight  // Reset to bottom
                beeObjects[index].xPosition = randomXPosition()  // Reset to a new random X position
                moveBeeUpwards(bee: beeObjects[index])  // Recursive call to animate the bee again
            }
        }
    }
}

#Preview {
    BeeGenerator()
}
