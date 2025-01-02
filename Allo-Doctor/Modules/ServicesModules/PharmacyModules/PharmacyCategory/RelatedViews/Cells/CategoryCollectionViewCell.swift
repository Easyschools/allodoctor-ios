//
//  CategoryCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 22/10/2024.
//

import UIKit
import Kingfisher

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak private var categoryImage: UIImageView!
    @IBOutlet weak private var categoryName: CairoRegular!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(imageURLString: String, name: String) {
        if let imageURL = URL(string: imageURLString) {
            categoryImage.kf.setImage(
                with: imageURL,
                placeholder: UIImage(named: "placeHolder"),
                options: [
                    .transition(.fade(0.3))
                ]
            )
        } else {
            categoryImage.image = UIImage(named: "placeHolder")
        }
        
        // Set the category name
        categoryName.text = name
    }
}
