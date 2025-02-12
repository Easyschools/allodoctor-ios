//
//  UIStrings+Extentions.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 30/09/2024.
//

import Foundation
extension String {
    func prepend(_ prefix: String, separator: String = "") -> String {
        return prefix + separator + self
    }

        /// Appends a string to the current string with a space in between.
func appendingWithSpace(_ other: String) -> String {
            return self.isEmpty ? other : "\(self) \(other)"
}
        
        /// Mutates the current string by appending another string with a space.
        mutating func appendWithSpace(_ other: String) {
            self = self.appendingWithSpace(other)
}


}
extension String {
    /// Converts a time string from "H:mm:ss" format to "h:mm a" format (12-hour with AM/PM)
    func convertTo12HourFormat() -> String {
        // Create a date formatter to parse the 24-hour time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"  // Input format (e.g., 21:00:08)
        
        // Set the locale to Arabic
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            dateFormatter.locale = Locale(identifier: "ar")}
        else{
            dateFormatter.locale = Locale(identifier: "en")
        }

        // Try to convert the input string to a Date object
        guard let date = dateFormatter.date(from: self) else {
            return "Invalid time format"
        }
        
        // Create a new formatter for the 12-hour format with AM/PM
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h:mm a"  // Output format (e.g., 9:08 PM)
        
        // Set the locale to Arabic for the output formatter
       
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            outputFormatter.locale = Locale(identifier: "ar")}
        else{
            outputFormatter.locale = Locale(identifier: "en")
        }

        
        // Convert the Date object to the desired string format
        let formattedTime = outputFormatter.string(from: date)
        
        return formattedTime
    }

    func toDouble() -> Double? {
           return Double(self)
       }
    func toInt() -> Int? {
           return Int(self)
       }
    func monthNumber() -> Int? {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX") // Use "ar" for Arabic
            formatter.dateFormat = "MMMM" // Full month name (e.g., "February")
            
            // Handle short month names too (e.g., "Feb")
            if formatter.date(from: self) == nil {
                formatter.dateFormat = "MMM"
            }
            
            guard let date = formatter.date(from: self.capitalized) else {
                return nil // Return nil if the string is not a valid month
            }
            
            return Calendar.current.component(.month, from: date)
        }
    }


extension String {
    /// Converts a date string from "20 Nov 2024" to "2024-11-20"
    func formatDateToPost(from inputFormat: String = "dd MMM yyyy", to outputFormat: String = "yyyy-MM-dd") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = inputFormat
        
        guard let date = dateFormatter.date(from: self) else {
            print("Invalid date string: \(self)")
            return nil
        }
        
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: date)
    }
    
    /// Converts a date string from "20 Nov 2024" to "2024-11-20"
    func formatDate(from inputFormat: String = "dd MMM yyyy", to outputFormat: String = "dd MMM") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = inputFormat
        
        guard let date = dateFormatter.date(from: self) else {
            print("Invalid date string: \(self)")
            return nil
        }
        
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: date)
    }
    
    func toArabicDate(format: String = "dd MMM") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US") // Original date is in English
        
        // Convert the string to a Date
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        
        // Format the date in Arabic
        let arabicFormatter = DateFormatter()
        arabicFormatter.dateFormat = format
        arabicFormatter.locale = Locale(identifier: "ar") // Arabic locale
        
        return arabicFormatter.string(from: date)
    }
    
    
    /// Converts a date string from "2024-11-20" to "20 Nov 2024"
    func formatDateToMonth(from inputFormat: String = "yyyy-MM-dd", to outputFormat: String = "dd MMM yyyy") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = inputFormat
        
        guard let date = dateFormatter.date(from: self) else {
            print("Invalid date string: \(self)")
            return nil
        }
        
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: date)
    }
}



extension Int {
    func toString() -> String {
        return String(self)
    }
}
extension String {
    /// Converts a date string from "yyyy-MM-dd" format to "dd/MM".
    /// - Returns: A formatted date string in "dd/MM" or `nil` if the input format is invalid.
    func convertDateFormat() -> String? {
        let inputDateFormat = "yyyy-MM-dd"
        let outputDateFormat = "d/M"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputDateFormat

        // Convert string to Date
        guard let date = dateFormatter.date(from: self) else { return nil }

        // Set output format and convert Date to string
        dateFormatter.dateFormat = outputDateFormat
        return dateFormatter.string(from: date)
    }
    func convertDateFormatToArabic() -> String? {
            let inputDateFormat = "yyyy-MM-dd"
            
            // Initialize a DateFormatter to handle the input date format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = inputDateFormat
            
            // Convert string to Date
            guard let date = dateFormatter.date(from: self) else { return nil }
            
            // Set the locale to Arabic for proper localization
            let arabicLocale = Locale(identifier: "ar")
            
            // Format the date to include the day name and the date
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.locale = arabicLocale
            outputDateFormatter.dateStyle = .full  // This includes the full day name
            outputDateFormatter.timeStyle = .none  // We don't need time
            
            return outputDateFormatter.string(from: date)
        }

        /// Converts English day names to Arabic.
        func convertDayToArabic() -> String {
            let dayMapping: [String: String] = [
                "Sunday": "الأحد",
                "Monday": "الإثنين",
                "Tuesday": "الثلاثاء",
                "Wednesday": "الأربعاء",
                "Thursday": "الخميس",
                "Friday": "الجمعة",
                "Saturday": "السبت"
            ]
            
            return dayMapping[self] ?? self // Return the Arabic name if it exists, otherwise return the original string
        }
    func fullDateFormatter() -> String? {
            let inputDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ" // Format of the input string
            let outputDateFormat = "d-M-yyyy" // Desired output format
            
            let formatter = DateFormatter()
            formatter.dateFormat = inputDateFormat
            formatter.locale = Locale(identifier: "en") // Default to English

            // Try to parse the input string into a Date object
            guard let date = formatter.date(from: self) else { return nil }

            // Set output format and locale based on device settings
            formatter.dateFormat = outputDateFormat
            formatter.locale = Locale.current

            return formatter.string(from: date)
        }
    func convertArabicDateToEnglish() -> String? {
           // Create a formatter to parse the Arabic number format
           let formatter = DateFormatter()
           formatter.locale = Locale(identifier: "ar")
           formatter.dateFormat = "yyyy-MM-dd"
           
           // Try to parse the date string
           guard let date = formatter.date(from: self) else {
               print("Failed to parse date from Arabic numbers.")
               return nil
           }
           
           // Create a formatter to convert to English format
           formatter.locale = Locale(identifier: "en_US_POSIX")
           return formatter.string(from: date)
       }
    

}
extension Float {
    var toString: String {
        return String(self)
    }
}
