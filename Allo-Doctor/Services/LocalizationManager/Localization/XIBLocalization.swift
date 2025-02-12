
import Foundation
import UIKit

protocol XIBLocalizable {
    var xibLocKey: String? { get set }
}

extension UILabel: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
            textAlignment = LocalizationManager.shared.isRTL() ? .right : .left // Adjust alignment based on language direction
        }
    }
}



extension UIImageView {
    // Property for localized image
    @IBInspectable var xibLocImageKey: String? {
        get { return nil }
        set(imageKey) {
            guard let imageKey = imageKey else { return }

            // Retrieve the image name using the localization key
            if let localizedImageName = AppLocalizedKeys(rawValue: imageKey) {
                let imageName = localizedImageName.rawValue
                let image = UIImage(named: imageName)
                self.image = image
            }
            
            // Optionally adjust image based on language direction (mirror image for RTL)
            if LocalizationManager.shared.isRTL() {
                self.transform = CGAffineTransform(scaleX: -1, y: 1)  // Mirror the image
            } else {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)   // Reset the image to original orientation
            }
        }
    }
}

extension UIButton: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            guard let key = key else { return }
            
            // Set the localized title
            setTitle(key.localized, for: .normal)
            
            // Adjust title alignment based on language direction
           
            // Ensure the text is centered within the button
            titleLabel?.textAlignment = .center
        }
    }

    // Property for localized image (for image buttons)
    @IBInspectable var xibLocImageKey: String? {
        get { return nil }
        set(imageKey) {
            guard let imageKey = imageKey else { return }

            // Here you can use localization keys to assign different images
            if let localizedImageName = AppLocalizedKeys(rawValue: imageKey) {
                let imageName = localizedImageName.rawValue
                let image = UIImage(named: imageName)
                setImage(image, for: .normal)
            }
            
            // Optionally adjust image based on language direction (mirror image for RTL)
            if LocalizationManager.shared.isRTL() {
                transform = CGAffineTransform(scaleX: -1, y: 1)  // Mirror the image
            } else {
                transform = CGAffineTransform(scaleX: 1, y: 1)   // Reset the image to original orientation
            }
        }
    }
}
extension UITextField {
    // Property for localized text
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            guard let key = key else { return }
            // Set the localized text
            text = key.localized
            textAlignment = LocalizationManager.shared.isRTL() ? .right : .left // Adjust alignment based on language direction
        }
    }

    // Property for localized placeholder
    @IBInspectable var xibLocPlaceholderKey: String? {
        get { return nil }
        set(placeholderKey) {
            guard let placeholderKey = placeholderKey else { return }
            // Set the localized placeholder
            placeholder = placeholderKey.localized
            textAlignment = LocalizationManager.shared.isRTL() ? .right : .left // Adjust alignment based on language direction
        }
    }
}


extension UITextView: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
            textAlignment = LocalizationManager.shared.isRTL() ? .right : .left // Adjust alignment based on language direction
        }
    }
}
