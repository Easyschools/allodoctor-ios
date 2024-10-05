//
//  CustomToolBarItem.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 25/09/2024.
//
import UIKit

@IBDesignable
class CustomBarButtonItem: UIBarButtonItem {

    // Properties for the default and selected colors
    @IBInspectable var defaultTintColor: UIColor? {
        didSet {
            self.tintColor = defaultTintColor
        }
    }

    @IBInspectable var selectedTintColor: UIColor?

    // Variable to store the selected state
    private var _isSelected: Bool = false

    override var isSelected: Bool {
        get { return _isSelected }
        set {
            _isSelected = newValue
            updateTintColor()
        }
    }

    private func updateTintColor() {
        if isSelected {
            self.tintColor = selectedTintColor
        } else {
            self.tintColor = defaultTintColor
        }
    }

    // Toggle selected state programmatically
    func toggleSelection() {
        isSelected = !isSelected
    }
}
