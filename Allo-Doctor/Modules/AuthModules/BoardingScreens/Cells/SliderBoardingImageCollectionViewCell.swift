//
//  SliderBoardingImageCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 06/09/2024.
//

import UIKit

class SliderBoardingImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var onBoardingImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    func configure(with image: UIImage) {
        onBoardingImage.image = image
       }
}
