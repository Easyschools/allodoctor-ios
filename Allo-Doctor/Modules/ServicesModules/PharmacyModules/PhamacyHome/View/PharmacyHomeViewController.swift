//
//  PharmacyHomeViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 14/10/2024.
//

import UIKit
import GoogleMaps
class PharmacyHomeViewController: BaseViewController<PharmacyHomeViewModel> {
    // MARK: - IBOutlets
    @IBOutlet weak var searchView: CustomSearchBar!
    @IBOutlet weak var pharmaciesCollectionViewDynamicHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pharmaciesCollectionView: UICollectionView!
    @IBOutlet weak var backButton: CustomNavigationBackButton!
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    // MARK: - Overided FunctionFrom baseViewController
    override func bindViewModel() {
        bindPhamraciesData()
        viewModel.getPharmacies()
        bindSearchBarButton()
    }
    override func setupUI() {
        searchView.searchTextfield.placeholder = AppLocalizedKeys.searchForPharmacyOrProduct.localized
        setupViewControllerUI()
        bindCollectionViewHeight()
        setupCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let coordinates = UserDefaultsManager.sharedInstance.getCoordinates() {
            viewModel.getPharmacies(lat: coordinates.lat, long: coordinates.long)
        }
        else {
          
        }

    }
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navigationBack()
    }
    @IBAction func goToBasketAction(_ sender: Any) {
        viewModel.navToshowPharmaciesCartViewController()
    }
}
extension PharmacyHomeViewController{
    private func setupViewControllerUI() {
        backButton.tintColor = .black
        backButton.setTitleColor(.black, for: .normal)
        backButton.updateForLanguageChange()
        backButton.setTitle("Pharmacies".localized)
    }
    private func setupCollectionView(){
        pharmaciesCollectionView.registerCell(cellClass: PharmacyCollectionViewCell.self)
        pharmaciesCollectionView.delegate = self
        pharmaciesCollectionView.dataSource = self
    }
    private func bindCollectionViewHeight() {
        pharmaciesCollectionView.publisher(for: \.contentSize)
            .sink { [weak self] newSize in
                guard let self = self else { return }
                if self.pharmaciesCollectionViewDynamicHeightConstraint.constant != newSize.height {
                    self.pharmaciesCollectionViewDynamicHeightConstraint.constant = newSize.height
                    self.view.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
        
    }
}
extension PharmacyHomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pharmacies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeue(indexpath: indexPath) as PharmacyCollectionViewCell
       let pharmacyData = viewModel.pharmacies?[indexPath.row]
        cell.cornerRadius = 10
        cell.applyDropShadow()
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            cell.setupCell(pharmacyName: pharmacyData?.nameAr ?? "", area: pharmacyData?.addressAr ?? "", deliveryFees: pharmacyData?.delivery.toString() ?? "",deliveryTime: pharmacyData?.deliveryTime?.appendingWithSpace(AppLocalizedKeys.mintutes.localized) ?? "", logoUrl: pharmacyData?.mainImage, backgroundImageUrl: pharmacyData?.backgroundImage)
        }else{
            cell.setupCell(pharmacyName: pharmacyData?.nameEn ?? "", area: pharmacyData?.addressEn ?? "", deliveryFees: pharmacyData?.delivery.toString() ?? "", deliveryTime: pharmacyData?.deliveryTime?.appendingWithSpace(AppLocalizedKeys.mintutes.localized) ?? "", logoUrl: pharmacyData?.mainImage, backgroundImageUrl: pharmacyData?.backgroundImage)}
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pharmacyId = viewModel.pharmacies?[safe: indexPath.row]?.id else { return }
//        viewModel.navToDoctorProfile(doctorID: String(doctor.id))
        viewModel.navigationToCategory(pharmacyId: pharmacyId)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 16)
       }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.bounds.width - 32
            return CGSize(width: width, height: 140)
        }
     
}
// MARK: ViewModel Binding phamrmacies Data
extension PharmacyHomeViewController{
   private func bindPhamraciesData(){
        viewModel.$pharmacies
            .receive(on: DispatchQueue.main)
            .sink { pharmacies in
                self.pharmaciesCollectionView.reloadData()
            }.store(in: &cancellables)
    }
    func showMapView(){
        guard let coordinates = UserDefaultsManager.sharedInstance.getCoordinates() else {
            viewModel.coordinator?.showMapView(screenType: .pharmacyHome)
            return
        }
 }
    private func bindSearchBarButton() {
        searchView.navButtonTapped
            .sink { [weak self] in
                self?.viewModel.navToSearchScreen()
            }
            .store(in: &cancellables)
    }
}

