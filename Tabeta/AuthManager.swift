//
//  AuthManager.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import Foundation
import FirebaseAuth

protocol AuthManager {
    func createUser(with credentials: UserCredentials) async throws
    func signIn(with credentials: UserCredentials) async throws
    func logout() throws
    var isLoggedIn: Bool { get }
}

public struct UserCredentials {
    var email, password: String
}

public final class TabetaAuthManager: AuthManager {
    let auth = Auth.auth()
    var isLoggedIn: Bool { auth.currentUser != nil }
    
    func createUser(with credentials: UserCredentials) async throws {
        try await auth.createUser(withEmail: credentials.email, password: credentials.password)
    }
    
    func signIn(with credentials: UserCredentials) async throws {
        try await auth.signIn(withEmail: credentials.email, password: credentials.password)
    }
    
    func logout() throws {
        try auth.signOut()
    }
}
