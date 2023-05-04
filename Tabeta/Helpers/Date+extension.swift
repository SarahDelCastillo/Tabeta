//
//  Date+extension.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 04/05/2023.
//

import Foundation

extension Date {
    /// Calculate the number of seconds from the current hour to the given hour.
    /// - Note: If the given hour is less than or equal to the current hour, a day will be added before calculating.
    /// - Parameter hour: The hour to calculate with.
    /// - Returns: The number of seconds until the given hour.
    func getSeconds(until hour: Int) -> TimeInterval {
        let now = self
        let currentTime = now.timeIntervalSince1970
        let calendar = Calendar.current
        
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = hour
        components.minute = 0
        components.second = 0
        
        var futureDate = calendar.date(from: components)!
        
        let currentHour = calendar.component(.hour, from: now)
        if hour <= currentHour {
            var oneDay = DateComponents()
            oneDay.day = 1
            futureDate = calendar.date(byAdding: oneDay, to: futureDate)!
        }
        
        let futureTime = futureDate.timeIntervalSince1970
        
        let secondsUntilFutureTime = futureTime - currentTime
        return secondsUntilFutureTime
    }
}
