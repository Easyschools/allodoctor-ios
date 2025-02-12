//
//  UIImageView+Extentions.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 15/09/2024.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
import UIKit
extension UIImage {
    static let homeunfilled =  home
    static let homefilled = homeFilled
    static let profileUnfilld = profile
    static let profileImageFileld = profileFilled
    static let offersUnfilled = offferUnfilled
    static let offersfilled = offerFilled
    static let activityFilled = activityfiiled
    static let activityUnfilled = activity
}

extension UIImageView {
    func addOverlay(color: UIColor, alpha: CGFloat = 0.32) {
        // Remove any existing overlay (optional)
        self.subviews.forEach { $0.removeFromSuperview() }

        // Create an overlay view
        let overlayView = UIView(frame: self.bounds)
        overlayView.backgroundColor = color.withAlphaComponent(alpha)
        overlayView.isUserInteractionEnabled = false
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // Adjust for resizing
        
        // Add the overlay view to the UIImageView
        self.addSubview(overlayView)
    }
}
