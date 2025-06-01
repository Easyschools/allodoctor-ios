//
//  SubServiceViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 15/09/2024.
//

import UIKit
import Kingfisher
class SubServiceViewController: BaseViewController<SubServiceViewModel> {
    @IBOutlet weak var subServicesCollectionView: UICollectionView!
    @IBOutlet weak var subServiceCollectionViewDynamicHeight: NSLayoutConstraint!
    @IBOutlet weak var bannerPhoto: UIImageView!
    @IBOutlet weak var dropdownlist: CustomDropDownList!
    @IBOutlet weak var searchBar: CustomSearchBar!
    let dropDown = CustomDropDownList()
    private let loadingScreen = CustomLoadingScreen()
    @IBOutlet weak var chatWithUsView: ChatWithUsView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingScreen.startLoading()
    
    }
    override func setupUI() {
        searchBar.searchTextfield.placeholder = AppLocalizedKeys.searchForHospital.localized
        SetupCollectionView()
        bindCollectionViewHeight()
        chatWithUsView.onChatWithUsButtonTapped = { [weak self] in
            self?.viewModel.showChat()
                }
       
    }
    override func bindViewModel() {
        bindSearchBarButton()
        viewModel.fetchSubServices()
        bindSubServiceCollectionView()
    }
    override func viewDidLayoutSubviews() {
        view.addSubview(loadingScreen)
        loadingScreen.frame = view.bounds
       
    }

    
}
extension SubServiceViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.subServices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let subServices = viewModel.subServices[indexPath.row]
        let cell = collectionView.dequeue(indexpath: indexPath) as SubServiceCollectionViewCell
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            cell.subServiceName.text = subServices.name_ar
        }
        else{
            cell.subServiceName.text = subServices.name}
        cell.subServiceImage.kf.setImage(with:URL(string: subServices.image ?? "") )
        return cell
    }
    
    func SetupCollectionView(){
        subServicesCollectionView.registerCell(cellClass: SubServiceCollectionViewCell.self)
        subServicesCollectionView.backgroundColor = .white
        subServicesCollectionView.dataSource = self
        subServicesCollectionView.delegate = self
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width*0.485, height: collectionView.frame.width*0.36)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let  id =  viewModel.subServices[indexPath.row].id
        if  id == 4 || id == 22 {
            viewModel.coordinator?.showExternalClinics()
        }
       else if id == 6 {
            viewModel.coordinator?.showOperationsSearchScreen()
        }
        else if id == 5 {
            viewModel.coordinator?.showIntensiveCareUnits()
        }
        else if id == 33{
            viewModel.coordinator?.showIncubations()
        }
        else if id == 36 {
            viewModel.showEmergency()
        }
        else {
            viewModel.coordinator?.showOneDayCareHospitals()
        }
        
    }
}
extension SubServiceViewController{
    private func bindSubServiceCollectionView() {
        viewModel.$subServices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] subServices in
                self?.subServicesCollectionView.reloadData()
                if !subServices.isEmpty{
                    
                self?.loadingScreen.stopLoading()
                            
                }
            }.store(in: &cancellables)
    }
    private func bindSearchBarButton(){
        searchBar.navButtonTapped
            .sink { [weak self] in
                self?.viewModel.coordinator?.showOneDayCareHospitals()
            }
            .store(in: &cancellables)
    }
    
    private func bindCollectionViewHeight() {
        subServicesCollectionView.publisher(for: \.contentSize)
            .sink { [weak self] newSize in
                guard let self = self else { return }
                if self.subServiceCollectionViewDynamicHeight.constant != newSize.height {
                    self.subServiceCollectionViewDynamicHeight.constant = newSize.height
                    self.view.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
        
    }
}
