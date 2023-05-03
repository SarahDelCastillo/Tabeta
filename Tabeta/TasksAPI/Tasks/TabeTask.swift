//
//  TabeTask.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import Foundation

public struct TabeTask: Equatable {
    var done: Bool
    var name: String
    var notifTimes: [Int]
    
    var dictionaryValue: [String: Any] {
        [
            "done": done,
            "name": name,
            "notifTimes": notifTimes.reduce(into: [String: Bool](), { partialResult, notifTime in
                partialResult["\(notifTime)"] = true
            })
        ]
    }
}
