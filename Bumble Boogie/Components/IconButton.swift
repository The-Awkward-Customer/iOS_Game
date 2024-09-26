//
//  ShopBtn.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 26/09/2024.
//

import SwiftUI

struct IconButton: View {
    
    var iconName: String
    var action: () -> Void // closure to define the action
    
    
    var body: some View {
        Button(action: { action()
        }) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 44 , height: 44)  // Size of the icon
                .padding()  // Padding inside the button
                .background(Circle().fill(Color("PrimaryYellow")))
                .foregroundColor(.white)  // Color of the icon
                
        }
    }
}

#Preview {
    IconButton( iconName: "bolt.fill", action: {print("Button Tapped")})
}
