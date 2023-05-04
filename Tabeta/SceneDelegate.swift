//
//  SceneDelegate.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import UIKit
import OSLog

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    lazy var authManager: TabetaAuthManager = {
        LocalAuthManager()
    }()
    
    lazy var logger: Logger = {
       Logger(subsystem: "com.raahs.Tabeta", category: "Main")
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
            rootVC = makeMainViewController()
        } else {
            rootVC = makeAuthViewController()
        }
        return UINavigationController(rootViewController: rootVC)
    }()
    
    func makeAuthViewController() -> UIViewController {
        let viewController = AuthViewController()
        viewController.authAction = { signInMode, credentials in
            if signInMode {
                self.signIn(with: credentials)
            } else {
                self.register(with: credentials)
            }
        }
        return viewController
    }
    
    /// Creates and cofigures a mainViewController.
    /// - Returns: The configured and ready to use controller.
    func makeMainViewController() -> UIViewController {
        guard UserDefaults.standard.userExists else {
            return makeWelcomeViewController()
        }
        let mainVC = MainTableViewController()
        mainVC.title = "Tabeta"
        mainVC.logoutAction = logout
        mainVC.taskLoader = LocalTaskLoader(taskLoader: FirebaseTaskLoader())
        mainVC.taskManager = LocalTaskManager(taskManager: FirebaseTaskManager())
        mainVC.addTaskAction = presentAddTaskViewController
        mainVC.selectTaskAction = presentEditTaskViewController
        return mainVC
    }
    
    /// Creates and configures a welcomeViewController.
    /// - Returns: The configured and ready to use controller.
    func makeWelcomeViewController() -> UIViewController {
        let welcomeVC = WelcomeViewController()
        welcomeVC.completion = createUserWithGroup(nickName:groupId:)
        return welcomeVC
    }
    
    /// Creates and confires a UIAlertViewController with the given parameters.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message of the alert.
    /// - Returns: The configured and ready to use controller.
    func makeAlertViewController(title: String, message: String) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        controller.addAction(okAction)
        return controller
    }
    
    //MARK: Actions -
    func presentAlertViewController(_ controller: UIAlertController) {
        navigationController.present(controller, animated: true)
    }
    
    /// Creates and presents an EditTaskViewController to handle task addition.
    /// - Parameter manager: The acting task manager.
    func presentAddTaskViewController(_ manager: TabeTaskManager) {
        let vc = EditTaskViewController()
        vc.titleLabel.text = "Add TabeTask"
        vc.handleSubmit = manager.create
        navigationController.present(vc, animated: true)
    }
    
    /// Creates and presents an EditTaskViewController to handle task updates.
    /// - Parameter manager: The acting task manager.
    func presentEditTaskViewController(_ manager: TabeTaskManager, with task: TabeTask) {
        let vc = EditTaskViewController()
        vc.titleLabel.text = "Edit TabeTask"
        vc.tabeTask = task
        vc.handleSubmit = manager.update
        navigationController.present(vc, animated: true)
    }
    
    /// Creates a user with the given nickname. If a group id is given, attempts to join the group, otherwise creates a new group.
    /// - Parameters:
    ///   - nickName: The user's nickname.
    ///   - groupId: The optional group identifier.
    func createUserWithGroup(nickName: String, groupId: String?) async throws {
        let remoteGroupManager = FirebaseGroupManager(userUid: authManager.userUid!)
        let groupManager = LocalGroupManager(groupManager: remoteGroupManager)
        struct GroupDoesNotExist: Error {}
        
        if let groupId = groupId {
            if await groupManager.groupExists(groupId: groupId) {
                groupManager.joinGroup(groupId: groupId)
            } else {
                throw GroupDoesNotExist()
            }
        } else {
            groupManager.createGroup()
        }
        
        groupManager.createUser(name: nickName)
        UserDefaults.standard.userExists = true
        navigationController.setViewControllers([makeMainViewController()], animated: true)
    }
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
