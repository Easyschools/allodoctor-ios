//
//  ProductsCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 22/10/2024.
//

import UIKit
import Kingfisher

class ProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var priceAfterDisscount: CairoLight!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: CairoLight!

    override func awakeFromNib() {
        priceAfterDisscount.isHidden = true
        super.awakeFromNib()
    }
    
    func setup(with imageUrl: String, name: String, price: String, priceAfterDiscount: String?) {
        // Set image
        if let url = URL(string: imageUrl) {
            productImage.kf.setImage(with: url)
        }
        
        // Set name
        productName.text = name
        
        // Check if there's a discounted price
        if let discounted = priceAfterDiscount, !discounted.isEmpty {
            // Show discounted price
            priceAfterDisscount.isHidden = false
            priceAfterDisscount.text = discounted.withoutDecimals.appendingWithSpace(AppLocalizedKeys.EGP.localized)

            // Apply strikethrough to original price
            let attributedString = NSAttributedString(
                string: price.withoutDecimals.appendingWithSpace(AppLocalizedKeys.EGP.localized),
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            productPrice.tintColor = .black
            productPrice.attributedText = attributedString
        } else {
            // No discount: hide discounted label and show price normally
            priceAfterDisscount.isHidden = true
            productPrice.attributedText = nil
            productPrice.text = price.withoutDecimals.appendingWithSpace(AppLocalizedKeys.EGP.localized)
        }
    }

}
