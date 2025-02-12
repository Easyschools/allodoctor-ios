//
//  PharmacyGlobalSearchViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 27/11/2024.
//

import UIKit


class PharmacyGlobalSearchViewController: BaseViewController<PharmacyGlobalSearchViewModel> {
    @IBOutlet weak var seeMorePharmacies: UIButton!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var medicationsStackView: UIStackView!
    @IBOutlet weak var pharmaciesStackView: UIStackView!
    @IBOutlet weak var pharmacyCollectionViewDynamicHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButton: CustomNavigationBackButton!
    @IBOutlet weak var seeMoreMedications: UIButton!
    @IBOutlet weak var medicationCollectionView: UICollectionView!
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
        bindCollectionViewHeight()
        setupCollectionView()
    }

    @IBAction func seeMorePharmaciesAction(_ sender: Any) {
        // Navigation to "See More Pharmacies" Screen
    }

    @IBAction func seeMoreMedicationsAction(_ sender: Any) {
        // Navigation to "See More Medications" Screen
    }
}

// MARK: - Setup UI and Collection View
extension PharmacyGlobalSearchViewController {
    private func setupViewControllerUI() {
        backButton.tintColor = .black
        backButton.setTitleColor(.black, for: .normal)
        pharmaciesStackView.isHidden = true
        medicationsStackView.isHidden = true
    }

    private func setupCollectionView() {
        pharmaciesColletionView.registerCell(cellClass: MedicationGlobalSearchCollectionViewCell.self)
        pharmaciesColletionView.delegate = self
        pharmaciesColletionView.dataSource = self

        medicationCollectionView.registerCell(cellClass: MedicationGlobalSearchCollectionViewCell.self)
        medicationCollectionView.delegate = self
        medicationCollectionView.dataSource = self
    }

    private func bindCollectionViewHeight() {
        pharmaciesColletionView.publisher(for: \.contentSize)
            .sink { [weak self] newSize in
                guard let self = self else { return }
                if self.pharmacyCollectionViewDynamicHeightConstraint.constant != newSize.height {
                    self.pharmacyCollectionViewDynamicHeightConstraint.constant = newSize.height
                    self.view.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, and Layout
extension PharmacyGlobalSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == pharmaciesColletionView {
            return viewModel.pharmacies?.count ?? 0
        } else {
            return viewModel.products?.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexpath: indexPath) as MedicationGlobalSearchCollectionViewCell

//        if collectionView == pharmaciesColletionView, let pharmacy = viewModel.pharmacies?[indexPath.row] {
//            cell.cornerRadius = 10
//            cell.applyDropShadow()
//            cell.setupCell(pharmacyName: pharmacy.nameEn ?? "",
//                           area: pharmacy.address ?? "",
//                           deliveryFees: pharmacy.delivery?.description ?? "",
//                           deliveryTime: pharmacy.pickup?.description ?? "",
//                           logoUrl: pharmacy.mainImage,
//                           backgroundImageUrl: pharmacy.backgroundImage)
//        } else if collectionView == medicationCollectionView, let product = viewModel.products?[indexPath.row] {
//            cell.cornerRadius = 10
//            cell.applyDropShadow()
//            cell.setupCell(productName: product.name, price: product.price, imageUrl: product.imageUrl)
//        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == pharmaciesColletionView, let pharmacyId = viewModel.pharmacies?[indexPath.row].id {
            viewModel.navigationToCategory(pharmacyId: pharmacyId)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32
        return CGSize(width: width, height: 80)
    }
}

// MARK: - ViewModel Binding
extension PharmacyGlobalSearchViewController {
    private func setupSearchBar() {
        searchView.searchTextfield.placeholder = "Search for Product or Pharmacy"
        searchView.searchTextfield.textPublisher()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                print("Text in Search Field: \(searchText)")
                self?.viewModel.searchText = searchText
                self?.viewModel.setupSearchSubscription()
            }
            .store(in: &cancellables)
    }

    private func bindViewModelData() {
        viewModel.$pharmacies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pharmacies in
                self?.pharmaciesStackView.isHidden = pharmacies?.isEmpty ?? true
                self?.pharmaciesColletionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] products in
                self?.medicationsStackView.isHidden = products?.isEmpty ?? true
                self?.medicationCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}
