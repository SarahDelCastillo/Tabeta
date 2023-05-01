//
//  FirebaseAuthManager.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import Foundation
import FirebaseAuth

public final class FirebaseAuthManager: TabetaAuthManager {
    let auth = Auth.auth()
    var isLoggedIn: Bool { auth.currentUser != nil }
    var userUid: String { auth.currentUser!.uid }
    
    func createUser(with credentials: UserCredentials) async throws {
        try await auth.createUser(withEmail: credentials.email, password: credentials.password)
        UserDefaults.userId = userUid
    }
    
    func signIn(with credentials: UserCredentials) async throws {
        try await auth.signIn(withEmail: credentials.email, password: credentials.password)
        UserDefaults.userId = userUid
    }
    
    func logout() throws {
        try auth.signOut()
        UserDefaults.userId = nil
    }
}