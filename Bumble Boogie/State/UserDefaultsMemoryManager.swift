//
//  UserDefaultsMemoryManager.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 03/01/2025.
//

import Foundation


class UserDefaultsMemoryManager {
    static let shared = UserDefaultsMemoryManager() // singleton instance
    private let defaults = UserDefaults.standard
    
    enum Keys: String {
        case TotalHoney
        //Other values…
    }
    
    func set<T>(_ value: T, forKey key: Keys) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    func get<T>(forKey key: Keys) -> T? {
        return defaults.value(forKey: key.rawValue) as? T
    }
    
    func setCodable<T: Codable>(_ value: T, forKey Key: Keys){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            defaults.set(encoded, forKey: Key.rawValue)
        }
    }
    
    func getCodable<T: Codable>(forKey key: Keys, as type: T.Type) -> T? {
        guard let data = defaults.data(forKey: key.rawValue) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
    
    func remove(forKey key: Keys) {
        defaults.removeObject(forKey: key.rawValue)
    }
    
}
