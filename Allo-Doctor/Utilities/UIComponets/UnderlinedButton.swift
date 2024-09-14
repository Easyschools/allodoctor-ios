//
//  UnderlinedButton.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 13/09/2024.
//

import UIKit

@IBDesignable
class UnderlinedButton: UIButton {
    
    @IBInspectable var fontSize: CGFloat = 18.0 {
        didSet {
            setupButton()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupButton()
    }
    
    private func setupButton() {
        if let customFont = UIFont(name: "Cairo-SemiBold", size: fontSize) {
            self.titleLabel?.font = customFont
        } else {
            self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        }
        
        
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.lineBreakMode = .byTruncatingTail
        
        if let currentTitle = self.title(for: .normal) {
            let attributedString = NSAttributedString(
                string: currentTitle,
                attributes: [
                    .font: self.titleLabel?.font ?? UIFont.systemFont(ofSize: fontSize),
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ]
            )
            self.setAttributedTitle(attributedString, for: .normal)
        }
        
        
        self.titleLabel?.textAlignment = .center
    }
}
