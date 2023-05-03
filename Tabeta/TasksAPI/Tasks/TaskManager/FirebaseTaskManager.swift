//
//  FirebaseTaskManager.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 30/04/2023.
//

import Foundation
import FirebaseDatabase

fileprivate let databaseURL = "https://tabeta-a8b61-default-rtdb.europe-west1.firebasedatabase.app/"

final class FirebaseTaskManager: TabeTaskManager {
    let databaseReference: DatabaseReference
    var _groupId: String?
    private struct GroupIdNotFound: Error {}
    private struct CouldNotFindUserId: Error {}
    private struct CouldNotFindTaskIdentifier: Error {}
    
    init() {
        databaseReference = Database.database().reference(fromURL: databaseURL)
    }
    
    func update(task: TabeTask) async throws {
        let groupId = try await getGroupId()
        guard let taskId = task.identifier else {
            throw CouldNotFindTaskIdentifier()
        }
        try await databaseReference
            .child("Groups")
            .child(groupId)
            .child("Tasks")
            .child(taskId)
            .setValue(task.dictionaryValue)
    }
    
    func create(task: TabeTask) async throws {
        let groupId = try await getGroupId()
        let taskRef = databaseReference
            .child("Groups")
            .child(groupId)
            .child("Tasks")
            .childByAutoId()
        
        guard let taskId = taskRef.key else {
            throw CouldNotFindTaskIdentifier()
        }
        var localTask = task
        localTask.identifier = taskId
        
        try await taskRef
            .setValue(localTask.dictionaryValue)
    }
    
    private func getGroupId() async throws -> String {
        if let groupId = _groupId { return groupId }
        guard let userId = UserDefaults.standard.userId else {
            throw CouldNotFindUserId()
        }
        
        let snapshot = try await databaseReference
            .child("Users")
            .child(userId)
            .child("group")
            .getData()
        if let id = snapshot.value as? String {
            _groupId = id
            return id
        }
        throw GroupIdNotFound()
    }
}
