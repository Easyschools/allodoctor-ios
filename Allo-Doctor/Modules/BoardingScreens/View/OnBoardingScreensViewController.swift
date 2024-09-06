//
//  BoardingScreensViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 04/09/2024.
//

import UIKit

class OnBoardingScreensViewController: UIViewController{
    // MARK: - Outlets
    @IBOutlet private weak var getStarted: CustomButton!
    @IBOutlet private weak var serviceLabel: UILabel!
    @IBOutlet private weak var serviceDescription: UILabel!
    @IBOutlet private weak var boardingImages: UICollectionView!
    // MARK: - Properties
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }


  

}
// MARK: - Extention for setup CollectionView
extension OnBoardingScreensViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}
