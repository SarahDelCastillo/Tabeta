//
//  TabetaGroupManager.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 03/05/2023.
//

public protocol TabetaGroupManager {
    func createGroup()
    func createUser(name: String)
    func joinGroup(groupId: String)
    func groupExists(groupId: String) async -> Bool
}
