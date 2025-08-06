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
    var currentProduct: PharmacyCartItem?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
        productImage.image = nil // Reset the image to avoid flickering during reuse
    }
    
    /// Configure the cell with product details
    func configureCell(with product: PharmacyCartItem) {
        // Store reference to current product
        currentProduct = product
        
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
            productName.text = product.medication?.nameAr
        } else {
            productName.text = product.medication?.name
        }
        
        // Use priceAfterDiscount if available, otherwise use normal price
        let priceToDisplay = product.medicationPharmacy?.priceAfterDiscount ?? product.medicationPharmacy?.price
        productPrice.text = priceToDisplay?.appendingWithSpace(AppLocalizedKeys.EGP.localized)
        
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
        
        // Update button state based on availability
        updateIncrementButtonState()
    }
    
    @IBAction func incrementButtonTapped(_ sender: Any) {
        guard let product = currentProduct,
              let currentQuantity = Int(itemQuantityLabel.text ?? "0") else { return }
        
        let newQuantity = currentQuantity + 1
        let availableStock = product.medicationPharmacy?.quantity ?? 0
        
        if newQuantity <= availableStock {
            quantityUpdateCallback?(newQuantity)
            // Update button state after quantity change
            DispatchQueue.main.async {
                self.updateIncrementButtonState()
            }
        } else {
            // Optional: Show alert or provide visual feedback
            print("Cannot exceed available stock of \(availableStock)")
            // You could show an alert here or provide visual feedback
        }
    }
    
    @IBAction func decrementButtonTapped(_ sender: Any) {
        if let currentQuantity = Int(itemQuantityLabel.text ?? "0"),
           currentQuantity > 1 {
            let newQuantity = currentQuantity - 1
            quantityUpdateCallback?(newQuantity)
        }
    }
    
    // MARK: - Helper Methods
    
    /// Update increment button state based on current quantity and available stock
    func updateIncrementButtonState() {
        guard let product = currentProduct else { return }
        
        let currentQuantity = Int(itemQuantityLabel.text ?? "0") ?? 0
        let availableStock = product.medicationPharmacy?.quantity ?? 0
        
        incrementButton.isEnabled = currentQuantity < availableStock
        incrementButton.alpha = incrementButton.isEnabled ? 1.0 : 0.5
    }
}
