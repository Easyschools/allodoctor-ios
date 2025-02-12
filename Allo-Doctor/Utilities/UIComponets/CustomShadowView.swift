//
//  CustomShadowView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 14/10/2024.
//

import UIKit

@IBDesignable
class CustomShadowView: UIView {
    
    @IBInspectable var shadowColorAlpha: CGFloat = 0.1 {
        didSet {
            setupShadow()
        }
    }
    
    @IBInspectable var shadowOffsetWidth: CGFloat = 4 {
        didSet {
            setupShadow()
        }
    }
    
    @IBInspectable var shadowOffsetHeight: CGFloat = 4 {
        didSet {
            setupShadow()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 7.5 {
        didSet {
            setupShadow()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1 {
        didSet {
            setupShadow()
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShadow()
    }
    
    private func setupShadow() {
        // Ensure the view has a proper background color
        backgroundColor = .white
        
        // Create shadow path
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
        
        layer.shadowPath = shadowPath.cgPath
        layer.shadowColor = UIColor.black.withAlphaComponent(shadowColorAlpha).cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.masksToBounds = false
        
        // Improve shadow rendering
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

@IBDesignable
class ShadowView: UIView {
    
    // MARK: - Inspectable Properties
    
    @IBInspectable var shadowColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1) {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1.0 {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 15.0 {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 4, height: 4) {
        didSet {
            updateShadow()
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShadow()
    }
    
    // MARK: - Shadow Setup
    
    private func setupShadow() {
        updateShadow()
    }
    
    private func updateShadow() {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
        layer.masksToBounds = false
        
        // Matches the original box-shadow specification
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateShadow()
    }
}
