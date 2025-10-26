//
//  HospitalSelectionViewController.swift
//  Allo-Doctor
//
//  Created for Hospital-First Flow Implementation
//

import UIKit
import Combine
import FittedSheets

class HospitalSelectionViewController: BaseViewController<HospitalSelectionViewModel> {

    // MARK: - IBOutlets
    // NOTE: These need to be connected in the XIB file
    @IBOutlet weak private var upperView: UIView!
    @IBOutlet weak private var searchBar: SearchView!
    @IBOutlet weak private var hospitalsTableView: UITableView!
    @IBOutlet weak private var noResultsStackView: UIStackView!
    @IBOutlet weak private var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var navBackButton: CustomNavigationBackButton!
    @IBOutlet weak private var filterButton: UIButton!
    @IBOutlet weak private var sortButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        setupNavigationBar()
        setupSearchBar()
        setupTableView()
        setupButtons()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upperView?.roundCorners(
            corners: [.bottomLeft, .bottomRight],
            radius: Dimensions.upperViewBorderRaduis.rawValue
        )
    }

    override func bindViewModel() {
        super.bindViewModel()
        bindHospitalsTableView()
        bindLoadingState()
        bindErrorState()

        // Initial fetch
        viewModel.fetchHospitals()
        viewModel.fetchDistricts()
        viewModel.fetchSpecialties()
    }

    // MARK: - Setup Methods
    private func setupNavigationBar() {
        navBackButton?.setTitle(NSLocalizedString("Hospitals", comment: ""))
    }

    private func setupSearchBar() {
        searchBar?.placeholder = NSLocalizedString("Search hospitals...", comment: "")
        searchBar?.onTextChanged = { [weak self] text in
            self?.viewModel.searchText = text
        }
    }

    private func setupTableView() {
        hospitalsTableView?.delegate = self
        hospitalsTableView?.dataSource = self
        hospitalsTableView?.registerCell(cellClass: HospitalSelectionTableViewCell.self)
        hospitalsTableView?.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 12, right: 0)
        hospitalsTableView?.separatorStyle = .none
        hospitalsTableView?.rowHeight = UITableView.automaticDimension
        hospitalsTableView?.estimatedRowHeight = 120
    }

    private func setupButtons() {
        filterButton?.setTitle(NSLocalizedString("Filter", comment: ""), for: .normal)
        sortButton?.setTitle(NSLocalizedString("Sort", comment: ""), for: .normal)
    }

    // MARK: - Binding Methods
    private func bindHospitalsTableView() {
        viewModel.$filteredHospitals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hospitals in
                self?.updateUIForResults(isEmpty: hospitals.isEmpty)
                self?.hospitalsTableView?.reloadData()
            }
            .store(in: &cancellables)
    }

    private func bindLoadingState() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator?.startAnimating()
                    self?.hospitalsTableView?.isHidden = true
                } else {
                    self?.loadingIndicator?.stopAnimating()
                    self?.hospitalsTableView?.isHidden = false
                }
            }
            .store(in: &cancellables)
    }

    private func bindErrorState() {
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)
    }

    // MARK: - Helper Methods
    private func updateUIForResults(isEmpty: Bool) {
        noResultsStackView?.isHidden = !isEmpty
        hospitalsTableView?.isHidden = isEmpty
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("Error", comment: ""),
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        present(alert, animated: true)
    }

    // MARK: - IBActions
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.coordinator?.navigateBack()
    }

    @IBAction func filterAction(_ sender: Any) {
        viewModel.presentFilterView(from: self)
    }

    @IBAction func sortAction(_ sender: Any) {
        viewModel.presentSortView(from: self)
    }
}

// MARK: - UITableViewDelegate & DataSource
extension HospitalSelectionViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredHospitals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "HospitalSelectionTableViewCell",
            for: indexPath
        ) as? HospitalSelectionTableViewCell else {
            return UITableViewCell()
        }

        guard let hospital = viewModel.filteredHospitals[safe: indexPath.row] else {
            return cell
        }

        configureCell(cell, with: hospital)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let hospital = viewModel.filteredHospitals[safe: indexPath.row] else {
            return
        }

        viewModel.navigateToHospitalProfile(hospitalId: hospital.id)
    }

    private func configureCell(_ cell: HospitalSelectionTableViewCell, with hospital: UnifiedHospital) {
        // Set hospital name
        cell.hospitalNameLabel?.text = viewModel.getDisplayName(for: hospital)

        // Set hospital address
        cell.hospitalAddressLabel?.text = hospital.address

        // Set hospital image
        if let imageURL = hospital.image {
            cell.hospitalImageView?.loadImage(from: imageURL)
        }

        // Set rating
        if let rating = hospital.avgRating {
            cell.ratingLabel?.text = viewModel.formatRating(rating)
            cell.ratingStackView?.isHidden = false
        } else {
            cell.ratingStackView?.isHidden = true
        }

        // Set reviews count
        if let reviewsCount = hospital.reviewsCount {
            cell.reviewsCountLabel?.text = "(\(reviewsCount))"
        }

        // Set distance
        if let distance = hospital.distance {
            cell.distanceLabel?.text = viewModel.formatDistance(distance)
            cell.distanceLabel?.isHidden = false
        } else {
            cell.distanceLabel?.isHidden = true
        }

        // Set specialties count
        if let specialtiesCount = hospital.specialties?.count, specialtiesCount > 0 {
            cell.specialtiesCountLabel?.text = "\(specialtiesCount) " +
                NSLocalizedString("Specialties", comment: "")
        } else {
            cell.specialtiesCountLabel?.text = ""
        }

        // Set district
        if let district = hospital.district {
            let districtName = LocalizationManager.shared.getCurrentLanguage() == "ar" ?
                (district.nameAr ?? district.name) : (district.nameEn ?? district.name)
            cell.districtLabel?.text = districtName
        }
    }
}
