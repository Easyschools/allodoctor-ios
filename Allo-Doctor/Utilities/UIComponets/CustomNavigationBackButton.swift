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
        setTitleColor(.white, for: .normal)  // Label color to white
        setImage(UIImage(systemName: "chevron.left"), for: .normal)  // Left chevron image
        tintColor = .white  // Image color
        backgroundColor = .clear  // Default clear background
        contentHorizontalAlignment = .left  // Align content to the left
        updateFont()  // Set font for label
    }
    
    // Update the font and trigger layout changes
    private func updateFont() {
        titleLabel?.font = UIFont(name: "Cairo-SemiBold", size: labelFontSize) ?? UIFont.systemFont(ofSize: labelFontSize, weight: .semibold)
        setNeedsLayout()
    }
    
    // Override layoutSubviews to adjust the layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Ensure both imageView and titleLabel exist
        guard let imageView = imageView, let titleLabel = titleLabel else { return }

        // Calculate image and label sizes
        let titleSize = titleLabel.intrinsicContentSize
        let imageHeight = labelFontSize  // Make image height equal to font size
        let imageWidth = imageView.intrinsicContentSize.width * (imageHeight / imageView.intrinsicContentSize.height)  // Scale width proportionally

        // Calculate total width and height for button content
        let totalWidth = contentInset + imageWidth + spacingBetweenImageAndLabel + titleSize.width + contentInset
        let totalHeight = max(imageHeight, titleSize.height) + 2 * contentInset

        // Update the button's size
        frame.size = CGSize(width: totalWidth, height: totalHeight)
        
        // Position the imageView
        imageView.frame = CGRect(x: contentInset,
                                 y: (totalHeight - imageHeight) / 2,
                                 width: imageWidth,
                                 height: imageHeight)

        // Position the titleLabel
        titleLabel.frame = CGRect(x: contentInset + imageWidth + spacingBetweenImageAndLabel,
                                  y: (totalHeight - titleSize.height) / 2,
                                  width: titleSize.width,
                                  height: titleSize.height)
    }
    
    // Override intrinsicContentSize to provide a proper size for the button
    override var intrinsicContentSize: CGSize {
        // Calculate the intrinsic content size based on image and title
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
        setNeedsLayout()  // Trigger layout update when title changes
        invalidateIntrinsicContentSize()  // Ensure intrinsic size is recalculated
    }
}
