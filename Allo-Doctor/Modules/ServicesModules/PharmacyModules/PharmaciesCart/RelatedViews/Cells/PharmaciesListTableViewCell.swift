//
//  PharmaciesListTableViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 14/12/2024.
//

import UIKit
import Kingfisher
class PharmaciesListTableViewCell: UITableViewCell {

    // Outlets for UI components
    @IBOutlet weak var pharmacyImage: CircularImageView!
    @IBOutlet weak var cartQuantity: CairoRegular!
    @IBOutlet weak var pharmacyName: CairoBold!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code, if any
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    /// Setup method to configure the cell
    func setup(pharmacyName: String, quantity: Int, imageURL: String) {
        self.pharmacyName.text = pharmacyName
        self.cartQuantity.text = "\(quantity)".prepend(AppLocalizedKeys.quantity.localized, separator: ":")
        
        // Load the image from the URL (example using Kingfisher or a similar library)
        if let url = URL(string: imageURL) {
            pharmacyImage.kf.setImage(with: url) // Use Kingfisher or any other library for image loading
        } else {
            pharmacyImage.image = UIImage(named: "placeholder") // Placeholder image
        }
    }
}
