//
//  OneDayCareServiceCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 26/12/2024.
//

import UIKit

class OneDayCareServiceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceDesc: UITextView!
    @IBOutlet weak var servicePrice: CairoRegular!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure the cell with data
    func configureCell(serviceName: String, serviceDesc: String, servicePrice: String) {
        self.serviceName.text = serviceName
        self.serviceDesc.text = serviceDesc
        self.servicePrice.text = servicePrice.appendingWithSpace(AppLocalizedKeys.EGP.localized)
    }
}
