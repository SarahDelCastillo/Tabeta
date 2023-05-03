//
//  UserDefaults.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import Foundation

extension UserDefaults: UserDefaultsProtocol {
    private enum Keys: String {
        case userId
        case userExists
    }
    
    public var userId: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.userId.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.userId.rawValue)
        }
    }
    
    public var userExists: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.userExists.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.userExists.rawValue)
        }
    }
}
