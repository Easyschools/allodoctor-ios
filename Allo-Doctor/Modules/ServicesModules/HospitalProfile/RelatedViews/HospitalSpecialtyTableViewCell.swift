//
//  HospitalSpecialtyTableViewCell.swift
//  Allo-Doctor
//
//  Created for Hospital-First Flow Implementation
//

import UIKit

class HospitalSpecialtyTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var specialtyIconImageView: UIImageView!
    @IBOutlet weak var specialtyNameLabel: UILabel!
    @IBOutlet weak var specialtyDescriptionLabel: UILabel!
    @IBOutlet weak var doctorsCountLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none

        containerView?.layer.cornerRadius = 12
        containerView?.layer.borderWidth = 1
        containerView?.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        containerView?.backgroundColor = .white

        specialtyIconImageView?.layer.cornerRadius = 8
        specialtyIconImageView?.clipsToBounds = true
        specialtyIconImageView?.contentMode = .scaleAspectFit
        specialtyIconImageView?.tintColor = .systemBlue

        specialtyNameLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        specialtyNameLabel?.textColor = .black

        specialtyDescriptionLabel?.font = UIFont.systemFont(ofSize: 13)
        specialtyDescriptionLabel?.textColor = .gray
        specialtyDescriptionLabel?.numberOfLines = 2

        doctorsCountLabel?.font = UIFont.systemFont(ofSize: 12)
        doctorsCountLabel?.textColor = .systemBlue

        arrowImageView?.image = UIImage(systemName: "chevron.right")
        arrowImageView?.tintColor = .gray
    }

    // MARK: - Configuration
    func configure(with specialty: HospitalSpecialty, viewModel: HospitalProfileViewModel) {
        // Set specialty name based on language
        specialtyNameLabel?.text = viewModel.getSpecialtyDisplayName(for: specialty)

        // Set description
        if LocalizationManager.shared.getCurrentLanguage() == "ar" {
            specialtyDescriptionLabel?.text = specialty.descriptionAr ?? specialty.description
        } else {
            specialtyDescriptionLabel?.text = specialty.descriptionEn ?? specialty.description
        }

        // Set doctors count
        if let doctorsCount = specialty.doctorsCount {
            doctorsCountLabel?.text = "\(doctorsCount) " +
                NSLocalizedString("Doctors", comment: "")
        } else {
            doctorsCountLabel?.text = ""
        }

        // Set icon
        if let imageURL = specialty.image {
            specialtyIconImageView?.loadImage(from: imageURL)
        } else {
            specialtyIconImageView?.image = UIImage(systemName: "stethoscope")
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        specialtyIconImageView?.image = nil
        specialtyNameLabel?.text = nil
        specialtyDescriptionLabel?.text = nil
        doctorsCountLabel?.text = nil
    }
}
