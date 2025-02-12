//
//  LabsCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/09/2024.
//

import UIKit

class LabsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labImage: CircularImageView!
    @IBOutlet weak var labName: CairoBold!
    @IBOutlet weak var labsBackGroundImage: UIImageView!
    @IBOutlet weak var labsImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        labsBackGroundImage.addOverlay(color: .black)
    }

    // Configure the cell with individual properties
    func configure(labName: String, imageURL: String) {
        // Set the lab name
        self.labName.text = labName

        // Load the image using Kingfisher
        if let url = URL(string: imageURL) {
            self.labImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImage"))
        }
    }
}
