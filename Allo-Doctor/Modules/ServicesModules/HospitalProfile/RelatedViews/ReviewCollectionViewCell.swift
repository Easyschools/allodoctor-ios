//
//  ReviewCollectionViewCell.swift
//  Allo-Doctor
//
//  Created for Hospital-First Flow Implementation
//

import UIKit

class ReviewCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var starStackView: UIStackView!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        containerView?.layer.cornerRadius = 12
        containerView?.layer.borderWidth = 1
        containerView?.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        containerView?.backgroundColor = .white

        userImageView?.layer.cornerRadius = 20
        userImageView?.clipsToBounds = true
        userImageView?.contentMode = .scaleAspectFill

        userNameLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        userNameLabel?.textColor = .black

        ratingLabel?.font = UIFont.systemFont(ofSize: 13)
        ratingLabel?.textColor = .black

        commentLabel?.font = UIFont.systemFont(ofSize: 13)
        commentLabel?.textColor = .darkGray
        commentLabel?.numberOfLines = 3

        dateLabel?.font = UIFont.systemFont(ofSize: 11)
        dateLabel?.textColor = .lightGray
    }

    // MARK: - Configuration
    func configure(with review: HospitalReview) {
        userNameLabel?.text = review.userName ?? NSLocalizedString("Anonymous", comment: "")

        if let userImage = review.userImage {
            userImageView?.loadImage(from: userImage)
        } else {
            userImageView?.image = UIImage(systemName: "person.circle.fill")
        }

        if let rating = review.rating {
            ratingLabel?.text = String(format: "%.1f", rating)
            setupStars(rating: rating)
        }

        commentLabel?.text = review.comment

        if let createdAt = review.createdAt {
            dateLabel?.text = formatDate(createdAt)
        }
    }

    private func setupStars(rating: Double) {
        starStackView?.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let fullStars = Int(rating)
        let hasHalfStar = rating - Double(fullStars) >= 0.5

        for i in 0..<5 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .systemYellow

            if i < fullStars {
                imageView.image = UIImage(systemName: "star.fill")
            } else if i == fullStars && hasHalfStar {
                imageView.image = UIImage(systemName: "star.leadinghalf.filled")
            } else {
                imageView.image = UIImage(systemName: "star")
            }

            imageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 14).isActive = true

            starStackView?.addArrangedSubview(imageView)
        }
    }

    private func formatDate(_ dateString: String) -> String {
        // Simple date formatting - can be improved with DateFormatter
        return dateString.components(separatedBy: " ").first ?? dateString
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView?.image = nil
        userNameLabel?.text = nil
        ratingLabel?.text = nil
        commentLabel?.text = nil
        dateLabel?.text = nil
        starStackView?.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
