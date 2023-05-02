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
    var taskLoaderProvider: TaskLoaderProvider?
    var tabeTasks: [TabeTask]?
    let noTasksLabel = UILabel()
    
    private var taskLoader: TabeTaskLoader?
    
    private var logger = Logger(subsystem: "com.raahs.Tabeta", category: "MainTableViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestTaskHandlers()
        navigationItem.leftBarButtonItem = makeLogoutButton()
        view.backgroundColor = .cyan
        loadTasks()
        setUpLabel()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "taskCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setUpLabel() {
        noTasksLabel.text = "No tasks yet!"
        noTasksLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noTasksLabel)
        
        NSLayoutConstraint.activate([
            noTasksLabel.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            noTasksLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor)
        ])
    }
    
    private func makeLogoutButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logout))
        return button
    }
    
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
    
    private func requestTaskHandlers() {
        guard let provider = taskLoaderProvider else {
            logger.warning("No task handlers provider found.")
            return
        }
        taskLoader = provider()
    }
    
    private func loadTasks() {
        Task {
            tabeTasks = try await taskLoader?.loadTasks()
            tableView.reloadData()
        }
    }
}
