//
//  UserDefaultsMemoryManagerTests.swift
//  BumbleBoogieUnitTests
//
//  Created by Peter Abbott on 03/01/2025.
//

// FIXME
/// Unit Test failing to run

import Foundation
import XCTest
@testable import BumbleBoogie

class UserDefaultsManagerTests: XCTestCase {
    let defaultsManager = UserDefaultsMemoryManager.shared

    override func setUp() {
        super.setUp()
        // Clear UserDefaults before each test
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }

    func testSavingAndRetrievingInteger() {
        defaultsManager.set(42, forKey: .TotalHoney)
        let retrievedValue: Int? = defaultsManager.get(forKey: .TotalHoney)
        XCTAssertEqual(retrievedValue, 42, "The retrieved value should match the saved value.")
    }
}

