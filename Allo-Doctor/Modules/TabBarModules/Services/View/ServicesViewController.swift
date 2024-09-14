//
//  ServicesViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 12/09/2024.
//

import UIKit
import Combine
class ServicesViewController: BaseViewController<ServicesViewModel> {
    let imageARR = [UIImage(named: "offers"), UIImage(named: "offers"), UIImage(named: "offers")].compactMap { $0 }
// MARK: - @IBOutlets
    @IBOutlet weak private var offersCollectionView: UICollectionView!
    @IBOutlet weak private var servicesCollectionView: UICollectionView!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var servicesCollectionViewDynamicHeight: NSLayoutConstraint!
    @IBOutlet weak private var offersPageControl: UIPageControl!
// MARK: - LifeCycle
    override func viewDidLoad() {
            super.viewDidLoad()
       
            viewModel.fetchServices()
        }
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)

           // Force the tab bar color after the view has fully appeared
        tabBarController?.tabBar.barTintColor = .darkBlue_295DA8
       }
// MARK: - Setup UI
override func setupUI() {
         
       
        bindCollectionViewHeight()
        setupCollectionViews()
        viewModel.startAutoScroll()
        
        offersPageControl.numberOfPages = imageARR.count
    }
        override func bindViewModel() {
            bindServices()
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
        
       
    }
// MARK: -  Setup CollectionViews & Register cells
extension ServicesViewController{
    private func setupCollectionViews(){
        //  offers CollectionView Setup
        offersCollectionView.registerCell(cellClass: OffersCollectionViewCell.self)
        offersCollectionView.dataSource = self
        offersCollectionView.delegate = self
        //  Service CollectionView Setup
        servicesCollectionView.registerCell(cellClass: ServicesCollectionViewCell.self)
        servicesCollectionView.dataSource = self
        servicesCollectionView.delegate = self
    }
    // Update the dynamic height of servicesCollectionView
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
extension ServicesViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == offersCollectionView{
            return imageARR.count }
        else{
            return viewModel.services.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       

        if collectionView == offersCollectionView {
            // Dequeueing OffersCollectionViewCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OffersCollectionViewCell", for: indexPath) as! OffersCollectionViewCell
            cell.offersImage.image = imageARR[indexPath.row]
            return cell
        } else {
            // Dequeueing ServicesCollectionViewCell
            let service = viewModel.services[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCollectionViewCell", for: indexPath) as! ServicesCollectionViewCell
            cell.serviceLabel.text = service.name
            
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == offersCollectionView {
            return CGSize(width: view.frame.width*0.9 , height: collectionView.frame.height)}
        else {
            return CGSize(width: collectionView.frame.width*0.485, height: collectionView.frame.width*0.45)}
        }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return
//    }
       
    }

extension ServicesViewController : UIScrollViewDelegate {
        
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
                let visibleRect = CGRect(origin: offersCollectionView.contentOffset, size: offersCollectionView.bounds.size)
                let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
                if let visibleIndexPath = offersCollectionView.indexPathForItem(at: visiblePoint) {
                    viewModel.updateCurrentIndex(to: visibleIndexPath.item)
                }
            }
        }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tabBarController?.tabBar.barTintColor = .darkBlue295DA8
        }
    }
extension ServicesViewController {
    func bindServices(){
        viewModel.$services
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.servicesCollectionView.reloadData()}
            .store(in: &cancellables)
    }
}
