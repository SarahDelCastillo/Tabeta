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
            } catch let error as TabetaAuthError {
                let alert = makeAlertViewController(title: "Error", message: error.message)
                presentAlertViewController(alert)
                logger.error("Sign in failed with error: \(error)")
            }
        }
    }
    
    func register(with credentials: UserCredentials) {
        Task {
            do {
                try await authManager.createUser(with: credentials)
                navigationController.setViewControllers([makeMainViewController()], animated: true)
            } catch let error as TabetaAuthError {
                let alert = makeAlertViewController(title: "Error", message: error.message)
                presentAlertViewController(alert)
                logger.error("Register failed with error: \(error)")
            }
        }
    }
}
