//
//  LabsSearchScreenViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/09/2024.
//

import UIKit
import Kingfisher
enum screenType{
    case labs
    case scans
}
class LabsSearchScreenViewController: BaseViewController<LabsSearchScreenViewModel> {
    @IBOutlet weak var selectCityDropDownList: CustomDropDownList!
    @IBOutlet weak var screenTypeLabel: CairoSemiBold!
    @IBOutlet weak var upperView: CustomCornerRaduis!
    @IBOutlet weak var searchBar: SearchView!
    
    @IBOutlet weak var navButton: CustomNavigationBackButton!
    @IBOutlet weak var labsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
       
    }
    
    override func setupUI(){
        setupCollectionView()
        setupViewAccordingToScreenType()
    }
    override func bindViewModel() {
        viewModel.fetchLabsAndScans()
        bindCollectionView()
    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 30)
    }


    @IBAction func navBack(_ sender: Any) {
        viewModel.coordinator?.navigateBack()
    }
    

}
extension LabsSearchScreenViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setupCollectionView() {
        labsCollectionView.delegate = self
        labsCollectionView.dataSource = self
        labsCollectionView.registerCell(cellClass: LabsCollectionViewCell.self)
        
  
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.labs?.info_service.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabsCollectionViewCell", for: indexPath) as? LabsCollectionViewCell else {
            fatalError("Unable to dequeue DoctorSearchCollectionViewCell")
        }
       
        let data = viewModel.labs?.info_service[indexPath.row]
        cell.labsImage.kf.setImage(with:URL(string: data?.image ?? ""))
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width*0.48, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.navToLabsAnsScanProfile(url:viewModel.labs?.info_service[indexPath.row].image ?? "")
    }
}
extension LabsSearchScreenViewController{
    private func bindCollectionView() {
        viewModel.$labs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] labs in
                self?.labsCollectionView.reloadData()
            }.store(in: &cancellables)
    }
}
extension LabsSearchScreenViewController{
   func setupViewAccordingToScreenType() {
       selectCityDropDownList.label.text = "Select City"
       if viewModel.screenType == labAndScan.labs.rawValue{
           navButton.setTitle("Book Labs")
           screenTypeLabel.text = "Feature lab center"
           searchBar.searchTextfield.placeholder = "Search for Lab center"
       }
       else {
           navButton.setTitle("Book Scan")
           screenTypeLabel.text = "Feature Scan center"
           searchBar.searchTextfield.placeholder = "Search for Scan center"
       }
   }
}

