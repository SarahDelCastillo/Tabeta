//
//  SceneDelegate+Auth.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import Foundation
import UserNotifications

extension SceneDelegate {
    /// Handles the logout action from the authManager.
    func logout() throws {
        try authManager.logout()
        UNUserNotificationCenter.removeAllPendingNotifications()
        navigationController.setViewControllers([makeAuthViewController()], animated: true)
    }
    
    /// Handles the signIn action from the authManager.
    /// - Parameter credentials: The UserCredentials structure to give to the manager.
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
    
    /// Handles the register action from the authManager.
    /// - Parameter credentials: The UserCredentials structure to give to the manager.
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
