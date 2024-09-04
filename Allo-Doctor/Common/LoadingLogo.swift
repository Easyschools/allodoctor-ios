//
//  LoadingLogo.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 02/09/2024.
//

import UIKit

class ImageLayerView: UIView {

    // Initializer for the component
    init(imageName: String, frame: CGRect = CGRect(x: 0, y: 0, width: 86, height: 86)) {
        super.init(frame: frame)
        setupView(imageName: imageName)
    }
    
    // Required initializer for using custom view in Interface Builder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // Provide a default image name or handle loading in the storyboard
        setupView(imageName: "loading")
    }
    
    // Private function to set up the view with a layer
    private func setupView(imageName: String) {
        let image = UIImage(named: imageName)?.cgImage
        let layer0 = CALayer()
        layer0.contents = image
        layer0.bounds = self.bounds
        layer0.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        self.layer.addSublayer(layer0)
    }
}
