//
//  LabsCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/09/2024.
//

import UIKit

class LabsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labImage: CircularImageView!
    @IBOutlet weak var labName: CairoBold!
    @IBOutlet weak var labsBackGroundImage: UIImageView!
    @IBOutlet weak var labsImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        labsBackGroundImage.addOverlay(color: .black)
    }

    // Configure the cell with individual properties
    func configure(labName: String, imageURL: String) {
        // Set the lab name
        self.labName.text = labName

        // Load the image using Kingfisher
        if let url = URL(string: imageURL) {
            self.labImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImage"))
        }
    }
}

// MARK: - Hospital Support Extension
extension LabsCollectionViewCell {
    func configure(hospital: HospitalInfoService) {
        // Set hospital name based on language
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
            labName.text = hospital.nameAr ?? hospital.name ?? "Unknown"
        } else {
            labName.text = hospital.nameEn ?? hospital.name ?? "Unknown"
        }

        // Load hospital image
        if let imageURL = hospital.image, let url = URL(string: imageURL) {
            labImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImage"))
        } else {
            labImage.image = UIImage(named: "placeholderImage")
        }
    }
}

// MARK: - Specialty Support Extension
extension LabsCollectionViewCell {
    func configure(specialty: Specialty) {
        // Set specialty name based on language
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
            labName.text = specialty.nameAr ?? specialty.name ?? "Unknown"
        } else {
            labName.text = specialty.nameEn ?? specialty.name ?? "Unknown"
        }

        // Use stethoscope icon for specialties
        labImage.image = UIImage(systemName: "stethoscope")
        labImage.tintColor = .darkBlue_295DA8
    }
}
