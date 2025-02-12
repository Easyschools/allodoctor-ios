//
//  OperationHospitalsCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 17/11/2024.
//

import UIKit
import Kingfisher

class OperationHospitalsCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var price: CairoRegular!
    @IBOutlet weak var hospitalLogo: CircularImageView!
    @IBOutlet weak var name: CairoBold!
    @IBOutlet weak var district: CairoRegular!
    @IBOutlet weak var hospitalBackGround: UIImageView!
    @IBOutlet weak var starRatingView: StarRatingView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        hospitalBackGround.addOverlay(color: .black)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.applyDropShadow()
    }
    
    // MARK: - Cell Setup
    func setupCell(price: String, hospitalLogoURL: String?, name: String, district: String, rating: Double) {
        // Set the price label
        self.price.text = price
        
        // Load the hospital logo using Kingfisher
        let placeholderImage = UIImage(named: "placeholder") // Replace with your placeholder image
        hospitalLogo.kf.setImage(with: URL (string: hospitalLogoURL ?? ""), placeholder: placeholderImage)
        
        // Set the name and district labels
        self.name.text = name
        self.district.text = district
        
        // Configure the star rating view
        starRatingView.configure(rating: 4.4)
    }
}
