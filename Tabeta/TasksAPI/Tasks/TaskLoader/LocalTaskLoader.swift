//
//  LocalTaskLoader.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 03/05/2023.
//

import Foundation

final class LocalTaskLoader: TabeTaskLoader {
    let taskLoader: TabeTaskLoader
    
    init(taskLoader: TabeTaskLoader = FirebaseTaskLoader()) {
        self.taskLoader = taskLoader
    }
    
    func loadTasks() async throws -> [TabeTask] {
        try await taskLoader.loadTasks()
    }
}
