//
//  PharmacyCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 20/10/2024.
//

import UIKit
import Kingfisher
class PharmacyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var deleviryFees: UILabel!
    @IBOutlet weak var pharmacyArea: CairoRegular!
    @IBOutlet weak var deleviryTime: CairoRegular!
    @IBOutlet weak var pharmacyName: CairoBold!
    @IBOutlet weak var pharmacyLogo: CircularImageView!
    @IBOutlet weak var phamracyBacgroundImage: UIImageView!

    @IBOutlet weak var ratingView: StarRatingView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyDropShadow()
        phamracyBacgroundImage.addOverlay(color: .black)
            }

    func setupCell(pharmacyName: String, area: String, deliveryFees: String, deliveryTime: String, logoUrl: String?, backgroundImageUrl: String?) {
        // Set text for labels
        self.pharmacyName.text = pharmacyName
        self.pharmacyArea.text = area
        self.deleviryFees.text = deliveryFees.withoutDecimals.appendingWithSpace(AppLocalizedKeys.EGP.localized)
        self.deleviryTime.text = deliveryTime
        
        // Load images using Kingfisher
        if let logoUrlString = logoUrl, let logoURL = URL(string: logoUrlString) {
            self.pharmacyLogo.kf.setImage(with: logoURL, placeholder: UIImage(named: "placeholderLogo"))
        } else {
            self.pharmacyLogo.image = UIImage(named: "placeholderLogo") // Fallback placeholder image
        }

        if let backgroundUrlString = backgroundImageUrl, let backgroundURL = URL(string: backgroundUrlString) {
            self.phamracyBacgroundImage.kf.setImage(with: backgroundURL, placeholder: UIImage(named: "placeholderBackground"))
        } else {
            self.phamracyBacgroundImage.image = UIImage(named: "placeholderBackground") // Fallback placeholder image
        }
    }
   
       
    
   }

