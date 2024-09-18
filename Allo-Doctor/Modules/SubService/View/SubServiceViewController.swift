//
//  SubServiceViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 15/09/2024.
//

import UIKit
import Combine
class SubServiceViewController: BaseViewController<SubServiceViewModel> {
    @IBOutlet weak var subServicesCollectionView: UICollectionView!
    
    @IBOutlet weak var dropdownlist: CustomDropDownList!
    @IBOutlet weak var searchBar: CustomSearchBar!
    let dropDown = CustomDropDownList()
    override func viewDidLoad() {
        super.viewDidLoad()
        dropdownlist.items = ["Cairo, Al-Maadi", "Giza", "Alexandria", "Luxor", "Aswan"]
      
        // Handle the selected item
        dropdownlist.didSelectItem = { selectedItem in
            print("User selected: \(selectedItem)")
        }
    
        
    
    }
    override func setupUI() {
        SetupCollectionView()
    }
    override func bindViewModel() {
        bindSearchBarButton()
        viewModel.fetchSubServices()
        bindSubServiceCollectionView()
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
        
        return cell
    }
    
    func SetupCollectionView(){
        subServicesCollectionView.registerCell(cellClass: SubServiceCollectionViewCell.self)
        subServicesCollectionView.backgroundColor = .white
        subServicesCollectionView.dataSource = self
        subServicesCollectionView.delegate = self
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width*0.485, height: collectionView.frame.width*0.45)
    }
}
extension SubServiceViewController{
    private func bindSubServiceCollectionView() {
        viewModel.$subServices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.subServicesCollectionView.reloadData()
            }.store(in: &cancellables)
    }
    private func bindSearchBarButton(){
        searchBar.navButtonTapped
            .sink { [weak self] in
                self!.viewModel.navToSearchScreen()
            }
            .store(in: &cancellables)
    }
    
}
