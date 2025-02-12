//
//  CustomBackNavigationButton.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 18/09/2024.
//

import UIKit

class CustomBackButton: UIButton {
    
    // Initializer for setting up the button
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton(with: "Back")  // Default text is "Back"
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton(with: "Back")  // Default text is "Back"
    }

    // Function to set up the custom button appearance
    private func setupButton(with title: String) {
        // Set the chevron.left image
        let chevronImage = UIImage(systemName: "chevron.left")
        self.setImage(chevronImage, for: .normal)
        
        // Set the title for the button
        self.setTitle(title, for: .normal)
        
        // Set image and title colors
        self.tintColor = .white
        self.setTitleColor(.white, for: .normal)
        
        // Set the font to Cairo-SemiBold, size 20
        self.titleLabel?.font = UIFont(name: "Cairo-SemiBold", size: 20)
        
        // Add spacing between the image and the title
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        // Adjust the content's intrinsic size to fit the font and image
        self.sizeToFit()
        
        // Optionally, disable the button's background highlight effect
        self.adjustsImageWhenHighlighted = false
    }
    
    // Public method to allow setting the button's text
    func setButtonText(_ text: String) {
        // Update the title with the provided text
        self.setTitle(text, for: .normal)
        // Recalculate the size to fit the new text
        self.sizeToFit()
    }
}
