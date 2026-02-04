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
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var searchView: CustomSearchBar!
    @IBOutlet weak var pharmaciesCollectionViewDynamicHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pharmaciesCollectionView: UICollectionView!
    @IBOutlet weak var backButton: CustomNavigationBackButton!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var bannerPageControl: UIPageControl!
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
        viewModel.getPharmacyOffers()
        bindBannerData()
    }
    override func setupUI() {
        searchView.searchTextfield.placeholder = AppLocalizedKeys.searchForAnyPharmacy.localized
        setupViewControllerUI()
        bindCollectionViewHeight()
        setupCollectionView()
        setupBannerCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let coordinates = UserDefaultsManager.sharedInstance.getCoordinates() {
            viewModel.getPharmacies(lat: coordinates.lat, long: coordinates.long)
        }
        else {
          
        }
        if let location = UserDefaultsManager.sharedInstance.getSavedAreaName(), !location.isEmpty {
            locationButton.setTitle(location, for: .normal)
        } else {
            locationButton.setTitle(AppLocalizedKeys.selectArea.localized, for: .normal)
        }
    }
    @IBAction func changeLocationAction(_ sender: Any) {
        viewModel.showSelectLocationMap()
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
        if let location = UserDefaultsManager.sharedInstance.getSavedAreaName(), !location.isEmpty {
            locationButton.setTitle(location, for: .normal)
        } else {
            locationButton.setTitle(AppLocalizedKeys.selectArea.localized, for: .normal)
        }

    }
    private func setupCollectionView(){
        pharmaciesCollectionView.registerCell(cellClass: PharmacyCollectionViewCell.self)
        pharmaciesCollectionView.delegate = self
        pharmaciesCollectionView.dataSource = self
    }
    private func setupBannerCollectionView() {
        bannerCollectionView.registerCell(cellClass: OffersCollectionViewCell.self)
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.isPagingEnabled = true
        bannerCollectionView.showsHorizontalScrollIndicator = false

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        bannerCollectionView.collectionViewLayout = layout
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
        if collectionView == bannerCollectionView {
            return viewModel.banners?.count ?? 0
        }
        return viewModel.pharmacies?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView {
            let cell = collectionView.dequeue(indexpath: indexPath) as OffersCollectionViewCell
            let imageUrl = viewModel.banners?[indexPath.row].image ?? ""
            cell.configureCellImage(with: imageUrl)
            return cell
        }
       let cell = collectionView.dequeue(indexpath: indexPath) as PharmacyCollectionViewCell
       let pharmacyData = viewModel.pharmacies?[indexPath.row]
        cell.cornerRadius = 10
        cell.applyDropShadow()
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            cell.setupCell(pharmacyName: pharmacyData?.nameAr ?? "", area: pharmacyData?.addressAr ?? "", deliveryFees: pharmacyData?.delivery ?? "",deliveryTime: pharmacyData?.deliveryTime?.appendingWithSpace(AppLocalizedKeys.mintutes.localized) ?? "", logoUrl: pharmacyData?.mainImage, backgroundImageUrl: pharmacyData?.backgroundImage)
        }else{
            cell.setupCell(pharmacyName: pharmacyData?.nameEn ?? "", area: pharmacyData?.addressEn ?? "", deliveryFees: pharmacyData?.delivery ?? "", deliveryTime: pharmacyData?.deliveryTime?.appendingWithSpace(AppLocalizedKeys.mintutes.localized) ?? "", logoUrl: pharmacyData?.mainImage, backgroundImageUrl: pharmacyData?.backgroundImage)}
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == bannerCollectionView {
            guard let banner = viewModel.banners?[safe: indexPath.row],
                  let pharmacyId = banner.bannerableId else { return }
            viewModel.navToPharmacyFromBanner(pharmacyId: pharmacyId)
            return
        }
        guard let pharmacyId = viewModel.pharmacies?[safe: indexPath.row]?.id else { return }
        viewModel.navigationToCategory(pharmacyId: pharmacyId)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == bannerCollectionView {
            return 0
        }
        return 24
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == bannerCollectionView {
            return 0
        }
        return 24
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == bannerCollectionView {
            return .zero
        }
           return UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 16)
       }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionView {
            return collectionView.bounds.size
        }
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
    private func bindBannerData() {
        viewModel.$banners
            .receive(on: DispatchQueue.main)
            .sink { [weak self] banners in
                self?.bannerCollectionView.reloadData()
                self?.bannerPageControl.numberOfPages = banners?.count ?? 0
                self?.viewModel.startBannerAutoScroll()
            }
            .store(in: &cancellables)

        viewModel.$currentBannerIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self = self else { return }
                self.bannerPageControl.currentPage = index
                let indexPath = IndexPath(item: index, section: 0)
                if self.bannerCollectionView.numberOfItems(inSection: 0) > index {
                    self.bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                }
            }
            .store(in: &cancellables)
    }
}
// MARK: - UIScrollViewDelegate for Banner
extension PharmacyHomeViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == bannerCollectionView {
            viewModel.stopBannerAutoScroll()
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == bannerCollectionView {
            viewModel.startBannerAutoScroll()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == bannerCollectionView {
            let visibleIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
            viewModel.updateCurrentBannerIndex(to: visibleIndex)
        }
    }
}

