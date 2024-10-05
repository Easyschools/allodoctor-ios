//
//  Custombutton.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 04/09/2024.
//

import UIKit

final class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension CustomButton {
    /// Configures the button with custom properties
    func setupButton(color: UIColor, title: String, borderColor: UIColor, textColor: UIColor) {
        // Set the button title and color
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)

        // Set the custom font
        if let customFont = UIFont(name: "Cairo-Bold", size: 16) {
            self.titleLabel?.font = customFont
        } else {
            print("Custom font 'Cairo-Bold' not found. Check the font name and Info.plist configuration.")
        }

        // Set button appearance attributes
        backgroundColor = color
        layer.cornerRadius = Dimensions.borderRaduis.rawValue
        layer.borderWidth = Dimensions.borderWidth.rawValue
        layer.borderColor = borderColor.cgColor
        
        // Ensure layout is updated
        self.layoutIfNeeded()
    }
}

