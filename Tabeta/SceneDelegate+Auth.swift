//
//  SceneDelegate+Auth.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import Foundation

extension SceneDelegate {
    func logout() {
        Task {
            try authManager.logout()
            navigationController.setViewControllers([signInViewController], animated: true)
        }
    }
    func signIn(with credentials: UserCredentials) {
        Task {
            do {
                try await authManager.signIn(with: credentials)
                navigationController.setViewControllers([mainTableViewController], animated: true)
            } catch {
                
            }
        }
    }
    
    func register(with credentials: UserCredentials) {
        Task {
            do {
                try await authManager.createUser(with: credentials)
                navigationController.setViewControllers([mainTableViewController], animated: true)
            } catch {
                
            }
        }
    }
}
