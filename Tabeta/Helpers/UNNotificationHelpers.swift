//
//  UNNotificationHelpers.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 04/05/2023.
//

import UserNotifications
import OSLog

extension UNUserNotificationCenter {
    private struct IdentifierForNotificationNotFound: Error {}
    private struct NotificationDateCouldNotBeCalculated: Error {}
    
    static func scheduleNotification(for task: TabeTask) throws {
        guard let identifier = task.identifier else {
            throw IdentifierForNotificationNotFound()
        }
        guard let hour = task.notifTimes.first else {
            throw NotificationDateCouldNotBeCalculated()
        }
        let logger = Logger(subsystem: "com.raahs.Tabeta", category: "UNUserNotificationCenter")
        let content = UNMutableNotificationContent()
        content.title = task.name
        content.body = "The time has come!"
        
        let secondsUntilNotification = Date().getSeconds(until: hour)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: secondsUntilNotification, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                logger.error("Add notification request failed with error: \(error)")
            } else {
                logger.notice("Successfully added notification for task named \(task.name, privacy: .public)")
            }
        }
    }
    
    static func removeNotification(for task: TabeTask) throws {
        guard let identifier = task.identifier else {
            throw IdentifierForNotificationNotFound()
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    static func batchScheduleNotifications(with tasks: [TabeTask]) throws {
        for task in tasks {
            try Self.scheduleNotification(for: task)
        }
    }
    
    static func removeAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
