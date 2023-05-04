//
//  LocalTaskManager.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 03/05/2023.
//

import Foundation

/// This objects manages tasks from creation to deletion.
final class LocalTaskManager: TabeTaskManager {
    let taskManager: TabeTaskManager
    
    init(taskManager: TabeTaskManager) {
        self.taskManager = taskManager
    }
    
    /// Creates and saves a new task from the given TabeTask.
    /// - Parameter task: A TabeTask structure.
    func create(task: TabeTask) async throws {
        try await taskManager.create(task: task)
    }
    
    /// Updates and saves a TabeTask.
    /// - Parameter task: The updated task to save.
    func update(task: TabeTask) async throws {
        try await taskManager.update(task: task)
    }
    
    /// Deletes a task.
    /// - Parameter task: The TabeTask to delete.
    func delete(task: TabeTask) async throws {
        try await taskManager.delete(task: task)
    }
}
