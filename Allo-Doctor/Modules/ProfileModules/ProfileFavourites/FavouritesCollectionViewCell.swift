//
//  FavouritesCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 29/12/2024.
//

import UIKit
import Kingfisher

class FavouritesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var faVButton: UIButton!
    @IBOutlet weak var favTitle: CairoRegular!
    @IBOutlet weak var favName: CairoMeduim!
    @IBOutlet weak var favImage: UIImageView!

    // Closure to handle button action
    var favouriteButtonTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Attach action to the button
        faVButton.addTarget(self, action: #selector(faVButtonAction), for: .touchUpInside)
    }

    /// Configure the cell directly with data
    func configure(imageUrl: String, title: String, name: String) {
        // Set the title and name
        favTitle.text = title
        favName.text = name
        // Load the image using Kingfisher
        if let url = URL(string: imageUrl) {
            favImage.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
        } else {
            favImage.image = UIImage(systemName: "photo") // Placeholder for invalid URLs
        }
    }

    /// Action for the favourite button
    @objc private func faVButtonAction() {
        favouriteButtonTapped?()
    }
}
