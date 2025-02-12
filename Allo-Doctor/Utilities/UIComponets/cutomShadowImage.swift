//
//  cutomShadowImage.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 01/12/2024.
//

import UIKit

class TransparentLinearShadowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor, // Fully transparent
            UIColor.black.withAlphaComponent(0.8).cgColor // Semi-transparent black
        ]
        gradientLayer.locations = [0.0, 1.0] // Start and end of the gradient
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // Top-center
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0) // Bottom-center
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius

        // Add the gradient as a sublayer
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure the gradient matches the view's size
        if let gradientLayer = layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = bounds
        }
    }
}
