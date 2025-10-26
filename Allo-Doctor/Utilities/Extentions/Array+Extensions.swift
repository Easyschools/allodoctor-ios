//
//  Array+Extensions.swift
//  Allo-Doctor
//
//  Created for Hospital-First Flow Implementation
//

import Foundation

extension Array {
    /// Safe subscript access that returns nil if index is out of bounds
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
