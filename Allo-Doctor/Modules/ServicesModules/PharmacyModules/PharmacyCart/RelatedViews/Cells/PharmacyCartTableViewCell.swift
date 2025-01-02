//
//  PharmacyCartTableViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 31/10/2024.
//
import UIKit
class PharmacyCartTableViewCell: UITableViewCell {
    @IBOutlet weak var itemQuantityLabel: UILabel!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    
    var cancellables = Set<AnyCancellable>()
    var quantityUpdateCallback: ((Int) -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
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
