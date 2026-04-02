//
//  HospitalCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Assistant on 14/11/2025.
//

import UIKit
import Kingfisher

class HospitalCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let hospitalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.backgroundColor = .greishWhiteF2F2F2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let hospitalNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let specialtiesCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .darkBlue_295DA8
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(hospitalImageView)
        containerView.addSubview(hospitalNameLabel)
        containerView.addSubview(addressLabel)
        containerView.addSubview(specialtiesCountLabel)

        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            // Hospital image
            hospitalImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            hospitalImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            hospitalImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            hospitalImageView.heightAnchor.constraint(equalToConstant: 100),

            // Hospital name
            hospitalNameLabel.topAnchor.constraint(equalTo: hospitalImageView.bottomAnchor, constant: 8),
            hospitalNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            hospitalNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            // Address
            addressLabel.topAnchor.constraint(equalTo: hospitalNameLabel.bottomAnchor, constant: 4),
            addressLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            addressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            // Specialties count
            specialtiesCountLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 4),
            specialtiesCountLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            specialtiesCountLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            specialtiesCountLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8)
        ])
    }

    // MARK: - Configuration
    func configure(with hospital: HospitalInfoService) {
        // Set hospital name based on language
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
            hospitalNameLabel.text = hospital.nameAr ?? hospital.name ?? "Unknown"
        } else {
            hospitalNameLabel.text = hospital.nameEn ?? hospital.name ?? "Unknown"
        }

        // Set address
        addressLabel.text = hospital.district?.name ?? hospital.address ?? ""

        // Set specialties count
        let count = hospital.specialties.count
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
            specialtiesCountLabel.text = "\(count) تخصص"
        } else {
            specialtiesCountLabel.text = "\(count) Specialties"
        }

        // Set background image
        if let backgroundURLString = hospital.backgroundImage, let backgroundURL = URL(string: backgroundURLString) {
            hospitalImageView.kf.setImage(
                with: backgroundURL,
                placeholder: UIImage(named: "hospitalsBackGround"),
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        } else {
            hospitalImageView.image = UIImage(named: "hospitalsBackGround")
        }
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        hospitalImageView.image = nil
        hospitalNameLabel.text = nil
        addressLabel.text = nil
        specialtiesCountLabel.text = nil
    }
}
