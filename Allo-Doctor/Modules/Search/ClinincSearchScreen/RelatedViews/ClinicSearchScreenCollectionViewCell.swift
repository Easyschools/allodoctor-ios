//
//  ClinicSearchScreenCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/09/2024.
//

import UIKit

class ClinicSearchScreenCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ClinicTitle: UILabel!

    @IBOutlet weak var ClinicName: CairoBold!
    @IBOutlet weak var clinicImage: CircularImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // Configure for specialty display
    func configure(specialty: Specialty) {
        let language = UserDefaultsManager.sharedInstance.getLanguage()

        // Set specialty name
        ClinicName.text = language == .ar ? (specialty.nameAr ?? specialty.name) : (specialty.nameEn ?? specialty.name)

        // Set "Speciality" label
        ClinicTitle.text = AppLocalizedKeys.Speciality.localized
        ClinicTitle.textColor = .lightGray
        ClinicTitle.font = UIFont.systemFont(ofSize: 14)

        // Hide or set default image
        clinicImage.isHidden = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset for reuse
        clinicImage.isHidden = false
        ClinicTitle.textColor = .black
    }
}
