//
//  GameDelegate.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 30/12/2024.
//

import Foundation

protocol GameDelegate: AnyObject {
    func updateCurrency(by amount: Int)
    func handleEvent(event: String)
}
