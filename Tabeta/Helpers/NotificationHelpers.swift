//
//  NotificationHelpers.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 04/05/2023.
//

import Foundation

struct TabetaNotification {
    static let taskUpdated = Notification.Name(rawValue: "com.raahs.Tabeta.taskUpdated")
}

extension NotificationCenter {
    public static func taskUpdated() {
        NotificationCenter.default.post(name: TabetaNotification.taskUpdated, object: nil)
    }
}
