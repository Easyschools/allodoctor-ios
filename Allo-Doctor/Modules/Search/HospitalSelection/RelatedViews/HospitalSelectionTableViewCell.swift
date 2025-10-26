//
//  HospitalSelectionTableViewCell.swift
//  Allo-Doctor
//
//  Created for Hospital-First Flow Implementation
//

import UIKit

class HospitalSelectionTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    // NOTE: These need to be connected in the XIB file
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var hospitalImageView: UIImageView!
    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var hospitalAddressLabel: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var specialtiesCountLabel: UILabel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none

        // Container view styling
        containerView?.layer.cornerRadius = 12
        containerView?.layer.shadowColor = UIColor.black.cgColor
        containerView?.layer.shadowOpacity = 0.1
        containerView?.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView?.layer.shadowRadius = 4
        containerView?.backgroundColor = .white

        // Hospital image styling
        hospitalImageView?.layer.cornerRadius = 8
        hospitalImageView?.clipsToBounds = true
        hospitalImageView?.contentMode = .scaleAspectFill

        // Labels styling
        hospitalNameLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        hospitalNameLabel?.textColor = .black
        hospitalNameLabel?.numberOfLines = 2

        hospitalAddressLabel?.font = UIFont.systemFont(ofSize: 14)
        hospitalAddressLabel?.textColor = .gray
        hospitalAddressLabel?.numberOfLines = 2

        ratingLabel?.font = UIFont.systemFont(ofSize: 14)
        ratingLabel?.textColor = .black

        reviewsCountLabel?.font = UIFont.systemFont(ofSize: 12)
        reviewsCountLabel?.textColor = .gray

        distanceLabel?.font = UIFont.systemFont(ofSize: 12)
        distanceLabel?.textColor = .systemBlue

        districtLabel?.font = UIFont.systemFont(ofSize: 12)
        districtLabel?.textColor = .gray

        specialtiesCountLabel?.font = UIFont.systemFont(ofSize: 12)
        specialtiesCountLabel?.textColor = .systemGreen

        // Star image
        starImageView?.image = UIImage(systemName: "star.fill")
        starImageView?.tintColor = .systemYellow
    }

    // MARK: - Configuration
    func configure(with hospital: UnifiedHospital) {
        // Set hospital name based on language
        if LocalizationManager.shared.getCurrentLanguage() == "ar" {
            hospitalNameLabel?.text = hospital.nameAr ?? hospital.name
        } else {
            hospitalNameLabel?.text = hospital.nameEn ?? hospital.name
        }

        // Set address
        hospitalAddressLabel?.text = hospital.address

        // Load image
        if let imageURL = hospital.image {
            hospitalImageView?.loadImage(from: imageURL)
        } else {
            hospitalImageView?.image = UIImage(named: "placeholder_hospital")
        }

        // Set rating
        if let rating = hospital.avgRating {
            ratingLabel?.text = String(format: "%.1f", rating)
            ratingStackView?.isHidden = false

            if let reviewsCount = hospital.reviewsCount {
                reviewsCountLabel?.text = "(\(reviewsCount))"
            } else {
                reviewsCountLabel?.text = ""
            }
        } else {
            ratingStackView?.isHidden = true
        }

        // Set distance
        if let distance = hospital.distance {
            if distance < 1 {
                distanceLabel?.text = String(format: "%.0f m", distance * 1000)
            } else {
                distanceLabel?.text = String(format: "%.1f km", distance)
            }
            distanceLabel?.isHidden = false
        } else {
            distanceLabel?.isHidden = true
        }

        // Set district
        if let district = hospital.district {
            if LocalizationManager.shared.getCurrentLanguage() == "ar" {
                districtLabel?.text = district.nameAr ?? district.name
            } else {
                districtLabel?.text = district.nameEn ?? district.name
            }
        }

        // Set specialties count
        if let specialtiesCount = hospital.specialties?.count, specialtiesCount > 0 {
            specialtiesCountLabel?.text = "\(specialtiesCount) " +
                NSLocalizedString("Specialties", comment: "")
        } else {
            specialtiesCountLabel?.text = ""
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        hospitalImageView?.image = nil
        hospitalNameLabel?.text = nil
        hospitalAddressLabel?.text = nil
        ratingLabel?.text = nil
        reviewsCountLabel?.text = nil
        distanceLabel?.text = nil
        districtLabel?.text = nil
        specialtiesCountLabel?.text = nil
    }
}
