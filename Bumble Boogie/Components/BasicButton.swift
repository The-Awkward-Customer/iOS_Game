//
//  BasicButton.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 30/12/2024.
//
import SwiftUI
import SpriteKit

struct CustomGameButton: View {
    var title: String
    var spriteNode: SKNode? // Optional SpriteKit element
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            VStack {
                if let spriteNode = spriteNode {
                    SpriteNodeView(node: spriteNode)
                }
                Text(title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
