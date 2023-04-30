//
//  RemoteTaskManager.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 30/04/2023.
//

import Foundation
import FirebaseDatabase

fileprivate let databaseURL = "https://tabeta-a8b61-default-rtdb.europe-west1.firebasedatabase.app/"

protocol TabeTaskManager {
    func create(task: TabeTask)
    func update(taskRef: String, with task: TabeTask)
}

final class RemoteTaskManager: TabeTaskManager {
    let databaseReference: DatabaseReference
    var groupId: String {
        UserDefaults.groupId!
    }
    
    init() {
        databaseReference = Database.database().reference(fromURL: databaseURL)
    }
    
    func update(taskRef: String, with task: TabeTask) {
        databaseReference
            .child("Groups")
            .child(groupId)
            .child("Tasks")
            .child(taskRef)
            .setValue(task.dictionaryValue)
    }
    
    func create(task: TabeTask) {
        databaseReference
            .child("Groups")
            .child(groupId)
            .child("Tasks")
            .childByAutoId()
            .setValue(task.dictionaryValue)
    }
}
