//
//  LocalGroupManager.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 03/05/2023.
//

import Foundation

final class LocalGroupManager: TabetaGroupManager {
    let groupManager: TabetaGroupManager
    
    init(groupManager: TabetaGroupManager) {
        self.groupManager = groupManager
    }
    
    /// Creates a new group.
    func createGroup() {
        groupManager.createGroup()
    }
    
    /// Creates a new user with the given name as a nickname.
    /// - Parameter name: The nickname to save.
    func createUser(name: String) {
        groupManager.createUser(name: name)
    }
    
    /// Adds the user to the list of users in a group.
    /// - Parameter groupId: The identifier of the group.
    func joinGroup(groupId: String) {
        groupManager.joinGroup(groupId: groupId)
    }
    
    /// Checks if a group with the given identifier exists.
    /// - Parameter groupId: The group identifier.
    /// - Returns: true if the group exists, false otherwise.
    func groupExists(groupId: String) async -> Bool {
        await groupManager.groupExists(groupId: groupId)
    }
}
