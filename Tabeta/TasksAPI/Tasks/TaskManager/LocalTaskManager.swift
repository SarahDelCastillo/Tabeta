//
//  LocalTaskManager.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 03/05/2023.
//

import Foundation

final class LocalTaskManager: TabeTaskManager {
    let taskManager: TabeTaskManager
    
    init(taskManager: TabeTaskManager = FirebaseTaskManager()) {
        self.taskManager = taskManager
    }
    
    func create(task: TabeTask) async throws {
        try await taskManager.create(task: task)
    }
    
    func update(taskRef: String, with task: TabeTask) async throws {
        try await taskManager.update(taskRef: taskRef, with: task)
    }
}
