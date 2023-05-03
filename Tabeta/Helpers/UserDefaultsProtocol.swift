//
//  UserDefaultsProtocol.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 03/05/2023.
//

//import Foundation

public protocol UserDefaultsProtocol {
    var userId: String? { get set }
    var userExists: Bool { get set }
}
