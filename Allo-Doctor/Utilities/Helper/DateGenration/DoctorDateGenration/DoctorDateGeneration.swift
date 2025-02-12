//
//  DoctorDateGeneration.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 11/11/2024.
//

import Foundation

// Enum for days of the week
enum Weekday: String {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    
    var intValue: Int {
        switch self {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        }
    }
}

// Global variable to store the generated dates
var generatedDates: [Date] = []

// Function to generate the next three dates
func generateNextThreeDates(for days: [String]) {
    let calendar = Calendar.current
    let now = generatedDates.last ?? Date() // Start from the last date in the array or the current date
    
    // Convert days to Weekday enums for easier handling
    let weekdays = days.compactMap { Weekday(rawValue: $0.lowercased()) }
    var occurrenceCount = 0
    var nextDate = now
    
    // Generate the next three occurrences across all specified days
    while occurrenceCount < 3 {
        for weekday in weekdays {
            // Find the next occurrence of each specified weekday
            if let nextDay = calendar.nextDate(after: nextDate, matching: DateComponents(weekday: weekday.intValue), matchingPolicy: .nextTime) {
                
                generatedDates.append(nextDay)
                nextDate = nextDay.addingTimeInterval(60 * 60 * 24) // Move to the day after the found date
                occurrenceCount += 1
                
                // Stop if we’ve generated 3 new dates
                if occurrenceCount == 3 {
                    break
                }
            }
        }
    }
}



