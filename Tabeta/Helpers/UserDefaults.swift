//
//  UserDefaults.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import Foundation

extension UserDefaults {
    private enum Keys: String {
        case groupId
    }
    
    public class var groupId: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.groupId.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.groupId.rawValue)
        }
    }
}
