//
//  CustomCornerRaduis.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 25/09/2024.
//

import UIKit

@IBDesignable
class CustomCornerRaduis: UIView {

    // Individual corner radius properties
    @IBInspectable var topLeftRadius: CGFloat = 0 {
        didSet {
            updateCornerRadius()
        }
    }
    
    @IBInspectable var topRightRadius: CGFloat = 0 {
        didSet {
            updateCornerRadius()
        }
    }
    
    @IBInspectable var bottomLeftRadius: CGFloat = 0 {
        didSet {
            updateCornerRadius()
        }
    }
    
    @IBInspectable var bottomRightRadius: CGFloat = 0 {
        didSet {
            updateCornerRadius()
        }
    }
    
    // Update corner radius when the view is rendered
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    private func updateCornerRadius() {
        // Create a path for the rounded corners
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [
                                    .topLeft,
                                    .topRight,
                                    .bottomLeft,
                                    .bottomRight
                                ],
                                cornerRadii: CGSize(width: topLeftRadius, height: topLeftRadius))
        
        // Apply the path as a mask
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
