//
//  IntroText.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 15/09/2024.
//

import SwiftUI


func introStylesText(_ text: String) -> some View {
    Text(text)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .foregroundColor(.black)
        .padding(.horizontal, 12)
    
    
}

struct IntroText: View {
    
    @State private var animateGradient = false
    
    
    var body: some View {
        
        ZStack {
            
            VStack (spacing: 8){
                Spacer()
                    .frame(height: 8)
                introStylesText("v0.0.02")
                introStylesText("BumbleBoogie")
                    .fontWeight(.bold)
                introStylesText("Buy bees to collect honey")
                Spacer()
                    .frame(height: 8)
            }
            .background(Color.white)
            
            .cornerRadius(32)
            .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .stroke(
                        RadialGradient(
                            gradient: Gradient(colors: [Color("PrimaryPink"), Color.white, Color("PrimaryPink")]),
                            center: .topLeading,
                            startRadius: (animateGradient ? 0 : 500),
                            endRadius: (animateGradient ? 0 : 100)
                        ),
                        lineWidth: 2
                    )
            )
        }
        .padding(.horizontal, 24)
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
    
}

#Preview {
    IntroText()
}
