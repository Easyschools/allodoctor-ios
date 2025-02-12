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
    override func layoutSubviews() {
        contentView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    func configure(with image: UIImage) {
        onBoardingImage.image = image
       }
}
