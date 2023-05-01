//
//  UserDefaults.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import Foundation

extension UserDefaults {
    private enum Keys: String {
        case userId
    }
    
    public class var userId: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.userId.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.userId.rawValue)
        }
    }
}
