//
//  CustomNavigationBackButton.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 20/09/2024.
//

import UIKit

@IBDesignable
class CustomNavigationBackButton: UIButton {
    
    // Font size property with IBInspectable
    @IBInspectable var labelFontSize: CGFloat = 16 {
        didSet {
            updateFont()
            setNeedsLayout()
        }
    }
    
    // Spacing between image and label
    @IBInspectable var spacingBetweenImageAndLabel: CGFloat = 8 {
        didSet { setNeedsLayout() }
    }
    
    // Padding around content
    private let contentInset: CGFloat = 10
    
    // Common initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // Common setup for the button
    private func commonInit() {
        setTitleColor(.white, for: .normal)
        updateDirectionalImage()
        tintColor = .white
        backgroundColor = .clear
        contentHorizontalAlignment = .left
        updateFont()
    }
    
    // Update the image based on language direction
    private func updateDirectionalImage() {
        let isRTL = LocalizationManager.shared.isRTL()
        let imageName = isRTL ? "chevron.right" : "chevron.left"
        setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    // Update the font and trigger layout changes
    private func updateFont() {
        titleLabel?.font = UIFont(name: "Cairo-SemiBold", size: labelFontSize) ?? UIFont.systemFont(ofSize: labelFontSize, weight: .semibold)
        setNeedsLayout()
    }
    
    // Override layoutSubviews to adjust the layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let imageView = imageView, let titleLabel = titleLabel else { return }
        
        let titleSize = titleLabel.intrinsicContentSize
        let imageHeight = labelFontSize
        let imageWidth = imageView.intrinsicContentSize.width * (imageHeight / imageView.intrinsicContentSize.height)
        
        let totalWidth = contentInset + imageWidth + spacingBetweenImageAndLabel + titleSize.width + contentInset
        let totalHeight = max(imageHeight, titleSize.height) + 2 * contentInset
        
        frame.size = CGSize(width: totalWidth, height: totalHeight)
        
        let isRTL = LocalizationManager.shared.isRTL()
        
        if isRTL {
            // RTL Layout (Arabic)
            titleLabel.frame = CGRect(x: contentInset,
                                    y: (totalHeight - titleSize.height) / 2,
                                    width: titleSize.width,
                                    height: titleSize.height)
            
            imageView.frame = CGRect(x: contentInset + titleSize.width + spacingBetweenImageAndLabel,
                                   y: (totalHeight - imageHeight) / 2,
                                   width: imageWidth,
                                   height: imageHeight)
        } else {
            // LTR Layout (English)
            imageView.frame = CGRect(x: contentInset,
                                   y: (totalHeight - imageHeight) / 2,
                                   width: imageWidth,
                                   height: imageHeight)
            
            titleLabel.frame = CGRect(x: contentInset + imageWidth + spacingBetweenImageAndLabel,
                                    y: (totalHeight - titleSize.height) / 2,
                                    width: titleSize.width,
                                    height: titleSize.height)
        }
    }
    
    // Override intrinsicContentSize to provide a proper size for the button
    override var intrinsicContentSize: CGSize {
        let titleSize = titleLabel?.intrinsicContentSize ?? .zero
        let imageHeight = labelFontSize
        let imageWidth = imageView?.intrinsicContentSize.width ?? 0 * (imageHeight / (imageView?.intrinsicContentSize.height ?? 1))
        
        let width = contentInset + imageWidth + spacingBetweenImageAndLabel + titleSize.width + contentInset
        let height = max(imageHeight, titleSize.height) + 2 * contentInset
        
        return CGSize(width: width, height: height)
    }
    
    // Override setTitle to avoid needing to pass control state
    func setTitle(_ title: String) {
        super.setTitle(title, for: .normal)
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }
    
    // Update layout when language changes
    func updateForLanguageChange() {
        updateDirectionalImage()
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }
}
