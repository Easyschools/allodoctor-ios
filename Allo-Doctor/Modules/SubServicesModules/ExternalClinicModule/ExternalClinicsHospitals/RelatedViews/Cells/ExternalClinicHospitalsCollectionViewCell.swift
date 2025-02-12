//
//  ExternalClinicHospitalsCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 17/11/2024.
//

import UIKit
import Kingfisher

class ExternalClinicHospitalsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var hospitablBackGroundImage: UIImageView!
    @IBOutlet weak var hospitalName: CairoBold!
    @IBOutlet weak var hospitalAdress: CairoRegular!
    @IBOutlet weak var hospitalImage: CircularImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        contentView.applyDropShadow()
    }
    
    /// Sets up the cell with raw data
    func setupCell(hospitalName: String?, hospitalAddress: String?, hospitalImageURL: String?) {
        hospitablBackGroundImage.addOverlay(color: .black)
        // Configure the hospital name
        self.hospitalName.text = hospitalName ?? "Unknown Hospital"
        
        // Configure the hospital address
        self.hospitalAdress.text = hospitalAddress ?? "Address not available"
        
        // Configure the hospital image using Kingfisher
        if let imageURL = hospitalImageURL, let url = URL(string: imageURL) {
            self.hospitalImage.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder"), // Placeholder image name
                options: [
                    .transition(.fade(0.2)), // Smooth transition
                    .cacheOriginalImage       // Cache the original image
                ]
            )
        } else {
            self.hospitalImage.image = UIImage(named: "placeholder") // Fallback image
        }
    }
}
