//
//  PharmacyGlobalSearchCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 30/11/2024.
//

import UIKit

class PharmacyGlobalSearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var pharmcyName: CairoMeduim!
    
    @IBOutlet weak var pharmacyImage: CircularImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyDropShadow()
 
            }

    func setupCell(pharmacyName: String, logoUrl: String?) {
        // Set text for labels
        self.pharmcyName.text = pharmacyName
       
        
        // Load images using Kingfisher
        if let logoUrlString = logoUrl, let logoURL = URL(string: logoUrlString) {
            self.pharmacyImage.kf.setImage(with: logoURL, placeholder: UIImage(named: "placeholderLogo"))
        } else {
            self.pharmacyImage.image = UIImage(named: "placeholderLogo") // Fallback placeholder image
        }

       
    }
   
}
