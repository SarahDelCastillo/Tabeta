//
//  RemoteTaskLoader.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import Foundation
import FirebaseDatabase

protocol TabeTaskLoader {
    func loadTasks() async -> [TabeTask]
}

fileprivate let databaseURL = "https://tabeta-a8b61-default-rtdb.europe-west1.firebasedatabase.app/"
final class RemoteTaskLoader: TabeTaskLoader {
    let databaseReference: DatabaseReference
    var groupId: String {
        UserDefaults.groupId!
    }
    
    init() {
        databaseReference = Database.database().reference(fromURL: databaseURL)
    }
    
    func loadTasks() async -> [TabeTask] {
        return await withCheckedContinuation { continuation in
            databaseReference
                .child("Groups")
                .child(groupId)
                .observeSingleEvent(of: .value) { snapshot in
                    let tasksSnapshot = snapshot.childSnapshot(forPath: "Tasks")
                    var tasks = [TabeTask]()
                    for task in tasksSnapshot.children {
                        let dataSnapshot = task as? DataSnapshot
                        if let taskDictionary = dataSnapshot?.value as? [String: Any] {
                            let done = taskDictionary["done"] as! Bool
                            let name = taskDictionary["name"] as! String
                            let notifTimesDict = taskDictionary["notifTimes"] as! [String: Bool]
                            let keys = Array(notifTimesDict.keys).map { Int($0)! }
                            let notifTimes = keys
                            
                            let task = TabeTask(done: done, name: name, notifTimes: notifTimes)
                            tasks.append(task)
                        }
                    }
                    continuation.resume(returning: tasks)
                }
        }
    }
}
