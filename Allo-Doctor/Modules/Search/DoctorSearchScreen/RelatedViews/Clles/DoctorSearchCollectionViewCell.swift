//
//  DoctorSearchCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/09/2024.
//

import UIKit

class DoctorSearchCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var doctorName: CairoSemiBold!
    
    @IBOutlet weak var avalibailtyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var waitingTime: CairoSemiBold!
    @IBOutlet weak var feesLabel: CairoSemiBold!
    @IBOutlet weak var AdressLabel: CairoSemiBold!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var customAdressLabel: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

}
extension DoctorSearchCollectionViewCell{
    func setupCell(){
       
    }
}
