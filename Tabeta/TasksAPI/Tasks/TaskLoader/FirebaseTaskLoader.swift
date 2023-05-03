//
//  FirebaseTaskLoader.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import Foundation
import FirebaseDatabase

fileprivate let databaseURL = "https://tabeta-a8b61-default-rtdb.europe-west1.firebasedatabase.app/"

final class FirebaseTaskLoader: TabeTaskLoader {
    let databaseReference: DatabaseReference
    
    var _groupId: String?
    private struct GroupIdNotFound: Error {}
    private struct CouldNotFindUserId: Error {}
    
    init() {
        databaseReference = Database.database().reference(fromURL: databaseURL)
    }
    
    func loadTasks() async throws -> [TabeTask] {
        let snapshot = try await fetchTasksSnapshot()
        return getTasks(from: snapshot)
    }
    
    private func fetchTasksSnapshot() async throws -> DataSnapshot {
        let groupId = try await getGroupId()
        return await withCheckedContinuation { continuation in
            databaseReference
                .child("Groups")
                .child(groupId)
                .observeSingleEvent(of: .value) { snapshot in
                    let tasksSnapshot = snapshot.childSnapshot(forPath: "Tasks")
                    continuation.resume(returning: tasksSnapshot)
                }
        }
    }
    
    private func getTasks(from snapshot: DataSnapshot) -> [TabeTask] {
        var tasks = [TabeTask]()
        for task in snapshot.children {
            let dataSnapshot = task as? DataSnapshot
            if let taskDictionary = dataSnapshot?.value as? [String: Any] {
                
                let done = taskDictionary["done"] as! Bool
                let name = taskDictionary["name"] as! String
                let notifTimes = {
                    if let notifTimesDict = taskDictionary["notifTimes"] as? [String: Bool] {
                        let keys = Array(notifTimesDict.keys).map { Int($0)! }
                        return keys
                    }
                    return []
                }()
                
                let task = TabeTask(done: done, name: name, notifTimes: notifTimes)
                tasks.append(task)
            }
        }
        return tasks
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
