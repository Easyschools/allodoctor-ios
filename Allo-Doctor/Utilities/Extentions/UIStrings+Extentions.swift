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
}
