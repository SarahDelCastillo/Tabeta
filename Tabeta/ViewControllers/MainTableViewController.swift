//
//  MainTableViewController.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import UIKit
import OSLog

typealias TaskLoaderProvider = (() -> (TabeTaskLoader))

class MainTableViewController: UITableViewController {
    
    /// The action to be executed when pressing the logout button.
    var logoutAction: (() throws -> ())?
    /// A TabeTaskLoader needed to load tasks.
    var taskLoader: TabeTaskLoader?
    /// A TabeTaskManager needed to manage tasks.
    var taskManager: TabeTaskManager?
    /// The action to be executed when pressing the add task button.
    var addTaskAction: ((_ manager: TabeTaskManager) -> ())?
    /// The action to be executed when selecting a task.
    var selectTaskAction: ((_ manager: TabeTaskManager, TabeTask) -> ())?
    
    var tabeTasks: [TabeTask]?
    let noTasksLabel = UILabel()
    
    var logger = Logger(subsystem: "com.raahs.Tabeta", category: "MainTableViewController")
    
    //MARK: Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        // Set up the logout and add task buttons.
        navigationItem.leftBarButtonItem = makeLogoutButton()
        navigationItem.rightBarButtonItem = makeAddTaskButton()
        
        loadTasks()
        setUpLabel()
        
        // Set up the refresh control (pull to refresh)
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.register(TabeTaskCell.self, forCellReuseIdentifier: "taskCell")
        tableView.separatorStyle = .none
        tableView.tableHeaderView = makeSpacer()
        
        //Notification observer
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh),
                                               name: TabetaNotification.taskUpdated,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: TabetaNotification.taskUpdated,
                                                  object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    //MARK: Startup -
    private func setUpLabel() {
        noTasksLabel.text = "No tasks yet!"
        noTasksLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noTasksLabel)
        
        NSLayoutConstraint.activate([
            noTasksLabel.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            noTasksLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor)
        ])
    }
    
    private func loadTasks() {
        guard let taskLoader = taskLoader else {
            logger.warning("No task handlers provider found.")
            return
        }
        Task {
            tabeTasks = try await taskLoader.loadTasks()
            refreshControl?.endRefreshing()
            tableView.reloadData()
        }
    }
    
    /// Creates a button for the log out action.
    /// - Returns: The configured button with an appropriate title.
    private func makeLogoutButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logout))
        return button
    }
    
    /// Creates a button for the add task action.
    /// - Returns: The configured button with an appropriate title.
    private func makeAddTaskButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Add task", style: .plain, target: self, action: #selector(addTask))
        return button
    }
    
    /// Creates a vertical spacer 20 points high.
    /// - Returns: The spacer.
    private func makeSpacer() -> UIView {
        UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
    }
    
    //MARK: Actions -
    /// Handles the execution of the logout action.
    @objc private func logout() {
        guard let logoutAction = logoutAction else {
            logger.warning("No logout action found.")
            return
        }
        do {
            try logoutAction()
            taskLoader = nil
            tabeTasks = nil
        } catch {
            logger.error("Log out failed with error: \(error)")
        }
    }
    
    /// Handles the execution of the add task action.
    @objc private func addTask() {
        guard let addTaskAction = addTaskAction else {
            logger.warning("No add task action found.")
            return
        }
        guard let taskManager = taskManager else {
            logger.warning("No task manager found.")
            return
        }
        addTaskAction(taskManager)
    }
    
    /// Handles the execution of a task deletion with the task manager.
    /// - Parameter task: The task to delete.
    func deleteTask(_ task: TabeTask) {
        guard let taskManager = taskManager else {
            logger.warning("No task manager found.")
            return
        }
        Task {
            do {
                try await taskManager.delete(task: task)
                refresh()
            } catch {
                logger.error("Delete failed with error: \(error)")
            }
        }
    }
    
    /// Handles the execution of a task toggle (done/undone)
    /// - Parameters:
    ///   - newValue: The new state of the task.
    ///   - sender: The TabeTaskCell that called this function.
    func toggleTask(newValue: Bool, sender: TabeTaskCell) {
        guard let taskManager = taskManager else {
            logger.warning("No task manager found.")
            return
        }
        guard let index = tableView.indexPath(for: sender)?.row,
              let task = tabeTasks?[index]
        else { // How is this possible ?
            return
        }
        
        var updatedTask = task
        updatedTask.done = newValue
        
        Task {
            do {
                try await taskManager.update(task: updatedTask)
                refresh()
            } catch {
                logger.error("Toggle failed with error: \(error)")
            }
        }
    }
    
    @objc private func refresh() {
        loadTasks()
    }
}
