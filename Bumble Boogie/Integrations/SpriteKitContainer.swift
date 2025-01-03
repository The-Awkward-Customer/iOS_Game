//
//  SpriteKitContainer.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 31/12/2024.
//

import SwiftUI
import SpriteKit

struct SpriteKitContainer: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //        code
    }
    
    
    let scene: SKScene
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let skView = SKView(frame: viewController.view.bounds)
        skView.presentScene(scene)
        viewController.view.addSubview(skView)
        return viewController
    }
    
}
