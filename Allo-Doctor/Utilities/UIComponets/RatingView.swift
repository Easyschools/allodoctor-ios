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
        
        // Create star views
        for i in 0..<maxStars {
            let starImageView = UIImageView()
            starImageView.frame = CGRect(
                x: CGFloat(i) * (starSize.width + starSpacing),
                y: 0,
                width: starSize.width,
                height: starSize.height
            )
            
            if i < fullStars {
                starImageView.image = UIImage.filledStar // Replace with your filled star image
            } else if i == fullStars && hasHalfStar {
                starImageView.image = UIImage.star // Replace with your half-filled star image
            } else {
                starImageView.image = UIImage.star // Replace with your empty star image
            }
            
            addSubview(starImageView)
        }
        
        // Adjust the view's width based on the number of stars
        let totalWidth = CGFloat(maxStars) * starSize.width + CGFloat(maxStars - 1) * starSpacing
        frame.size = CGSize(width: totalWidth, height: starSize.height)
    }
    
    // MARK: - Configure View
    func configure(withRating rating: Double) {
        self.rating = rating
    }
}
