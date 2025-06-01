//
//  ProductsCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 22/10/2024.
//

import UIKit
import Kingfisher

class ProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: CairoLight!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with imageUrl: String, name: String, price: String) {
        if let url = URL(string: imageUrl) {
            productImage.kf.setImage(with: url)
        }
        productName.text = name
        productPrice.text = price.appendingWithSpace(AppLocalizedKeys.EGP.localized)
    }
}
