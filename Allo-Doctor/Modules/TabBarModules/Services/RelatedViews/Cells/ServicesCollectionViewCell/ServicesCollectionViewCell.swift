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

}
extension ServicesCollectionViewCell{
    func setupImage(with image:String){
        serviceImage.loadImage(from: image)
    }
}
