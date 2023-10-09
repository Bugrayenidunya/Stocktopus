//
//  Date+Extensions.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 8.10.2023.
//

import Foundation

extension Date {
    /// Get last business day date as String in format of "yyyy-MM-dd"
    func getLastBusinessDay() -> String {
        let calendar = Calendar.current
        var currentDate = Date()
        let currentWeekday = calendar.component(.weekday, from: currentDate)
        
        // Subtract days based on current weekday
        switch currentWeekday {
        case 1:
            currentDate = calendar.date(byAdding: .day, value: -2, to: currentDate) ?? Date()
        case 2:
            currentDate = calendar.date(byAdding: .day, value: -3, to: currentDate) ?? Date()
        case 7:
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? Date()
        default:
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? Date()
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let latestWorkdayString = dateFormatter.string(from: currentDate)

        return latestWorkdayString
    }
}
