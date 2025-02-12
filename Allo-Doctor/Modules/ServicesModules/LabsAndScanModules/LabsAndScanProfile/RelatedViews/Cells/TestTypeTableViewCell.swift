//
//  TestTypeTableViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 13/10/2024.
//

import UIKit

class TestTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var testTypeLabel: CairoSemiBold!
    
    @IBOutlet weak var testPrice: CairoSemiBold!
    @IBOutlet weak var addTestTypeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    var onButtonTap: (() -> Void)?
        
        func configure(isAdded: Bool) {
            updateButtonAppearance(isAdded: isAdded)
        }
        
        func updateButtonAppearance(isAdded: Bool) {
            let image = isAdded ? UIImage.plusFilled: UIImage.plus
            addTestTypeButton.setImage(image, for: .normal)
        }
        
        @IBAction func buttonTapped(_ sender: UIButton) {
            onButtonTap?()
        }
}
