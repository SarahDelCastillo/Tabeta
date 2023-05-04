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
    var userUid: String? { auth.currentUser?.uid }
    
    func createUser(with credentials: UserCredentials) async throws {
        do {
            try await auth.createUser(withEmail: credentials.email, password: credentials.password)
        } catch {
            let error = error as NSError
            throw handleError(error: error)
        }
        
    }
    
    func signIn(with credentials: UserCredentials) async throws {
        do {
            try await auth.signIn(withEmail: credentials.email, password: credentials.password)
        } catch {
            let error = error as NSError
            throw handleError(error: error)
        }
    }
    
    func logout() throws {
        try auth.signOut()
    }
    
    private func handleError(error: NSError) -> TabetaAuthError {
        let errorMessage: String
        let errorCode = AuthErrorCode.Code(rawValue: error.code)!
        
        switch errorCode {
        case .userDisabled:
            errorMessage = "This user's account has been disabled."
        case .userNotFound:
            errorMessage = "User not found."
        case .emailAlreadyInUse:
            errorMessage = "This email is already in use."
        case .invalidEmail:
            errorMessage = "Invalid email."
        case .wrongPassword:
            errorMessage = "Incorrect password."
        case .networkError:
            errorMessage = "Network error. Please try again"
        case .weakPassword:
            errorMessage = "The password is too weak."
        case .missingEmail:
            errorMessage = "An email is required."
        default:
            errorMessage = "Unknown error. Please try again."
        }
        
        return TabetaAuthError(message: errorMessage)
    }
}
