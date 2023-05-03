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
    
    init() {
        databaseReference = Database.database().reference(fromURL: databaseURL)
    }
    
    func update(taskRef: String, with task: TabeTask) async throws {
        let groupId = try await getGroupId()
        try await databaseReference
            .child("Groups")
            .child(groupId)
            .child("Tasks")
            .child(taskRef)
            .setValue(task.dictionaryValue)
    }
    
    func create(task: TabeTask) async throws {
        let groupId = try await getGroupId()
        try await databaseReference
            .child("Groups")
            .child(groupId)
            .child("Tasks")
            .childByAutoId()
            .setValue(task.dictionaryValue)
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
