//
//  DoctorClinicPhotosCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 01/10/2024.
//

import UIKit
import Kingfisher
class DoctorClinicPhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var clinicPhotos: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
func configureImage(with imageURL: String) {
        let imageURL = URL(string: imageURL)
        clinicPhotos.kf.setImage(
               with: imageURL,
               placeholder: UIImage.onBoarding)
       }
}
