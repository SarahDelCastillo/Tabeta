//
//  LocalAuthManager.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 02/05/2023.
//

import Foundation

public final class LocalAuthManager: TabetaAuthManager {
    var isLoggedIn: Bool { authManager.isLoggedIn }
    var userUid: String? { authManager.userUid }
    let authManager: TabetaAuthManager
    var userDefaults: UserDefaultsProtocol
    
    init(authManager: TabetaAuthManager = FirebaseAuthManager(), userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.authManager = authManager
        self.userDefaults = userDefaults
    }
    
    func createUser(with credentials: UserCredentials) async throws {
        try await authManager.createUser(with: credentials)
        userDefaults.userId = authManager.userUid
    }
    
    func signIn(with credentials: UserCredentials) async throws {
        try await authManager.signIn(with: credentials)
        userDefaults.userId = authManager.userUid
        userDefaults.userExists = true
    }
    
    func logout() throws {
        try authManager.logout()
        userDefaults.userId = nil
        userDefaults.userExists = false
    }
}
