//
//  TabeTaskManager.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 03/05/2023.
//

public protocol TabeTaskManager {
    func create(task: TabeTask) async throws
    func update(task: TabeTask) async throws
    func delete(task: TabeTask) async throws
}
