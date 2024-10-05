//
//  CustomLoadingScreen.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 30/09/2024.
//

import UIKit

class CustomLoadingScreen: UIView {
    
    private let backgroundView: UIView
    private let imageView: UIImageView
    
    init(image: UIImage = UIImage.blueAppLogos) {
        backgroundView = UIView()
        imageView = UIImageView(image: CustomLoadingScreen.makeImageTransparent(image))
        
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Setup transparent white background
        addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Setup image view
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor,constant: 5),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 170),
            imageView.heightAnchor.constraint(equalToConstant: 170)
        ])

    }
    
    func startLoading() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    func stopLoading() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    // Function to make the image transparent
    static func makeImageTransparent(_ image: UIImage, alpha: CGFloat = 0.7) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? image
    }
}

// Extension to add the blueAppLogo to UIImage
extension UIImage {
    static var blueAppLogos: UIImage {
        return UIImage.blueAppLogo    }
}
