//
//  ServicesCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 13/09/2024.
//

import UIKit

class ServicesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bookVisitButton: UnderlinedButton!
    
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var serviceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
  
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.applyDropShadow()
    }
}

extension ServicesCollectionViewCell {
    func setupImage(with image: String, serviceId: Int? = nil) {
        serviceImage.kf.setImage(with: URL(string: image))
        
        // Determine button text based on service ID
        if let id = serviceId {
            switch id {
            case 78:  // Contact Doctor
                bookVisitButton.setTitle(AppLocalizedKeys.chatNow.localized, for: .normal)
            case 24:  // Pharmacy
                bookVisitButton.setTitle(AppLocalizedKeys.buyNow.localized, for: .normal)
            default:
                bookVisitButton.setTitle(AppLocalizedKeys.bookVisit.localized, for: .normal)
            }
        } else {
            bookVisitButton.setTitle(AppLocalizedKeys.bookVisit.localized, for: .normal)
        }
    }

    // Support for Specialty (from HospitalModules)
    func setupCell(specialty: Specialty) {
        // Set specialty name based on language
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
            serviceLabel.text = specialty.nameAr ?? specialty.name
        } else {
            serviceLabel.text = specialty.nameEn ?? specialty.name
        }

        // Use a default medical icon for specialty
        serviceImage.image = UIImage(systemName: "stethoscope")
        serviceImage.tintColor = .darkBlue_295DA8

        // Hide book button for specialties
        bookVisitButton.isHidden = true
    }
}
