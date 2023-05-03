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
    
    var logoutAction: (() throws -> ())?
    var taskLoader: TabeTaskLoader?
    var taskManager: TabeTaskManager?
    var addTaskAction: (() -> ())?
    var selectTaskAction: ((TabeTask) -> ())?
    
    var tabeTasks: [TabeTask]?
    let noTasksLabel = UILabel()
    
    private var logger = Logger(subsystem: "com.raahs.Tabeta", category: "MainTableViewController")
    
    //MARK: Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        navigationItem.leftBarButtonItem = makeLogoutButton()
        navigationItem.rightBarButtonItem = makeAddTaskButton()
        
        loadTasks()
        setUpLabel()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.register(TabeTaskCell.self, forCellReuseIdentifier: "taskCell")
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
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
    
    private func makeLogoutButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logout))
        return button
    }
    
    private func makeAddTaskButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Add task", style: .plain, target: self, action: #selector(addTask))
        return button
    }
    
    //MARK: Actions -
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
    
    @objc private func addTask() {
        guard let addTaskAction = addTaskAction else {
            logger.warning("No add task action found.")
            return
        }
        addTaskAction()
    }
    
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
    
    @objc private func refresh() {
        loadTasks()
    }
}
