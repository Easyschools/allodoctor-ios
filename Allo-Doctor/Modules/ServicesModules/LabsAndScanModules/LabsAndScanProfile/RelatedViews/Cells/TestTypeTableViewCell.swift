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
    @IBOutlet weak var chevronIcon: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!

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

    func setExpanded(_ isExpanded: Bool, animated: Bool = true) {
        let rotation: CGFloat = isExpanded ? .pi : 0

        if animated {
            UIView.animate(withDuration: 0.3) {
                self.chevronIcon.transform = CGAffineTransform(rotationAngle: rotation)
            }

            descriptionLabel.animate(isHidden: !isExpanded, duration: 0.3)
        } else {
            chevronIcon.transform = CGAffineTransform(rotationAngle: rotation)
            descriptionLabel.isHidden = !isExpanded
        }
    }

        @IBAction func buttonTapped(_ sender: UIButton) {
            onButtonTap?()
        }
}
