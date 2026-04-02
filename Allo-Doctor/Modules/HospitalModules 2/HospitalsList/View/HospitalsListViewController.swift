//
//  HospitalsListViewController.swift
//  Allo-Doctor
//
//  Created by Assistant on 14/11/2025.
//

import UIKit
import Kingfisher
import Combine

class HospitalsListViewController: BaseViewController<HospitalsListViewModel> {
    // MARK: - UI Components
    private let upperView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkBlue_295DA8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let backButton: CustomNavigationBackButton = {
        let button = CustomNavigationBackButton()
        button.setTitle(AppLocalizedKeys.Hospitals.localized)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let searchBar: CustomSearchBar = {
        let searchBar = CustomSearchBar()
        searchBar.searchTextfield.placeholder = AppLocalizedKeys.searchForHospitals.localized
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let hospitalsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .greishWhiteF2F2F2
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        return collectionView
    }()

    private let loadingScreen = CustomLoadingScreen()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upperView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 30)
        loadingScreen.frame = view.bounds
    }

    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        view.backgroundColor = .greishWhiteF2F2F2

        // Add subviews
        view.addSubview(upperView)
        view.addSubview(backButton)
        view.addSubview(searchBar)
        view.addSubview(hospitalsCollectionView)
        view.addSubview(loadingScreen)

        // Setup back button action
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        // Setup collection view
        setupCollectionView()

        // Layout constraints
        NSLayoutConstraint.activate([
            // Upper view
            upperView.topAnchor.constraint(equalTo: view.topAnchor),
            upperView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            upperView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            upperView.heightAnchor.constraint(equalToConstant: 200),

            // Back button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.heightAnchor.constraint(equalToConstant: 44),

            // Search bar
            searchBar.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 50),

            // Collection view
            hospitalsCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            hospitalsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hospitalsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hospitalsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupCollectionView() {
        hospitalsCollectionView.delegate = self
        hospitalsCollectionView.dataSource = self
        // Changed to use LabsCollectionViewCell like HospitalSearchViewController
        hospitalsCollectionView.registerCell(cellClass: LabsCollectionViewCell.self)
    }

    // MARK: - ViewModel Binding
    override func bindViewModel() {
        super.bindViewModel()

        // Fetch hospitals
        viewModel.fetchHospitals()

        // Bind hospitals
        viewModel.$hospitals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hospitals in
                self?.hospitalsCollectionView.reloadData()
            }
            .store(in: &cancellables)

        // Bind loading state
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingScreen.startLoading()
                } else {
                    self?.loadingScreen.stopLoading()
                }
            }
            .store(in: &cancellables)

        // Bind search
        searchBar.navButtonTapped
            .sink { [weak self] in
                // Handle search action if needed
                print("Search tapped")
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions
    @objc private func backButtonTapped() {
        viewModel.navigateBack()
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension HospitalsListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hospitals.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Changed to use LabsCollectionViewCell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabsCollectionViewCell", for: indexPath) as? LabsCollectionViewCell else {
            fatalError("Unable to dequeue LabsCollectionViewCell")
        }
        
        let hospital = viewModel.hospitals[indexPath.row]
        
        // Configure cell with hospital data
        // Assuming LabsCollectionViewCell has a labsImage property for the image
        if let imageURL = URL(string: hospital.image ?? "") {
            cell.labsImage?.kf.setImage(with: imageURL)
        }
        
        // If LabsCollectionViewCell has additional properties like labels,
        // you can configure them here as well
        // Example: cell.titleLabel?.text = hospital.name
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Match the size from HospitalSearchViewController
        let width = collectionView.frame.width * 0.48
        return CGSize(width: width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hospital = viewModel.hospitals[indexPath.row]
        viewModel.navigateToHospitalSpecialties(hospital: hospital)
    }
}
