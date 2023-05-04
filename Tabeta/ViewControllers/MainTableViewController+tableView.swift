//
//  MainTableViewController+tableView.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 30/04/2023.
//

import UIKit

extension MainTableViewController {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = tabeTasks?.count {
            noTasksLabel.isHidden = count > 0
            return count
        } else {
            noTasksLabel.isHidden = false
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TabeTaskCell
        
        let currentTask = tabeTasks![indexPath.row]
        cell.configureWith(title: currentTask.name, done: currentTask.done)
        
        return cell
    }
    
    //MARK: Deletion -
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let task = tabeTasks?.remove(at: indexPath.row) else {
                return
            }
            deleteTask(task)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //MARK: Edition -
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let selectedTask = tabeTasks?[indexPath.row] else {
            return
        }
        guard let taskManager = taskManager else {
            logger.warning("No task manager found.")
            return
        }
        selectTaskAction?(taskManager, selectedTask)
    }
}
