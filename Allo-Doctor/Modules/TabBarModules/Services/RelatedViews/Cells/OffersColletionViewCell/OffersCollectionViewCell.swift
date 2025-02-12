//
//  OffersCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 13/09/2024.
//

import UIKit
import Kingfisher

class OffersCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var offersImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageView()
    }
    
    private func setupImageView() {
        offersImage.contentMode = .scaleAspectFill
        offersImage.clipsToBounds = true
    }
    
    func configureCellImage(with imageUrl: String) {
        // Use Kingfisher to load the image from the URL
        offersImage.kf.indicatorType = .activity // Show loading indicator
        offersImage.kf.setImage(
            with: URL(string: imageUrl),
            placeholder: UIImage(named: "placeholder"), // Optional placeholder image
            options: [
                .transition(.fade(0.3)), // Fade transition for smooth loading
                .cacheOriginalImage // Cache the image for reuse
            ],
            completionHandler: { result in
                switch result {
                case .success(let value):
                    print("Image loaded successfully: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
        )
    }
}
