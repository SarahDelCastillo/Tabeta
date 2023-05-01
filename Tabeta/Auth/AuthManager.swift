//
//  TabetaAuthManager.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import Foundation

public struct UserCredentials {
    var email, password: String
}

protocol TabetaAuthManager {
    func createUser(with credentials: UserCredentials) async throws
    func signIn(with credentials: UserCredentials) async throws
    func logout() throws
    var isLoggedIn: Bool { get }
    var userUid: String { get }
}
