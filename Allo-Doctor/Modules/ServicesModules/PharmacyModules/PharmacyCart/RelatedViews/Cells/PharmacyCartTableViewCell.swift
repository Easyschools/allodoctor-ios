//
//  PharmacyCartTableViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 31/10/2024.
//
import UIKit
import Kingfisher
import Combine

class PharmacyCartTableViewCell: UITableViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    
    var cancellables = Set<AnyCancellable>()
    var quantityUpdateCallback: ((Int) -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
        productImage.image = nil // Reset the image to avoid flickering during reuse
    }
    
    /// Configure the cell with product details
    func configureCell(with product: PharmacyCartItem) {
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
            productName.text = product.medication?.nameAr}
       else {
            productName.text = product.medication?.name}
        productPrice.text = product.medicationPharmacy?.price?.appendingWithSpace(AppLocalizedKeys.EGP.localized)
        itemQuantityLabel.text = "\(String(describing: product.quantity))"
        
        if let imageUrl = URL(string: product.medication?.image ?? "") {
            productImage.kf.setImage(
                with: imageUrl,
                placeholder: UIImage(named: "placeholder"), // Placeholder image name
                options: [
                    .transition(.fade(0.3)), // Smooth transition for loading
                ]
            )
        } else {
            productImage.image = UIImage(named: "placeholder") // Fallback placeholder
        }
    }
    
    @IBAction func incrementButtonTapped(_ sender: Any) {
        if let currentQuantity = Int(itemQuantityLabel.text ?? "0") {
            let newQuantity = currentQuantity + 1
            quantityUpdateCallback?(newQuantity)
        }
    }
    
    @IBAction func decrementButtonTapped(_ sender: Any) {
        if let currentQuantity = Int(itemQuantityLabel.text ?? "0"),
           currentQuantity > 1 {
            let newQuantity = currentQuantity - 1
            quantityUpdateCallback?(newQuantity)
        }
    }
}
