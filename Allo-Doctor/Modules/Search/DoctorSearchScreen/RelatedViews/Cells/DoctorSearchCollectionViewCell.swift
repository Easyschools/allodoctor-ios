//
//  DoctorSearchCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/09/2024.
//

import UIKit
import Kingfisher

class DoctorSearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var reviewsCount: CairoRegular!
    @IBOutlet weak var ratingView: StarRatingView!
    @IBOutlet weak var doctorImage: CircularImageView!
    @IBOutlet weak var doctorName: CairoBold!
    @IBOutlet weak var avalibailtyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var waitingTime: CairoBold!
    @IBOutlet weak var feesLabel: CairoBold!
    @IBOutlet weak var AdressLabel: CairoBold!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var customAdressLabel: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension DoctorSearchCollectionViewCell {
    func setupCell(
        with doctor: DoctorProfile
    ) {
        // Set doctor name
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            doctorName.text = doctor.nameAr
        }
        else{
            doctorName.text = doctor.nameEn
        }
        // Set description
        descriptionLabel.text = doctor.titleEn
        

        waitingTime.text = "\(doctor.waitingTime?.toString() ?? "Zero") mins"
        
        // Set fees
        feesLabel.text = "\(doctor.price ?? "Free") EGP"
        
        // Set address
        AdressLabel.text = doctor.address ?? "Not Avalibaile"
        cityLabel.text = doctor.district?.name ?? "Not Avalibaile"
        
        // Set reviews count
        reviewsCount.text =  "(\(doctor.reviewsCount?.toString() ?? "Not Avalibaile"))"
        
        // Configure rating view
        ratingView.configure(rating: doctor.avgRating ?? 0)
        
        // Load image using Kingfisher
        if let imageUrl = URL(string: doctor.mainImage ?? "") {
            doctorImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder"))
        }
    }
}
