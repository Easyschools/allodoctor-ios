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
    @IBOutlet weak var dropdownlist: CustomDropDownList!
    @IBOutlet weak var searchBar: CustomSearchBar!
    let dropDown = CustomDropDownList()
    private let loadingScreen = CustomLoadingScreen()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingScreen.startLoading()
    
    }
    override func setupUI() {
        SetupCollectionView()
        bindCollectionViewHeight()
       
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
        cell.subServiceName.text = subServices.name
//        cell.subServiceImage.kf.setImage(with:URL(string: subServices.image) )
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
            viewModel.coordinator?.showClinicsSearch()
        }
        else {
            viewModel.coordinator?.showHospitalSearch()
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
                self?.viewModel.navToSearchScreen()
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
