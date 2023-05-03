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
    
    func createGroup() {
        groupManager.createGroup()
    }
    
    func createUser(name: String) {
        groupManager.createUser(name: name)
    }
    
    func joinGroup(groupId: String) {
        groupManager.joinGroup(groupId: groupId)
    }
    
    func groupExists(groupId: String) async -> Bool {
        await groupManager.groupExists(groupId: groupId)
    }
}
