//
//  RemoteGroupManager.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 30/04/2023.
//

import Foundation
import FirebaseDatabase

protocol GroupManager {
    func createGroup()
    func createUser(name: String)
    func joinGroup(groupId: String)
    func groupExists(groupId: String) async -> Bool
}

fileprivate let databaseURL = "https://tabeta-a8b61-default-rtdb.europe-west1.firebasedatabase.app/"

final class RemoteGroupManager: GroupManager {
    let databaseReference: DatabaseReference
    let userUid: String
    
    init(userUid: String) {
        databaseReference = Database.database().reference(fromURL: databaseURL)
        self.userUid = userUid
    }
    
    func createUser(name: String) {
        databaseReference
            .child("Users")
            .child(userUid)
            .child("name")
            .setValue(name)
    }
    
    func createGroup() {
        // Create the new group
        let groupId = databaseReference.child("Groups").childByAutoId()
        
        // Add user to group
        groupId
            .child("Members")
            .child(userUid)
            .setValue(true)
        
        // Save the group reference to the user
        let groupKey = groupId.key
        databaseReference
            .child("Users")
            .child(userUid)
            .child("group")
            .setValue(groupKey)
        
        // Save the groupId locally
        UserDefaults.groupId = groupKey
    }
    
    func joinGroup(groupId: String) {
        // Add user to group
        databaseReference
            .child("Groups")
            .child(groupId)
            .child("Members")
            .child(userUid)
            .setValue(true)
        
        // Save the group reference to the user
        databaseReference
            .child("Users")
            .child(userUid)
            .child("group")
            .setValue(groupId)
        
        // Save the groupId locally
        UserDefaults.groupId = groupId
    }
    
    func groupExists(groupId: String) async -> Bool {
        return await withCheckedContinuation { continuation in
            databaseReference
                .child("Groups")
                .child(groupId)
                .getData { error, snapshot in
                    if error == nil, let exists = snapshot?.exists() {
                        continuation.resume(returning: exists)
                        return
                    }
                    continuation.resume(returning: false)
                }
        }
    }
}
