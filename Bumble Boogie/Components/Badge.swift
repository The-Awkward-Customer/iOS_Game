//
//  Badge.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 18/09/2024.
//

import SwiftUI

struct Badge: View {
    
    var text: Any
    
    
    var body: some View {
        HStack {
            Text("\(text)")
                .font(.footnote)
                .fontWeight(.bold)
                .padding(.horizontal, 12)  // Horizontal padding to create the pill shape
                .padding(.vertical, 6)     // Vertical padding to control height
                .background(Color.white)    // Background color
                .foregroundColor(.black)   // Text color
                .clipShape(Capsule())      // Create the pill shape
            
                .shadow(color: Color.gray.opacity(0.5), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    Badge(text: "+3")
}
