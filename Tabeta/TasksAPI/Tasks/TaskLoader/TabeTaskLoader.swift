//
//  TabeTaskLoader.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 01/05/2023.
//

public protocol TabeTaskLoader {
    func loadTasks() async throws -> [TabeTask]
}
