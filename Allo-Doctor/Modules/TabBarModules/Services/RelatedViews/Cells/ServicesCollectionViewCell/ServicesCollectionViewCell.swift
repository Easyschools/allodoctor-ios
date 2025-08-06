//
//  ServicesCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 13/09/2024.
//

import UIKit

class ServicesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bookVisitButton: UnderlinedButton!
    
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var serviceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
  
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.applyDropShadow()
    }
}
extension ServicesCollectionViewCell{
    func setupImage(with image:String,chatNowButton:Bool? = nil){
        serviceImage.kf.setImage(with:URL(string: image))
        if chatNowButton == true {
            bookVisitButton.setTitle(AppLocalizedKeys.chatNow.localized, for: .normal)
        }
        else{
            bookVisitButton.setTitle(AppLocalizedKeys.bookVisit.localized, for: .normal)
        }
    }
}
