//
//  ProgressView.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 12/02/2025.
//

import SwiftUI



struct ProgressView: View {
    @EnvironmentObject var gameState: GameState
    
    var isButton: Bool = false
    var canUpgrade: Bool = false
    var action: (() -> Void)?
    
    @State private var indicatorVisiblity: CGFloat = 1.0
    
    
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            progressIndicator
            
            if canUpgrade {
                upgradeIndicator
                    .offset(x: 0, y: -4) // Fine-tune position
            }
        }
    }
}


//MARK: - Subviews
extension ProgressView {
    
    
    private var progressIndicator: some View {
        Group {
            if isButton {
                Button(action: {
                    action?()
                }) {
                    progressContent
                }
                
            } else {
                progressContent
            }
        }
    }
    
    private var progressContent : some View {
        HStack {
            Image("honeyIcon")
                .resizable()
                .frame(width: 32, height: 32)
            Text("\(gameState.TotalHoney)")
                .font(.custom("JetBrainsMono-Bold", size: 24))
                .foregroundStyle(ColorSet.semantic.foregroundPrimary)
        }
        .padding(16)
        .background(ColorSet.semantic.backgroundintervse)
        .cornerRadius(24)
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(ColorSet.semantic.borderPrimary, lineWidth: 1))
        
    }
    
    
    //some logic to adjust the size and opacity with easing if canUpgrade is passed as true
    private var upgradeIndicator : some View {
        Circle()
            .fill(ColorSet.semantic.foregroundAlert)
            .frame(width: 16, height: 16)
            .padding(.leading, 8)
            .scaleEffect(indicatorVisiblity)
            .opacity(canUpgrade ? 1 : 0)
            .animation(.spring(response: 0.4, dampingFraction: 0.2, blendDuration: 0).repeatForever(autoreverses: true),value: indicatorVisiblity)
            .onAppear {
                if canUpgrade {
                    withAnimation {
                        indicatorVisiblity = 1.1
                    }
                }
            }
    }
}



// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        ProgressView()
            .environmentObject(GameState())
        
        ProgressView(isButton: true, canUpgrade: true)
            .environmentObject(GameState())
        
        ProgressView(isButton: true)
            .environmentObject(GameState())
        
        ProgressView(canUpgrade: true)
            .environmentObject(GameState())
    }
    .padding()
}
