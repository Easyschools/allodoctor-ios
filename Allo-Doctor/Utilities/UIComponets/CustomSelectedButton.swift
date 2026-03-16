//
//  CustomSelectedButton.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 20/11/2024.
//

import UIKit

class SelectableButton: UIButton {

    // Images for selected and unselected states
    private let selectedImage = UIImage.checkMarkBlue // Replace with your custom image
    private let unselectedImage: UIImage? = nil // No image for the unselected state
    var onSelectionChanged: ((Bool) -> Void)?

    // Flag to enable/disable automatic toggling (default: true for backward compatibility)
    var enableAutomaticToggle: Bool = true
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        // Set default appearance
        updateAppearance()

        // Only add automatic toggle if enabled
        if enableAutomaticToggle {
            self.addTarget(self, action: #selector(toggleSelection), for: .touchUpInside)
        }

        // Make the button circular
        self.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Make button circular by setting cornerRadius to half of width
        self.layer.cornerRadius = self.bounds.width / 2
    }
    
    @objc func toggleSelection() {
        // Toggle the selection state
        self.isSelected.toggle()
        updateAppearance()
        onSelectionChanged?(self.isSelected)
    }

    // Call this to disable automatic toggle (for manual control via external actions)
    func disableAutomaticToggle() {
        self.removeTarget(self, action: #selector(toggleSelection), for: .touchUpInside)
    }

    // Override to update appearance when isSelected is changed programmatically
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    private func updateAppearance() {
        if self.isSelected {
            // Selected state: Blue background with an image
            self.layer.borderWidth = 1
            self.setImage(selectedImage, for: .normal)
        } else {
            // Unselected state: Clear background with a border
            self.backgroundColor = .clear
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.grey6B7280.cgColor
            self.setImage(unselectedImage, for: .normal)
        }
    }
    
    // Function to reset the button to its default state
    func resetSelection() {
        self.isSelected = false
        updateAppearance()
    }
}
