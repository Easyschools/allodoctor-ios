//
//  LanguageSelectionButton.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/09/2024.
//
import UIKit

enum Language: String {
    case english = "English"
    case arabic = "عربى"
}

class LanguageSelectionButton: UIButton {
    
    private let checkmarkImage = UIImage(systemName: "checkmark")
    private var language: Language = .english
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        layer.cornerRadius = 10
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func configure(for language: Language, isActive: Bool) {
        self.language = language
        setTitle(language.rawValue, for: .normal)
        
        // Check active state and set appearance
        if isActive {
            backgroundColor = UIColor(red: 0.118, green: 0.49, blue: 0.753, alpha: 1)
            setTitleColor(.white, for: .normal)
            setImage(checkmarkImage, for: .normal)
            layer.borderWidth = 0
        } else {
            backgroundColor = .white
            setTitleColor(.black, for: .normal)
            setImage(nil, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = UIColor.lightGray.cgColor
        }
        
        adjustLayout()
        setNeedsLayout()
    }
    
    private func adjustLayout() {
        // Text will always be aligned left, image aligned right
        contentHorizontalAlignment = .left
        let imageRightPadding: CGFloat = 20  // Padding between the image and the right edge
        let textImageSpacing: CGFloat = bounds.width - 60  // Adjust to push image to the right

        // Adjust insets for image and title to position them correctly
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: textImageSpacing)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: textImageSpacing, bottom: 0, right: -imageRightPadding)
    }
}
