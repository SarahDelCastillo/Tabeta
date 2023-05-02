//
//  SceneDelegate+Auth.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import Foundation

extension SceneDelegate {
    func logout() throws {
        try authManager.logout()
        navigationController.setViewControllers([makeAuthViewController()], animated: true)
    }
    
    func signIn(with credentials: UserCredentials) {
        Task {
            do {
                try await authManager.signIn(with: credentials)
                navigationController.setViewControllers([makeMainViewController()], animated: true)
            } catch {
                
            }
        }
    }
    
    func register(with credentials: UserCredentials) {
        Task {
            do {
                try await authManager.createUser(with: credentials)
                navigationController.setViewControllers([makeMainViewController()], animated: true)
            } catch {
                
            }
        }
    }
}
