//
//  LocalTaskLoader.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 03/05/2023.
//

import Foundation

final class LocalTaskLoader: TabeTaskLoader {
    let taskLoader: TabeTaskLoader
    
    init(taskLoader: TabeTaskLoader) {
        self.taskLoader = taskLoader
    }
    
    /// Asyncronously loads tasks.
    /// - Returns: An array of TabeTasks. Returns only the tasks assigned to the logged in user.
    func loadTasks() async throws -> [TabeTask] {
        try await taskLoader.loadTasks()
    }
}
