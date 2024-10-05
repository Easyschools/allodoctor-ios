//
//  CircularImage.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/09/2024.
//

import UIKit

class CircularImageView: UIImageView {
    
    // Initializer for programmatic UI setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // Initializer for using in Storyboards or XIBs
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // Custom setup for making the image circular
    private func setupView() {
        // Make the image circular by setting cornerRadius
        layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true
        
        // Optionally add a border (optional)
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        contentMode = .scaleAspectFill
    }
    
    // Set the image with a URL (optional extension)
    func setImage(from url: URL?) {
        guard let url = url else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
