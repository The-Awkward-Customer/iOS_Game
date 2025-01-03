////
////  ProgressBarView.swift
////  BumbleBoogie
////
////  Created by Peter Abbott on 16/10/2024.
////
//
//import SwiftUI
//
//struct ProgressBarView: View {
//    @ObservedObject var gameState = GameState()
//    
//    
//    var body: some View {
//        ProgressBar(progress: Float(gameState.sequenceProgress) / 3.0)
//            .frame(height: 20)
//            .padding()
//    }
//}
//
//struct ProgressBar: View {
//    var progress: Float
//    
//    var body: some View {
//        ZStack(alignment: .leading) {
//            Rectangle().frame(maxWidth: .infinity)
//                .foregroundColor(Color.gray.opacity(0.3))
//            Rectangle().frame(width: CGFloat(progress) * UIScreen.main.bounds.width)
//                .foregroundColor(Color.green)
//        }
//        .cornerRadius(10)
//        
//    }
//}
//
//#Preview {
//    ProgressBarView()
//}
