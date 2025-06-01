//
//  CustomDropShadowView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 20/11/2024.
//


import UIKit

@IBDesignable
class CustomDropShadowView: UIView {

    @IBInspectable override var cornerRadius: CGFloat  {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShadow()
    }

    private func setupShadow() {
        // Apply shadow properties
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10) // Shadow offset (x, y)
        self.layer.shadowOpacity = 0.1 // Shadow opacity (10% opacity)
        self.layer.shadowRadius = 15 // Blur radius
        self.layer.masksToBounds = false
    }
}
