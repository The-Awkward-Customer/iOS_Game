//
//  BasicButton.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 30/12/2024.
//
import SwiftUI
import SpriteKit

//TODO
///Replace image with a sprite

struct CustomGameButton: View {
    var title: String
    var spriteNode: SKNode?
    var suffixImage: String?
    var action: (() -> Void)?
    var isEnabled: Bool = true
    
    @State private var isPressed: Bool = false
    
    // Constants for button styling
    private let buttonHeight: CGFloat = 48
    private let buttonDepth: CGFloat = 8
    private let cornerRadius: CGFloat = 16
    private let pressedOffset: CGFloat = 8
    
    // Style configuration structure
    struct ButtonStyleConfiguration {
        let baseColor: Color
        let capColor: Color
        let borderColor: Color
        let borderWidth: CGFloat
        let textColor: Color
    }
    
    // Style configurations for different states
    private var buttonStyle: ButtonStyleConfiguration {
        if !isEnabled {
            return ButtonStyleConfiguration(
                baseColor: ColorSet.semantic.borderDisabled,
                capColor: ColorSet.semantic.backgroundDisabled,
                borderColor: ColorSet.semantic.borderDisabled,
                borderWidth: 2,
                textColor: ColorSet.semantic.foregroundDisabled
            )
        } else if isPressed {
            return ButtonStyleConfiguration(
                baseColor: ColorSet.semantic.borderPrimary,
                capColor: ColorSet.semantic.borderPrimary,
                borderColor: ColorSet.semantic.borderPrimary,
                borderWidth: 2,
                textColor: ColorSet.semantic.foregroundInverse
            )
        } else {
            return ButtonStyleConfiguration(
                baseColor: ColorSet.semantic.borderPrimary,
                capColor: ColorSet.semantic.backgroundPrimary,
                borderColor: ColorSet.semantic.borderPrimary,
                borderWidth: 2,
                textColor: ColorSet.semantic.foregroundInverse
            )
        }
    }
    
    var body: some View {
        Button(action: {
            guard isEnabled else { return }
            
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            
            action?()
        }) {
            GeometryReader { geometry in
                ZStack {
                    // Static base layer (always at bottom)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(buttonStyle.baseColor)
                        .frame(height: buttonHeight)
                        .offset(y: isEnabled ? pressedOffset : 0)  // Always offset by 8
                    
                    // Animated top layers
                    ZStack {
                        // Button cap layer
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(buttonStyle.capColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .strokeBorder(buttonStyle.borderColor, lineWidth: buttonStyle.borderWidth)
                            )
                            .frame(height: buttonHeight)
                        
                        // Button content
                        HStack {
                            
                            if let spriteNode = spriteNode {
                                SpriteNodeView(node: spriteNode)
                            }
                            
                            Text(title)
                                .font(.custom("JetBrainsMono-bold", size: 16))
                                .foregroundStyle(buttonStyle.textColor)
                            
                            
                            if let suffixImage = suffixImage {
                                Image(suffixImage)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
    
                        }
                    }
                    .offset(y: isPressed && isEnabled ? pressedOffset : 0)
                    .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
                }
            }
            .frame(height: buttonHeight)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    guard isEnabled else { return }
                    isPressed = true
                }
                .onEnded { _ in
                    guard isEnabled else { return }
                    isPressed = false
                }
        )
        .buttonStyle(CustomButtonStyle())
        .disabled(!isEnabled)
        .padding(.bottom, 8)
    }
}

// Custom Button Style to remove default behaviors
struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}


struct CustomGameButton_Previews: PreviewProvider {
    
    // Helper function to create a bee sprite node
       static func createBasicBeeNode() -> SKNode {
           let texture = SKTexture(imageNamed: "basicBee.00000")
           let beeNode = SKSpriteNode(texture: texture)
           beeNode.size = CGSize(width: 24, height: 24)  // Smaller size for button
           return beeNode
       }
    
    
    static var previews: some View {
        VStack(spacing: 40) {
            // Basic button without sprite
            CustomGameButton(
                title: "Basic Button",
                action: {
                    print("Basic button tapped")
                }
            )
            
            // Button with longer text
            CustomGameButton(
                title: "Button with too much text",
                action: {
                    print("Button with too much text")
                }
            )
            
            
            //Button with Image as child
            CustomGameButton(
                title: "Button with image",
                suffixImage: "honeyIcon",
                action: {
                    print("button with image pressed")
                }
            )
            
//            // Button with sprite node
//            CustomGameButton(
//                title: "Button With Sprite",
//                spriteNode: createBasicBeeNode(),
//                action: {
//                    print("Sprite button tapped")
//                }
//            )
            
            // Disabled state example
            CustomGameButton(
                title: "Disabled Button",
                action: nil,
                isEnabled: false
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Default Buttons")
        
        // Dark mode preview
        VStack(spacing: 20) {
            CustomGameButton(
                title: "Dark Mode Button",
                action: {
                    print("Dark mode button tapped")
                }
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }
    
}
