//
//  TabetaProtocols.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 01/05/2023.
//

import Foundation

public protocol TabeTaskLoader {
    func loadTasks() async throws -> [TabeTask]
}

public protocol TabeTaskManager {
    func create(task: TabeTask) async throws
    func update(taskRef: String, with task: TabeTask) async throws
}

public protocol TabetaGroupManager {
    func createGroup()
    func createUser(name: String)
    func joinGroup(groupId: String)
    func groupExists(groupId: String) async -> Bool
}
