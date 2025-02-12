//
//  DoctorSortByViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 09/12/2024.
//

import UIKit
enum SortOption:String {
    case priceHighToLow = "price_high_to_low"
    case priceLowToHigh = "price_low_to_high"
    case topRated = "rating_high_to_low"
}
class DoctorSortByViewController: UIViewController {
    // Subject to emit selected sort options
    let sortOptionSelected = PassthroughSubject<SortOption, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func priceHighToLow(_ sender: Any) {
        sortOptionSelected.send(.priceHighToLow)
        dismiss(animated: true)
    }
    
    @IBAction func priceLowToHigh(_ sender: Any) {
        sortOptionSelected.send(.priceLowToHigh)
        dismiss(animated: true)
    }
    
    @IBAction func topRatedAction(_ sender: Any) {
        sortOptionSelected.send(.topRated)
        dismiss(animated: true)
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true)
    }
}

