//
//  ClinicSearchScreenCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/09/2024.
//

import UIKit

class ClinicSearchScreenCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ClinicTitle: UILabel!
    
    @IBOutlet weak var ClinicName: CairoSemiBold!
    @IBOutlet weak var clinicImage: CircularImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
