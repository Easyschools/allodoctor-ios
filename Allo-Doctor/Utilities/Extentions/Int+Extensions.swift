//
//  Int+Extensions.swift
//  Allo-Doctor
//
//  Created for Hospital-First Flow Implementation
//

import Foundation

extension Int {
    /// Converts Int to String
    func toString() -> String {
        return String(self)
    }
}

extension Optional where Wrapped == Int {
    /// Safely converts Optional Int to String
    func toString() -> String {
        guard let value = self else { return "" }
        return String(value)
    }
}
