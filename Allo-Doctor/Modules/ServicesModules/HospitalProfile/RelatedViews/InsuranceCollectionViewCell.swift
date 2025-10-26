//
//  InsuranceCollectionViewCell.swift
//  Allo-Doctor
//
//  Created for Hospital-First Flow Implementation
//

import UIKit

class InsuranceCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var insuranceImageView: UIImageView!
    @IBOutlet weak var insuranceNameLabel: UILabel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        containerView?.layer.cornerRadius = 8
        containerView?.layer.borderWidth = 1
        containerView?.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        containerView?.backgroundColor = .white

        insuranceImageView?.contentMode = .scaleAspectFit
        insuranceImageView?.layer.cornerRadius = 4
        insuranceImageView?.clipsToBounds = true

        insuranceNameLabel?.font = UIFont.systemFont(ofSize: 10)
        insuranceNameLabel?.textColor = .darkGray
        insuranceNameLabel?.textAlignment = .center
        insuranceNameLabel?.numberOfLines = 2
    }

    // MARK: - Configuration
    func configure(with insurance: MedicalInsurance) {
        if LocalizationManager.shared.getCurrentLanguage() == "ar" {
            insuranceNameLabel?.text = insurance.nameAr ?? insurance.name
        } else {
            insuranceNameLabel?.text = insurance.nameEn ?? insurance.name
        }

        if let imageURL = insurance.image {
            insuranceImageView?.loadImage(from: imageURL)
        } else {
            insuranceImageView?.image = UIImage(systemName: "doc.text.fill")
            insuranceImageView?.tintColor = .systemBlue
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        insuranceImageView?.image = nil
        insuranceNameLabel?.text = nil
    }
}
