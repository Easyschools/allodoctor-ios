//
//  PharmacyGlobalSearchViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 27/11/2024.
//

import UIKit

class PharmacyGlobalSearchViewController: BaseViewController<PharmacyGlobalSearchViewModel> {

    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var pharmaciesStackView: UIStackView!
    @IBOutlet weak var pharmacyCollectionViewDynamicHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButton: CustomNavigationBackButton!
    @IBOutlet weak var pharmaciesColletionView: UICollectionView!

    // MARK: - Properties

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    // MARK: - Override Functions
    override func bindViewModel() {
        bindViewModelData()
        setupSearchBar()
    }

    override func setupUI() {
        setupViewControllerUI()
//        bindCollectionViewHeight()
        setupCollectionView()
    }
    @IBAction func navBack(_ sender: Any) {
        viewModel.navigationBack()
    }
    
    @IBAction func seeMorePharmaciesAction(_ sender: Any) {
        // Navigation to "See More Pharmacies" Screen
//        viewModel.navigateToSeeMorePharmacies()
    }
}

// MARK: - Setup UI and Collection View
extension PharmacyGlobalSearchViewController {
    private func setupViewControllerUI() {
        backButton.tintColor = .black
        backButton.setTitleColor(.black, for: .normal)
        pharmaciesStackView.isHidden = false
    }

    private func setupCollectionView() {
        pharmaciesColletionView.registerCell(cellClass: PharmacyGlobalSearchCollectionViewCell.self)
        pharmaciesColletionView.delegate = self
        pharmaciesColletionView.dataSource = self
    }

//    private func bindCollectionViewHeight() {
//        pharmaciesColletionView.publisher(for: \.contentSize)
//            .sink { [weak self] newSize in
//                guard let self = self else { return }
//                DispatchQueue.main.async {
//                    if self.pharmacyCollectionViewDynamicHeightConstraint.constant != newSize.height {
//                        self.pharmacyCollectionViewDynamicHeightConstraint.constant = newSize.height
//                        UIView.animate(withDuration: 0.3) {
//                            self.view.layoutIfNeeded()
//                        }
//                    }
//                }
//            }
//            .store(in: &cancellables)
//    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, and Layout
extension PharmacyGlobalSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pharmacies?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexpath: indexPath) as PharmacyGlobalSearchCollectionViewCell

        if let pharmacy = viewModel.pharmacies?[indexPath.row] {
            cell.cornerRadius = 10
            
            if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
                cell.setupCell(pharmacyName: viewModel.pharmacies?[indexPath.row].nameAr ?? "", logoUrl: viewModel.pharmacies?[indexPath.row].mainImage ?? "")
            }
            else{
                cell.setupCell(pharmacyName: viewModel.pharmacies?[indexPath.row].nameEn ?? "", logoUrl: viewModel.pharmacies?[indexPath.row].mainImage ?? "")}
//            cell.applyDropShadow()
//            cell.setupCell(
//                pharmacyName: pharmacy.nameEn ?? "",
//                area: pharmacy.address ?? "",
//                deliveryFees: pharmacy.delivery?.description ?? "",
//                deliveryTime: pharmacy.pickup?.description ?? "",
//                logoUrl: pharmacy.mainImage,
//                backgroundImageUrl: pharmacy.backgroundImage
//            )
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let pharmacyId = viewModel.pharmacies?[indexPath.row].id {
            viewModel.navigationToCategory(pharmacyId: pharmacyId)
        }
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 24
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 24
//    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 80)
    }
}

// MARK: - ViewModel Binding
extension PharmacyGlobalSearchViewController {
    private func setupSearchBar() {
        searchView.searchTextfield.placeholder = AppLocalizedKeys.searchForAnyPharmacy.localized
        
        // Bind the text field to the view model
        searchView.searchTextfield.textPublisher()
            .sink { [weak self] searchText in
                self?.viewModel.searchText = searchText
            }
            .store(in: &cancellables)
    }

    private func bindViewModelData() {
        viewModel.$pharmacies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pharmacies in
                let isEmpty = pharmacies?.isEmpty ?? true
                self?.pharmaciesStackView.isHidden = isEmpty
                self?.pharmaciesColletionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                // Handle loading state if needed
                if isLoading {
                    // Show loading indicator
                } else {
                    // Hide loading indicator
                }
            }
            .store(in: &cancellables)
    }
}
