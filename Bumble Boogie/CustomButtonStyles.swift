//
//  CustomButtonStyles.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 14/09/2024.
//

import SwiftUI

import SwiftUI

struct CustomButtonStyles: ButtonStyle {
    var isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isEnabled ? Color("PrimaryYellow") : Color.gray)  // Change background
            .foregroundColor(.white)
            .cornerRadius(10)
            .opacity(isEnabled ? 1 : 0.5)  // Change opacity
            .scaleEffect(configuration.isPressed ? 0.95 : 1)  // Button press effect
    }
}
