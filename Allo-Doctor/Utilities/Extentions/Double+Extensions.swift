//
//  Double+Extensions.swift
//  Allo-Doctor
//
//  Created for Hospital-First Flow Implementation
//

import Foundation

extension Double {
    /// Converts Double to String
    func toString() -> String {
        return String(self)
    }

    /// Formats Double as price with specified decimal places
    func toPrice(decimals: Int = 2) -> String {
        return String(format: "%.\(decimals)f", self)
    }
}

extension Optional where Wrapped == Double {
    /// Safely converts Optional Double to String
    func toString() -> String {
        guard let value = self else { return "" }
        return String(value)
    }
}
