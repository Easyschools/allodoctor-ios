//
//  UITextField+Extentions.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/09/2024.
//

import UIKit

public extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor {
        set {
            self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.foregroundColor: newValue])
        } get {
            return self.placeHolderColor
        }
    }
    @IBInspectable var border: CGColor {
        set {
            layer.borderColor = newValue
        } get {
            return layer.borderColor ?? UIColor.clear.cgColor
        }
    }
    
    var isEmpty: Bool {
        return text?.isEmpty == true
    }
}

public extension UITextField {
    
    enum Direction {
        case left
        case right
    }
    
    func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    
    func setPlaceHolderTextColor(_ color: UIColor) {
        guard let holder = placeholder, !holder.isEmpty else {
            return
        }
        self.attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color])
    }
    
    func addPadding(By value: CGFloat, for direction: Direction) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: frame.height))
        switch direction {
        case .left:
            leftView = paddingView
            leftViewMode = .always
        case .right:
            rightView = paddingView
            rightViewMode = .always
        }
    }
    
    func addPaddingIcon(_ image: UIImage, padding: CGFloat, for direction: Direction) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        let viewSize = CGSize(width: image.size.width + padding, height: image.size.height)
        switch direction {
        case .left:
            leftView = imageView
            leftView?.frame.size = viewSize
            leftViewMode = .always
        case .right:
            rightView = imageView
            rightView?.frame.size = viewSize
            rightViewMode = .always
        }
    }
}

extension UITextField {
    func setCharacterLimit(_ limit: Int) {
        self.addTarget(self, action: #selector(checkCharacterLimit), for: .editingChanged)
        self.accessibilityHint = "\(limit)" // Store the limit in accessibilityHint
    }
    
    @objc private func checkCharacterLimit() {
        guard let limit = Int(self.accessibilityHint ?? ""), let text = self.text else { return }
        if text.count > limit {
            self.text = String(text.prefix(limit)) // Trim the text to the limit
        }
    }

}



extension UITextField {
    func validateNotEmpty(message: String, viewController: UIViewController) -> Bool {
        guard let text = self.text, !text.isEmpty else {
            showAlert(message: message, viewController: viewController)
            return false
        }
        return true
    }

    func validateNumberInRange(min: Int, max: Int, message: String, viewController: UIViewController) -> Bool {
        guard let text = self.text, let value = Int(text), value >= min, value <= max else {
            showAlert(message: message, viewController: viewController)
            return false
        }
        return true
    }
    
    private func showAlert(message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    func isValidEgyptianNumber() -> Bool {
           guard let text = self.text else { return false }
           let egyptianPhoneNumberRegex = "^01[0-2,5]{1}[0-9]{8}$"
           let predicate = NSPredicate(format: "SELF MATCHES %@", egyptianPhoneNumberRegex)
           return predicate.evaluate(with: text)
       }
}
