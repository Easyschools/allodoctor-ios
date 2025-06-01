//
//  StarRatingView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/12/2024.
//
import UIKit

class StarRatingView: UIView {
    
    // MARK: - Properties
    private let ratingLabel = UILabel()
    private let starStackView = UIStackView()
    
    // Star images
    private let filledStarImage: UIImage = UIImage.filledStar
    private let halfFilledStarImage: UIImage = UIImage.halfFilledStar
    private let emptyStarImage: UIImage = UIImage.emptyStar
    
    private let numberOfStars = 5
    
    // MARK: - Initialization
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // MARK: - View Setup
    private func setupView() {
        // Set up the rating label
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        ratingLabel.textAlignment = .right
        addSubview(ratingLabel)
        
        // Set up the star stack view
        starStackView.translatesAutoresizingMaskIntoConstraints = false
        starStackView.axis = .horizontal
        starStackView.distribution = .fillEqually
        starStackView.spacing = 4
        addSubview(starStackView)
        
        // Add star image views
        for _ in 0..<numberOfStars {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.image = emptyStarImage
            starStackView.addArrangedSubview(starImageView)
        }
        
        // Add constraints
        NSLayoutConstraint.activate([
            // Rating label constraints
            ratingLabel.topAnchor.constraint(equalTo: topAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Star stack view constraints
            starStackView.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 4),
            starStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            starStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            starStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Configuration
    func configure(rating: Double) {
        // Set the rating label
        ratingLabel.text = String(format: "%.1f", rating)
        
        // Update stars
        for (index, star) in starStackView.arrangedSubviews.enumerated() {
            guard let imageView = star as? UIImageView else { continue }
            if CGFloat(index + 1) <= rating {
                imageView.image = filledStarImage
            } else if CGFloat(index) < rating && CGFloat(index + 1) > rating {
                imageView.image = halfFilledStarImage
            } else {
                imageView.image = emptyStarImage
            }
        }
    }
}
