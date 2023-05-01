//
//  SceneDelegate.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    lazy var authManager: TabetaAuthManager = {
        FirebaseAuthManager()
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    //MARK: View controllers -
    lazy var navigationController = {
        let rootVC: UIViewController
        if authManager.isLoggedIn {
            rootVC = mainTableViewController
        } else {
            rootVC = signInViewController
        }
        return UINavigationController(rootViewController: rootVC)
    }()
    
    lazy var signInViewController: UIViewController = {
        let signInVC = AuthViewController()
        signInVC.title = "Sign in"
        signInVC.completion = signIn(with:)
        signInVC.customAction = ("Register", {
            self.navigationController.setViewControllers([self.registerViewController], animated: false)
        })
        return signInVC
    }()
    
    lazy var registerViewController: UIViewController = {
        let registerVC = AuthViewController()
        registerVC.title = "Register"
        registerVC.completion = register(with:)
        registerVC.customAction = ("Sign in", {
            self.navigationController.setViewControllers([self.signInViewController], animated: false)
        })
        return registerVC
    }()
    
    lazy var mainTableViewController: UITableViewController = {
        let mainVC = MainTableViewController()
        mainVC.title = "Tabeta"
        mainVC.logoutAction = logout
        return mainVC
    }()
}

extension SceneDelegate {
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

