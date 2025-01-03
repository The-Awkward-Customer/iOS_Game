////
////  BeeGameView.swift
////  BumbleBoogie
////
////  Created by Peter Abbott on 11/10/2024.
////
//
//import SwiftUI
//import SpriteKit
//
//struct BeeGameView: View {
//    
//    @ObservedObject var gameState = GameState()
//    @State private var scene: BeeScene = BeeScene()
//    
//    init() {
//            // Configure the scene once
//            scene.size = UIScreen.main.bounds.size
//            scene.scaleMode = .resizeFill
//            scene.gameDelegate = gameState
//        }
//
//    var body: some View {
//            ZStack {
//                SpriteView(scene: scene)
//                    .ignoresSafeArea()
//                
//                // Overlay the honey amount
//                VStack {
//                    HStack {
//                        Text("Honey: \(gameState.Honey)")
//                            .font(.largeTitle)
//                            .padding()
//                        Spacer()
//                    }
//                    Spacer()
//                }
//            }
//        }
//}
//
//#Preview {
//    BeeGameView()
//}
