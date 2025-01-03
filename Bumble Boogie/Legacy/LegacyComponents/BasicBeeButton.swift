//
////  BasicBeeButton.swift
////  BumbleBoogie
////
////  Created by Peter Abbott on 17/09/2024.
////
//
//import SwiftUI
//
//struct BasicBeeButton: View {
//    
//    @ObservedObject var gameState = GameState()
//    
//    var body: some View {
//        Button(action:{
//            gameState.addBee()
//        }) {
//            Image("beeImage")
//                .resizable()
//                .frame(width: 40, height:40)
//        }
//        .background(Color.red.opacity(0.2))
//        .zIndex(100)// Dynamic position
//    }
//    
//}
//
//
//#Preview {
//    BasicBeeButton(gameState: GameState())
//}
