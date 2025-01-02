//
//  PharmacyCategoryViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 22/10/2024.
//

import UIKit
class PharmacyCategoryViewController: BaseViewController<PharmacyCategoryViewModel> {
    @IBOutlet weak var backButton: CustomNavigationBackButton!
    @IBOutlet weak var uploadPrescriptionView: UIView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionViewDynamicHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    override func bindViewModel() {
        bindPhamracyData()
        viewModel.getPharmacy()
    }
    override func setupUI() {
        setupCollectionView()
        bindCollectionViewHeight()
        setupViewControllerUI()
    }
}
extension PharmacyCategoryViewController{
    private func setupViewControllerUI() {
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
        cell.setupCell(imageURLString:data?.mainImage ?? "" , name: data?.nameEn ?? "")
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
    }
}

extension PharmacyCategoryViewController{
    func didDismissModal() {
         
    }
}

