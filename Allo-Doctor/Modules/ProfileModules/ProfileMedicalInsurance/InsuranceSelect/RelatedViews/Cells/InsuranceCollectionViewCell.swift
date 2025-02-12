//
//  InsuranceCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 31/12/2024.
//

import UIKit
import Kingfisher

class InsuranceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var insuranceName: CairoRegular!
    @IBOutlet weak var insuranceImage: CircularImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(name: String?, imageUrl: String?) {
        // Set the insurance name
        insuranceName.text = name ?? "No Name Available"

        // Load the image with Kingfisher
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            insuranceImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            insuranceImage.image = UIImage(named: "placeholder") // Fallback to placeholder
        }
    }
}
