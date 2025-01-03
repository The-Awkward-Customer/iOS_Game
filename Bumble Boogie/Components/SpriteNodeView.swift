//
//  SpriteNodeView.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 30/12/2024.
//

import SwiftUI
import SpriteKit

struct SpriteNodeView: UIViewControllerRepresentable {
    let node: SKNode
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let sceneView = SKView(frame: viewController.view.bounds)
        let scene = SKScene(size: viewController.view.bounds.size)
        
        scene.addChild(node)
        sceneView.presentScene(scene)
        viewController.view.addSubview(sceneView)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
