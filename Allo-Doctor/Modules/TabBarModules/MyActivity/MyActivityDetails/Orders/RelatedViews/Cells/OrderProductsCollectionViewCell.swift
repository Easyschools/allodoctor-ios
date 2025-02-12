//
//  OrderProductsCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/01/2025.
//

import UIKit
import Kingfisher

class OrderProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /// Configure cell with data and load image using Kingfisher
    func configureCell(name: String, price: String, quantity: String, imageUrl: String) {
        productName.text = name
        productPrice.text = price.appendingWithSpace(AppLocalizedKeys.EGP.localized)
        productQuantity.text = quantity
        
        // Load image with Kingfisher
        if let url = URL(string: imageUrl) {
            productImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: [.transition(.fade(0.2))])
        } else {
            productImage.image = UIImage(named: "placeholder") 
        }
    }
}
