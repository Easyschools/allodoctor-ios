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
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var bannerPageControl: UIPageControl!
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
        viewModel.getPharmacyOffers()
        bindBannerData()
    }
    override func setupUI() {
        setupCollectionView()
        bindCollectionViewHeight()
        setupViewControllerUI()
        setupBannerCollectionView()
    }
}
extension PharmacyCategoryViewController{
    private func setupViewControllerUI() {
        searchView.searchTextfield.placeholder = AppLocalizedKeys.searchForAnyProduct.localized
        backButton.tintColor = .black
        backButton.setTitleColor(.black, for: .normal)
        uploadPrescriptionView.applyDropShadow()
    }
    private func setupCollectionView(){
        categoryCollectionView.registerCell(cellClass: CategoryCollectionViewCell.self)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
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
        if collectionView == bannerCollectionView {
            return viewModel.banners?.count ?? 0
        }
        return viewModel.pharmacy?.categories.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView {
            let cell = collectionView.dequeue(indexpath: indexPath) as OffersCollectionViewCell
            let imageUrl = viewModel.banners?[indexPath.row].image ?? ""
            cell.configureCellImage(with: imageUrl)
            return cell
        }
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
        if collectionView == bannerCollectionView {
            return collectionView.bounds.size
        }
        return CGSize(width: collectionView.width*0.3, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == bannerCollectionView {
            guard let banner = viewModel.banners?[safe: indexPath.row],
                  let pharmacyId = banner.bannerableId else { return }
            viewModel.navToPharmacyFromBanner(pharmacyId: pharmacyId)
            return
        }
        let pharmacyData = viewModel.pharmacy
        viewModel.navigateToProducts(pharmacyId: pharmacyData?.id ?? 0, categoryId: pharmacyData?.categories[indexPath.row].id ?? 0)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == bannerCollectionView {
            return 0
        }
        return 6
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == bannerCollectionView {
            return 0
        }
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
extension PharmacyCategoryViewController {
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

