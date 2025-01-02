//
//  AppointmentsCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/09/2024.
//

import UIKit

class AppointmentsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ToHour: UILabel!
    @IBOutlet weak var fromHour: UILabel!
    @IBOutlet weak var appointDate: CairoBold!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
