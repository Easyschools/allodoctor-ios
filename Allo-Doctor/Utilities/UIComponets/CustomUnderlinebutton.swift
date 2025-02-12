//
//  CustomUnderlinebutton.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 25/09/2024.
//
import UIKit

@IBDesignable
class CustomUnderlinedButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUnderlineAndFont()
    }
    
    private func setupUnderlineAndFont() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        
        // Set Cairo Bold font
        if let cairoBold = UIFont(name: "Cairo-Bold", size: titleLabel?.font.pointSize ?? 12) {
            attributedString.addAttribute(.font, value: cairoBold, range: NSRange(location: 0, length: title.count))
        } else {
            print("Cairo-Bold font not found. Make sure it's added to your project.")
        }
        
        // Add underline attribute
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: title.count))
        
        // Set the attributed title
        setAttributedTitle(attributedString, for: .normal)
    }
}
