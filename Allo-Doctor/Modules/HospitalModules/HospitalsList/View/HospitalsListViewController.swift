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

    private let bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let bannerPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .darkBlue_295DA8
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
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
        view.addSubview(bannerCollectionView)
        view.addSubview(bannerPageControl)
        view.addSubview(hospitalsCollectionView)
        view.addSubview(loadingScreen)

        // Setup back button action
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        // Setup collection views
        setupCollectionViews()

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

            // Banner collection view
            bannerCollectionView.topAnchor.constraint(equalTo: upperView.bottomAnchor, constant: 12),
            bannerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bannerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bannerCollectionView.heightAnchor.constraint(equalToConstant: 160),

            // Banner page control
            bannerPageControl.topAnchor.constraint(equalTo: bannerCollectionView.bottomAnchor, constant: 8),
            bannerPageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Hospitals collection view
            hospitalsCollectionView.topAnchor.constraint(equalTo: bannerPageControl.bottomAnchor, constant: 8),
            hospitalsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hospitalsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hospitalsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupCollectionViews() {
        // Hospitals collection view
        hospitalsCollectionView.delegate = self
        hospitalsCollectionView.dataSource = self
        hospitalsCollectionView.registerCell(cellClass: LabsCollectionViewCell.self)

        // Banner collection view
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.registerCell(cellClass: OffersCollectionViewCell.self)

        // Hide banner views until data arrives
        bannerCollectionView.isHidden = true
        bannerPageControl.isHidden = true
    }

    // MARK: - ViewModel Binding
    override func bindViewModel() {
        super.bindViewModel()

        // Fetch data
        viewModel.fetchHospitals()
        viewModel.fetchHospitalBanners()

        // Bind hospitals
        viewModel.$hospitals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
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

        // Bind banners
        viewModel.$banners
            .receive(on: DispatchQueue.main)
            .sink { [weak self] banners in
                guard let self = self else { return }
                let isEmpty = banners?.isEmpty ?? true
                self.bannerCollectionView.isHidden = isEmpty
                self.bannerPageControl.isHidden = isEmpty
                self.bannerCollectionView.reloadData()
                self.bannerPageControl.numberOfPages = banners?.count ?? 0
                if !isEmpty { self.viewModel.startBannerAutoScroll() }
            }
            .store(in: &cancellables)

        // Bind current banner index (auto-scroll)
        viewModel.$currentBannerIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self = self else { return }
                self.bannerPageControl.currentPage = index
                let ip = IndexPath(item: index, section: 0)
                if self.bannerCollectionView.numberOfItems(inSection: 0) > index {
                    self.bannerCollectionView.scrollToItem(at: ip, at: .centeredHorizontally, animated: true)
                }
            }
            .store(in: &cancellables)

        // Bind search
        searchBar.navButtonTapped
            .sink { [weak self] in
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
        if collectionView == bannerCollectionView {
            return viewModel.banners?.count ?? 0
        }
        return viewModel.hospitals.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView {
            let cell = collectionView.dequeue(indexpath: indexPath) as OffersCollectionViewCell
            if let imageUrl = viewModel.banners?[indexPath.item].image {
                cell.configureCellImage(with: imageUrl)
            }
            return cell
        }
        let cell = collectionView.dequeue(indexpath: indexPath) as LabsCollectionViewCell
        let hospital = viewModel.hospitals[indexPath.row]
        cell.configure(hospital: hospital)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionView {
            return CGSize(width: bannerCollectionView.bounds.width, height: bannerCollectionView.bounds.height)
        }
        let width = (collectionView.bounds.width - 48) / 2 // 16 padding on each side + 12 spacing
        return CGSize(width: width, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView != bannerCollectionView else { return }
        let hospital = viewModel.hospitals[indexPath.row]
        viewModel.navigateToHospitalSpecialties(hospital: hospital)
    }
}

// MARK: - UIScrollViewDelegate (Banner Auto-Scroll)
extension HospitalsListViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == bannerCollectionView {
            viewModel.stopBannerAutoScroll()
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate: Bool) {
        if scrollView == bannerCollectionView {
            viewModel.startBannerAutoScroll()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == bannerCollectionView {
            let index = Int(scrollView.contentOffset.x / max(scrollView.frame.width, 1))
            viewModel.updateCurrentBannerIndex(to: index)
        }
    }
}
