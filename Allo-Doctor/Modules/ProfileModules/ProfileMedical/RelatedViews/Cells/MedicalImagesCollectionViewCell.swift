//
//  MedicalImagesCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/06/2025.
//

import UIKit
import Kingfisher
import Combine

class MedicalImagesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var medicalImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    private let deleteSubject = PassthroughSubject<Int, Never>()
    var deletePublisher: AnyPublisher<Int, Never> {
        return deleteSubject.eraseToAnyPublisher()
    }
    
    var cancellables = Set<AnyCancellable>()
    private var imageId: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Clear cancellables when cell is reused
        cancellables.removeAll()
        medicalImage.image = nil
        imageId = nil
    }
    

    
    @IBAction func deleteButton(_ sender: Any) {
        guard let imageId = imageId else { return }
        deleteSubject.send(imageId)
    }
    
    func configure(with image: Image) {
        self.imageId = image.id
        
        // Load image using Kingfisher
        if let imageUrlString = image.image, let imageUrl = URL(string: imageUrlString) {
            medicalImage.kf.setImage(
                with: imageUrl,
                placeholder: UIImage(named: "placeholder_image"), // Add a placeholder image
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        } else {
            medicalImage.image = UIImage(named: "placeholder_image")
        }
    }
}
