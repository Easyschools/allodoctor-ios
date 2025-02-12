//
//  RatingView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 03/10/2024.
//

import UIKit

class RatingView: UIView {

    // MARK: - Properties
    private var rating: Double = 0 {
        didSet {
            setupView()
        }
    }
    private let maxStars: Int = 5
    private let starSize: CGSize = CGSize(width: 10, height: 10)
    private let starSpacing: CGFloat = 3

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup View
    private func setupView() {
        // Remove any existing star views
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        // Calculate the number of filled and unfilled stars
        let fullStars = Int(rating)
        let hasHalfStar = rating - Double(fullStars) >= 0.5
        
        // Calculate the total width of all stars including spacing
        let totalWidth = CGFloat(maxStars) * starSize.width + CGFloat(maxStars - 1) * starSpacing
        
        // Calculate the starting X position to center the stars
        let startingX = (self.frame.width - totalWidth) / 2
        
        // Create star views
        for i in 0..<maxStars {
            let starImageView = UIImageView()
            starImageView.frame = CGRect(
                x: startingX + CGFloat(i) * (starSize.width + starSpacing),  // Adjust X based on centering
                y: 0,
                width: starSize.width,
                height: starSize.height
            )
            
            // Set star image based on rating
            if i < fullStars {
                starImageView.image = .filledStar // Replace with your filled star image
            } else if i == fullStars && hasHalfStar {
                starImageView.image = .star // Replace with your half-filled star image
            } else {
                starImageView.image = .star // Replace with your empty star image
            }
            
            addSubview(starImageView)
        }
        
        // Adjust the view's intrinsic content size based on the total width
        frame.size = CGSize(width: totalWidth, height: starSize.height)
    }

    // MARK: - Configure View
    func configure(withRating rating: Double) {
        self.rating = rating
    }
}
