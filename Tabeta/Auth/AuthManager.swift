//
//  AuthManager.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import Foundation

protocol AuthManager {
    func createUser(with credentials: UserCredentials) async throws
    func signIn(with credentials: UserCredentials) async throws
    func logout() throws
    var isLoggedIn: Bool { get }
}