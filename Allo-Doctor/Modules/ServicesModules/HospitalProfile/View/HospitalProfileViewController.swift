//
//  HospitalProfileViewController.swift
//  Allo-Doctor
//
//  Created for Hospital-First Flow Implementation
//

import UIKit
import Combine

class HospitalProfileViewController: BaseViewController<HospitalProfileViewModel> {

    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var hospitalAddressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var specialtiesTableView: UITableView!
    @IBOutlet weak var specialtiesTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reviewsCollectionView: UICollectionView!
    @IBOutlet weak var insuranceCollectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var navBackButton: CustomNavigationBackButton!
    @IBOutlet weak var specialtiesTitleLabel: UILabel!
    @IBOutlet weak var reviewsTitleLabel: UILabel!
    @IBOutlet weak var insuranceTitleLabel: UILabel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        setupNavigationBar()
        setupLabels()
        setupButtons()
        setupTableView()
        setupCollectionViews()
    }

    override func bindViewModel() {
        super.bindViewModel()
        bindHospitalProfile()
        bindLoadingState()
        bindFavoriteState()
        bindErrorState()

        // Initial fetch
        viewModel.fetchHospitalProfile()
    }

    // MARK: - Setup Methods
    private func setupNavigationBar() {
        navBackButton?.setTitle(NSLocalizedString("Hospital Profile", comment: ""))
    }

    private func setupLabels() {
        hospitalNameLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        hospitalNameLabel?.textColor = .black

        hospitalAddressLabel?.font = UIFont.systemFont(ofSize: 14)
        hospitalAddressLabel?.textColor = .gray

        descriptionLabel?.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel?.textColor = .darkGray
        descriptionLabel?.numberOfLines = 0

        aboutLabel?.font = UIFont.systemFont(ofSize: 14)
        aboutLabel?.textColor = .darkGray
        aboutLabel?.numberOfLines = 0

        specialtiesTitleLabel?.text = NSLocalizedString("Available Specialties", comment: "")
        specialtiesTitleLabel?.font = UIFont.boldSystemFont(ofSize: 18)

        reviewsTitleLabel?.text = NSLocalizedString("Reviews", comment: "")
        reviewsTitleLabel?.font = UIFont.boldSystemFont(ofSize: 18)

        insuranceTitleLabel?.text = NSLocalizedString("Accepted Insurance", comment: "")
        insuranceTitleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }

    private func setupButtons() {
        phoneButton?.setTitle(NSLocalizedString("Call", comment: ""), for: .normal)
        phoneButton?.layer.cornerRadius = 8

        locationButton?.setTitle(NSLocalizedString("Location", comment: ""), for: .normal)
        locationButton?.layer.cornerRadius = 8

        favoriteButton?.tintColor = .systemRed
    }

    private func setupTableView() {
        specialtiesTableView?.delegate = self
        specialtiesTableView?.dataSource = self
        specialtiesTableView?.registerCell(cellClass: HospitalSpecialtyTableViewCell.self)
        specialtiesTableView?.separatorStyle = .none
        specialtiesTableView?.isScrollEnabled = false
    }

    private func setupCollectionViews() {
        reviewsCollectionView?.delegate = self
        reviewsCollectionView?.dataSource = self
        reviewsCollectionView?.registerCell(cellClass: ReviewCollectionViewCell.self)

        insuranceCollectionView?.delegate = self
        insuranceCollectionView?.dataSource = self
        insuranceCollectionView?.registerCell(cellClass: InsuranceCollectionViewCell.self)
    }

    // MARK: - Binding Methods
    private func bindHospitalProfile() {
        viewModel.$hospitalProfile
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] profile in
                self?.updateUI(with: profile)
            }
            .store(in: &cancellables)
    }

    private func bindLoadingState() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator?.startAnimating()
                    self?.scrollView?.isHidden = true
                } else {
                    self?.loadingIndicator?.stopAnimating()
                    self?.scrollView?.isHidden = false
                }
            }
            .store(in: &cancellables)
    }

    private func bindFavoriteState() {
        viewModel.$isFavorite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFavorite in
                let imageName = isFavorite ? "heart.fill" : "heart"
                self?.favoriteButton?.setImage(UIImage(systemName: imageName), for: .normal)
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

    // MARK: - Update UI
    private func updateUI(with profile: HospitalProfile) {
        // Hospital name
        hospitalNameLabel?.text = viewModel.getDisplayName()

        // Address
        hospitalAddressLabel?.text = profile.address

        // Description
        descriptionLabel?.text = viewModel.getDisplayDescription()

        // About
        aboutLabel?.text = profile.about

        // Header image
        if let imageURL = profile.backgroundImage ?? profile.image {
            headerImageView?.loadImage(from: imageURL)
        }

        // Rating
        if let rating = profile.avgRating {
            ratingLabel?.text = viewModel.formatRating(rating)
            reviewsCountLabel?.text = "(\(profile.reviewsCount ?? 0))"
            ratingStackView?.isHidden = false
        } else {
            ratingStackView?.isHidden = true
        }

        // Reload collections
        specialtiesTableView?.reloadData()
        updateTableViewHeight()

        reviewsCollectionView?.reloadData()
        insuranceCollectionView?.reloadData()
    }

    private func updateTableViewHeight() {
        specialtiesTableView?.layoutIfNeeded()
        let height = specialtiesTableView?.contentSize.height ?? 0
        specialtiesTableHeightConstraint?.constant = height
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

    @IBAction func favoriteAction(_ sender: Any) {
        viewModel.toggleFavorite()
    }

    @IBAction func callAction(_ sender: Any) {
        viewModel.callHospital()
    }

    @IBAction func locationAction(_ sender: Any) {
        viewModel.showLocation()
    }

    @IBAction func viewAllReviewsAction(_ sender: Any) {
        viewModel.showReviews()
    }

    @IBAction func viewAllInsuranceAction(_ sender: Any) {
        viewModel.showInsurance()
    }
}

// MARK: - UITableViewDelegate & DataSource (Specialties)
extension HospitalProfileViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.hospitalProfile?.specialties.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "HospitalSpecialtyTableViewCell",
            for: indexPath
        ) as? HospitalSpecialtyTableViewCell else {
            return UITableViewCell()
        }

        guard let specialty = viewModel.hospitalProfile?.specialties[safe: indexPath.row] else {
            return cell
        }

        cell.configure(with: specialty, viewModel: viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let specialty = viewModel.hospitalProfile?.specialties[safe: indexPath.row] else {
            return
        }

        viewModel.navigateToSpecialty(specialtyId: specialty.id)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - UICollectionViewDelegate & DataSource
extension HospitalProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == reviewsCollectionView {
            return min(viewModel.hospitalProfile?.reviews?.count ?? 0, 3) // Show max 3
        } else {
            return viewModel.hospitalProfile?.medicalInsurance?.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == reviewsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ReviewCollectionViewCell",
                for: indexPath
            ) as? ReviewCollectionViewCell else {
                return UICollectionViewCell()
            }

            if let review = viewModel.hospitalProfile?.reviews?[safe: indexPath.row] {
                cell.configure(with: review)
            }

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "InsuranceCollectionViewCell",
                for: indexPath
            ) as? InsuranceCollectionViewCell else {
                return UICollectionViewCell()
            }

            if let insurance = viewModel.hospitalProfile?.medicalInsurance?[safe: indexPath.row] {
                cell.configure(with: insurance)
            }

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == reviewsCollectionView {
            return CGSize(width: 280, height: 120)
        } else {
            return CGSize(width: 80, height: 80)
        }
    }
}
