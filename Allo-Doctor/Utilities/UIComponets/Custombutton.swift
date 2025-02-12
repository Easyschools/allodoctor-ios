//
//  Custombutton.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 04/09/2024.
//

import UIKit

final class CustomButton: UIButton {

    // Set up default custom font at the top of the class
    private let defaultFont: UIFont = {
        if let font = UIFont(name: "Cairo-Bold", size: 16) {
            return font
        } else {
            print("Custom font 'Cairo-Bold' not found. Check the font name and Info.plist configuration.")
            return UIFont.systemFont(ofSize: 16, weight: .bold)  // Fallback to system bold font if custom font is not found
        }
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureDefaultAppearance()  // Apply default appearance including the font
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureDefaultAppearance()  // Apply default appearance including the font
    }

    // Set default appearance for the button
    private func configureDefaultAppearance() {
        self.titleLabel?.font = defaultFont
        // Any other default properties like background color, border, etc., can be set here if needed
    }
}

extension CustomButton {
    /// Configures the button with custom properties
    func setupButton(color: UIColor, title: String, borderColor: UIColor, textColor: UIColor) {
        // Set the button title and color
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)

        // Set button appearance attributes
        backgroundColor = color
        layer.cornerRadius = Dimensions.borderRaduis.rawValue
        layer.borderWidth = Dimensions.borderWidth.rawValue
        layer.borderColor = borderColor.cgColor
        
        // Ensure layout is updated
        self.layoutIfNeeded()
    }
}
