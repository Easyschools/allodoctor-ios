//
//  OffersBannersCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 17/12/2024.
//

import UIKit
import Kingfisher

class OffersBannersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var offerProviderTitle: CairoRegular!
    @IBOutlet weak var offerProviderName: CairoBold!
    @IBOutlet weak var offerImage: CircularImageView!
    @IBOutlet weak var offersBannerImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        offersBannerImage.addOverlay(color: .black)
        self.applyDropShadow()
    }

    func configure(providerTitle: String, providerName: String, offerImageUrl: String?, bannerImageUrl: String?) {
        // Assign text values
        offerProviderTitle.text = providerTitle
        offerProviderName.text = providerName

        // Load offer image with placeholder
        if let imageUrl = offerImageUrl, let url = URL(string: imageUrl) {
            offerImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            offerImage.image = UIImage(named: "placeholder")
        }

        // Load banner image with placeholder
        if let bannerUrl = bannerImageUrl, let url = URL(string: bannerUrl) {
            offersBannerImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            offersBannerImage.image = UIImage(named: "placeholder")
        }
    }
}
