//
//  DoctorSearchCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/09/2024.
//

import UIKit

class DoctorSearchCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var doctorName: CairoBold!
    
    @IBOutlet weak var avalibailtyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var waitingTime: CairoBold!
    @IBOutlet weak var feesLabel: CairoBold!
    @IBOutlet weak var AdressLabel: CairoBold!
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
