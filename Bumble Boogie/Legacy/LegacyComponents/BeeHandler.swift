//import SwiftUI
//
//// BeeGame Object
//struct BeeGame: Identifiable {
//    let id: UUID
//    var xPosition: CGFloat
//    var yPosition: CGFloat
//    var speed: Double
//}
//
//// BeeButton for rendering individual bee
//struct BeeButton: View {
//    var bee: BeeGame
//    var onRemove: (BeeGame) -> Void
//    
//    var body: some View {
//        Button(action: {
//            onRemove(bee)
//        }) {
//            Text("🐝 Bee")
//                .padding()
//                .background(Color.yellow)
//                .cornerRadius(10)
//        }
//        .position(x: bee.xPosition, y: bee.yPosition)
//    }
//}
//
//struct BeeHandler: View {
//    // Store the array of BeeGame objects
//    @State private var beeGameObjects: [BeeGame] = []
//    
//    // Computed property to track the number of bees
//    var beeCount: Int {
//        beeGameObjects.count
//    }
//    
//    var body: some View {
//        VStack {
//            Text("Bee Count: \(beeCount)")
//            
//            // Render a BeeButton for each BeeGame object
//            ForEach(beeGameObjects) { bee in
//                BeeButton(bee: bee, onRemove: removeBee)
//            }
//            
//            // Button to add a new bee
//            Button(action: addBee) {
//                Text("Add Bee")
//                    .padding()
//                    .background(Color.green)
//                    .cornerRadius(10)
//            }
//        }
//    }
//    
//    // Add a new BeeGame object to the array
//    func addBee() {
//        let newBee = BeeGame(
//            id: UUID(),
//            xPosition: CGFloat.random(in: 0...300),
//            yPosition: CGFloat.random(in: 0...600),
//            speed: Double.random(in: 1...10)
//        )
//        beeGameObjects.append(newBee)
//    }
//    
//    // Remove a specific BeeGame object from the array
//    func removeBee(bee: BeeGame) {
//        beeGameObjects.removeAll { $0.id == bee.id }
//    }
//}
//
//#Preview{
//    BeeHandler()
//}
