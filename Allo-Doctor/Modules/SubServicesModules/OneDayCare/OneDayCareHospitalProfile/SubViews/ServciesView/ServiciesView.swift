//
//  ServiciesView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 26/12/2024.
//

import UIKit
import Combine

class ServiciesView: UIView {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var services: OneDayCareHospitals?
    
    // MARK: - Outlets
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    
    // MARK: - Publishers
    private let selectedServiceSubject = PassthroughSubject<Int, Never>()
    var selectedServicePublisher: AnyPublisher<Int, Never> {
        selectedServiceSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let nibName = String(describing: type(of: self))
        guard let nibView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView else {
            fatalError("Failed to load \(nibName) from nib.")
        }
        nibView.frame = bounds
        nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(nibView)
        
        setupCollectionView()
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        servicesCollectionView.registerCell(cellClass: OneDayCareServiceCollectionViewCell.self)
        servicesCollectionView.delegate = self
        servicesCollectionView.dataSource = self
        servicesCollectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 20, right: 0)
        
        // Add refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        servicesCollectionView.refreshControl = refreshControl
    }
    
    // MARK: - Data Binding
    func bindSelection(action: @escaping (Int) -> Void) {
        selectedServicePublisher
            .receive(on: DispatchQueue.main)
            .sink { serviceId in
                action(serviceId)
            }
            .store(in: &cancellables)
    }
    
    func bindData(to publisher: AnyPublisher<OneDayCareHospitals?, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hospitalData in
                self?.updateUI(with: hospitalData)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Updates
    private func updateUI(with hospitalData: OneDayCareHospitals?) {
        services = hospitalData
        servicesCollectionView.reloadData()
        servicesCollectionView.refreshControl?.endRefreshing()
        
        // Show empty state if needed
        if hospitalData?.oneDayServices?.isEmpty ?? true {
            showEmptyState()
        } else {
            hideEmptyState()
        }
    }
    
    @objc private func refreshData() {
        // Trigger data refresh if needed
        // You might want to add a callback to the view model here
    }
    
    // MARK: - Empty State
    private func showEmptyState() {
        // Add empty state view if needed
        let emptyLabel = UILabel()
        emptyLabel.text = "No services available"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .gray
        emptyLabel.tag = 100
        
        servicesCollectionView.backgroundView = emptyLabel
    }
    
    private func hideEmptyState() {
        servicesCollectionView.backgroundView = nil
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension ServiciesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services?.oneDayServices?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexpath: indexPath) as OneDayCareServiceCollectionViewCell
        
        if let data = services?.oneDayServices?[indexPath.row] {
            cell.cornerRadius = 10
            cell.applyDropShadow()
            
            let isArabic = UserDefaultsManager.sharedInstance.getLanguage() == .ar
            let serviceName = isArabic ? data.dayService?.nameAr : data.dayService?.nameEn
            let serviceDesc = isArabic ? data.dayService?.descriptionAr : data.dayService?.descriptionEn
            
            cell.configureCell(
                serviceName: serviceName ?? "",
                serviceDesc: serviceDesc ?? "",
                servicePrice: data.price ?? ""
            )
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let serviceId = services?.oneDayServices?[indexPath.row].dayService?.id {
            selectedServiceSubject.send(serviceId)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32
        return CGSize(width: width, height:140)
    }
}
