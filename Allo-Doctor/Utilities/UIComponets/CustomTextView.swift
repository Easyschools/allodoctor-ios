//
//  CustomTextView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 26/11/2024.
//

import UIKit

class CustomTextView: UITextView, UITextViewDelegate {
    
    // Placeholder label
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .natural
        return label
    }()
    
    // Placeholder text property
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            updateTextDirection()
        }
    }
    
    override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
            updateTextDirection()
        }
    }
    
    // Override textAlignment to ensure it updates both placeholder and text
    override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    // Initialization
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        // Add placeholder label
        addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
        
        // Set delegate for placeholder behavior
        self.delegate = self
        
        // Initial direction setup
        updateTextDirection()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateTextDirection()
    }
    
    private func updateTextDirection() {
        let isRTL = LocalizationManager.shared.isRTL()
        
        if isRTL {
            // Set RTL alignment
            self.textAlignment = .right
            placeholderLabel.textAlignment = .right
            
            // Set RTL semantic attribute
            self.semanticContentAttribute = .forceRightToLeft
            placeholderLabel.semanticContentAttribute = .forceRightToLeft
        
        } else {
            // Set LTR alignment
            self.textAlignment = .left
            placeholderLabel.textAlignment = .right
            
            // Set LTR semantic attribute
            self.semanticContentAttribute = .forceLeftToRight
            placeholderLabel.semanticContentAttribute = .forceLeftToRight
        }
    }
    
    // UITextViewDelegate methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateTextDirection()
    }
}
// Extension to check for Arabic characters
extension String {
    var containsArabicCharacters: Bool {
        let arabicRange = NSMakeRange(0x0600, 0x06FF - 0x0600 + 1)
        return self.unicodeScalars.contains(where: {
            let value = Int(($0).value)
            return NSLocationInRange(value, arabicRange)
        })
    }
}
