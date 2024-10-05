//
//  ServicesViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 12/09/2024.
//

import UIKit
import Kingfisher
enum NavToServiceId:Int
{
    case hospital = 1
    case clinics = 2
    case labs = 16
    case scans = 17
}

class ServicesViewController: BaseViewController<ServicesViewModel> {
    // MARK: - @IBOutlets
    @IBOutlet weak var searchView: CustomSearchBar!
    @IBOutlet weak private var upperStackView: UIStackView!
    @IBOutlet weak private var offersCollectionView: UICollectionView!
    @IBOutlet weak private var servicesCollectionView: UICollectionView!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var servicesCollectionViewDynamicHeight: NSLayoutConstraint!
    @IBOutlet weak private var offersPageControl: UIPageControl!
    private let loadingScreen = CustomLoadingScreen()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

      
        view.addSubview(loadingScreen)
       
        bindSearchBarButton()
        setupUI()
        bindViewModel()
        viewModel.fetchServices()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.barTintColor = .darkBlue_295DA8
        viewModel.startAutoScroll()
    }
    
 
    // MARK: - Setup UI
    override func setupUI() {
        setupCollectionViews()
        offersPageControl.numberOfPages = viewModel.images.count
    }

    override func bindViewModel() {
        bindServices()
        bindImageControl()
    }

    override func viewDidLayoutSubviews() {
        bindCollectionViewHeight()
        loadingScreen.frame = view.bounds
        loadingScreen.startLoading()
    }
}

// MARK: -  Setup CollectionViews & Register cells
extension ServicesViewController {
    private func setupCollectionViews() {
        // Offers CollectionView Setup
        offersCollectionView.registerCell(cellClass: OffersCollectionViewCell.self)
        offersCollectionView.backgroundColor = .white
        offersCollectionView.dataSource = self
        offersCollectionView.delegate = self
        offersCollectionView.isPagingEnabled = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        offersCollectionView.collectionViewLayout = layout
        
        // Service CollectionView Setup
        servicesCollectionView.registerCell(cellClass: ServicesCollectionViewCell.self)
        servicesCollectionView.backgroundColor = .white
        servicesCollectionView.dataSource = self
        servicesCollectionView.delegate = self
    }

    private func bindCollectionViewHeight() {
        servicesCollectionView.publisher(for: \.contentSize)
            .sink { [weak self] newSize in
                guard let self = self else { return }
                if self.servicesCollectionViewDynamicHeight.constant != newSize.height {
                    self.servicesCollectionViewDynamicHeight.constant = newSize.height
                    self.view.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - CollectionViews Functions
extension ServicesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == offersCollectionView {
            return viewModel.images.count
        } else {
            return viewModel.services.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == offersCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OffersCollectionViewCell", for: indexPath) as! OffersCollectionViewCell
            cell.offersImage.image = viewModel.images[indexPath.row]
            return cell
        } else {
            let service = viewModel.services[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCollectionViewCell", for: indexPath) as! ServicesCollectionViewCell
            cell.serviceLabel.text = service.name
            cell.serviceImage.kf.setImage(with:URL(string: service.image ?? ""))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == offersCollectionView {
            return collectionView.bounds.size
        } else {
            return CGSize(width: collectionView.frame.width * 0.485, height: collectionView.frame.width * 0.364)
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == servicesCollectionView {
            let serviceid = viewModel.services[indexPath.row].id
            if let navServiceId = NavToServiceId(rawValue: serviceid) {
                switch navServiceId {
                case .hospital:
                    viewModel.navToSubServiceScreen()
                case .clinics:
                    viewModel.navtoclinicsSearch()
                case .labs:
                    viewModel.navToLabsAndScanSearchScreen(screenId:String(serviceid))
                case .scans:
                    viewModel.navToLabsAndScanSearchScreen(screenId:String(serviceid))
                }
            } else {
                viewModel.navToSearchScreen()
            }
            
            
        }
    }}

// MARK: - UIScrollViewDelegate
extension ServicesViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == offersCollectionView {
            viewModel.stopAutoScroll()
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == offersCollectionView {
            viewModel.startAutoScroll()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == offersCollectionView {
            let visibleIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
            viewModel.updateCurrentIndex(to: visibleIndex)
        }
    }
}

// MARK: - ViewModel Binding
extension ServicesViewController {
    func bindServices() {
        viewModel.$services
            .receive(on: DispatchQueue.main)
            .sink { [weak self] services in
                self?.servicesCollectionView.reloadData()
                if !services.isEmpty {
                    self?.loadingScreen.stopLoading()
                }
            }
            .store(in: &cancellables)
      
    }

    func bindImageControl() {
        viewModel.$currentImageIndex
            .sink { [weak self] index in
                guard let self = self else { return }
                self.offersPageControl.currentPage = index
                let indexPath = IndexPath(item: index, section: 0)
                if self.offersCollectionView.numberOfItems(inSection: 0) > index {
                    self.offersCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                }
            }
            .store(in: &cancellables)

        viewModel.$images
            .sink { [weak self] images in
                self?.offersCollectionView.reloadData()
                self?.offersPageControl.numberOfPages = images.count
            }
            .store(in: &cancellables)
    }

    private func bindSearchBarButton() {
        searchView.navButtonTapped
            .sink { [weak self] in
                self?.viewModel.navToSearchScreen()
            }
            .store(in: &cancellables)
    }
}
