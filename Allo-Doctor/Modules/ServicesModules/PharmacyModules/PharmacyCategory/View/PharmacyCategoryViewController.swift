//
//  PharmacyCategoryViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 22/10/2024.
//

import UIKit
class PharmacyCategoryViewController: BaseViewController<PharmacyCategoryViewModel> {
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var backButton: CustomNavigationBackButton!
    @IBOutlet weak var uploadPrescriptionView: UIView!
    @IBOutlet weak var searchView: CustomSearchBar!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionViewDynamicHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    @IBAction func navToPharmacyCart(_ sender: Any) {
        viewModel.navToPharmacyCart()
    }
    @IBAction func showUploadPrescriptionAction(_ sender: Any) {
        viewModel.showUploadPrescription()
    }
    @IBAction func heartButtonAction(_ sender: Any) {
        if heartButton.tag == 0 {
                  // Switch to filled heart
            heartButton.setImage(UIImage.heartFilled, for: .normal)
                  heartButton.tag = 1
              } else {
                  // Switch back to unfilled heart
                  heartButton.setImage(UIImage.heartBlue, for: .normal)
                  heartButton.tag = 0
              }
        viewModel.addToFav()
    }
    override func bindViewModel() {
        bindPhamracyData()
        viewModel.getPharmacy()
        bindSearchBarButton()
        viewModel.fetchPharmacyFavourite()
    }
    override func setupUI() {
        setupCollectionView()
        bindCollectionViewHeight()
        setupViewControllerUI()
    }
}
extension PharmacyCategoryViewController{
    private func setupViewControllerUI() {
        searchView.searchTextfield.placeholder = AppLocalizedKeys.searchForPharmacyOrProduct.localized
        backButton.tintColor = .black
        backButton.setTitleColor(.black, for: .normal)
        uploadPrescriptionView.applyDropShadow()
    }
    private func setupCollectionView(){
        categoryCollectionView.registerCell(cellClass: CategoryCollectionViewCell.self)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    private func bindCollectionViewHeight() {
        categoryCollectionView.publisher(for: \.contentSize)
            .sink { [weak self] newSize in
                guard let self = self else { return }
                if self.categoryCollectionViewDynamicHeightConstraint.constant != newSize.height {
                    self.categoryCollectionViewDynamicHeightConstraint.constant = newSize.height
                    self.view.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
        
    }
}
extension PharmacyCategoryViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pharmacy?.categories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexpath: indexPath) as CategoryCollectionViewCell
        let data = viewModel.pharmacy?.categories[indexPath.row]
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            cell.setupCell(imageURLString:data?.mainImage ?? "" , name: data?.nameAr ?? "")

        }
        else {
            cell.setupCell(imageURLString:data?.mainImage ?? "" , name: data?.nameEn ?? "")}
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width*0.3, height: 120)
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pharmacyData = viewModel.pharmacy
        viewModel.navigateToProducts(pharmacyId: pharmacyData?.id ?? 0, categoryId: pharmacyData?.categories[indexPath.row].id ?? 0)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}
// MARK: ViewModel Binding phamrmacies Data
extension PharmacyCategoryViewController{
    private func bindPhamracyData(){
        viewModel.$pharmacy
            .receive(on: DispatchQueue.main)
            .sink { pharmacies in
                self.categoryCollectionView.reloadData()
            }.store(in: &cancellables)
        viewModel.$favData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self = self else { return }
                
                // Safely check if `data` is non-nil and contains at least one element
                if let firstItem = data?.first, firstItem.id != nil {
                    self.heartButton.setImage(.heartFilled, for: .normal)
                } else {
                    // Optional: Set the button to an unselected state if no valid data is found
                    self.heartButton.setImage(.heartBlue, for: .normal)
                }
            }
            .store(in: &cancellables)
    }
    
}

extension PharmacyCategoryViewController{
 
    private func bindSearchBarButton() {
        searchView.navButtonTapped
            .sink { [weak self] in
                self?.viewModel.navToProductsSerarh()
            }
            .store(in: &cancellables)
    }
}

