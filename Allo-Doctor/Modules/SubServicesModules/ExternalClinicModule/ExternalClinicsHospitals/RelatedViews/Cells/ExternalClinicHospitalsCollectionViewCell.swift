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
    func setupCell(infoService:InfoService) {
        hospitablBackGroundImage.addOverlay(color: .black)
        // Configure the hospital name
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
            self.hospitalName.text = infoService.nameAr ?? AppLocalizedKeys.notAvailable.localized
        }
        else {
            self.hospitalName.text = infoService.nameEn ?? AppLocalizedKeys.notAvailable.localized
        }
       
        
        // Configure the hospital address
        self.hospitalAdress.text =  infoService.address ?? AppLocalizedKeys.notAvailable.localized
        // Configure the hospital image using Kingfisher
        if let imageURL = infoService.image, let url = URL(string: imageURL) {
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
extension ExternalClinicHospitalsCollectionViewCell
{
    func setupCell(infoService:OneDayCarHosptalsData) {
        hospitablBackGroundImage.addOverlay(color: .black)
        // Configure the hospital name
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
            self.hospitalName.text = infoService.nameAr ?? AppLocalizedKeys.notAvailable.localized
        }
        else {
            self.hospitalName.text = infoService.nameEn ?? AppLocalizedKeys.notAvailable.localized
        }
       
        
        // Configure the hospital address
        self.hospitalAdress.text =  infoService.address ?? AppLocalizedKeys.notAvailable.localized
        // Configure the hospital image using Kingfisher
        if let imageURL = infoService.image, let url = URL(string: imageURL) {
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
