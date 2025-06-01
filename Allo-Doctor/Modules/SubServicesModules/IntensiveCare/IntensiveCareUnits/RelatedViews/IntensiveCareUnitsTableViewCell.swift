//
//  IntensiveCareUnitsTableViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 20/12/2024.
//

import UIKit

class IntensiveCareUnitsTableViewCell: UITableViewCell {

    @IBOutlet weak var radioButton: UIImageView!
    @IBOutlet weak var unitLabel: CairoMeduim!
    // Image names for selected/unselected state
      private let selectedImage = UIImage(systemName: "circle.inset.filled")
   
      private let unselectedImage = UIImage(systemName: "circle")
      
      override func awakeFromNib() {
          super.awakeFromNib()
         
          radioButton.image = unselectedImage
      }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.applyDropShadow()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
    }
      func configure(with unitName: String, isSelected: Bool) {
          unitLabel.text = unitName
          radioButton.image = isSelected ? selectedImage : unselectedImage
          selectedImage?.withTintColor(.appColor)
      }
}
