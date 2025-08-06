//
//  OneDayCareHospitalsViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 26/12/2024.
//

import UIKit

class OneDayCareHospitalsViewController: BaseViewController<OneDayCareHospitalsViewModel> {

    @IBOutlet weak var searchBar: SearchView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var navBack: CustomNavigationBackButton!
    @IBOutlet weak var hospitablsCollectionView: UICollectionView!
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    // MARK: - Overided FunctionFrom baseViewController
    override func bindViewModel() {
        bindExternalClinicData()
        viewModel.getAllHospitals()
        bindSearchResults()
    }
    @IBAction func selectAreaAction(_ sender: Any) {
    }
    override func setupUI() {
//        bindCollectionViewHeight()
        setupSearchBar()
        setupCollectionView()
        searchBar.searchTextfield.placeholder = AppLocalizedKeys.searchForHospitals.localized
        navBack.setTitle(AppLocalizedKeys.Hospitals.localized)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindViewModel()
    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    @IBAction func navBack(_ sender: Any) {
        viewModel.navBack()
    }
}
extension OneDayCareHospitalsViewController{

    private func setupCollectionView(){
        hospitablsCollectionView.registerCell(cellClass: ExternalClinicHospitalsCollectionViewCell.self)
        hospitablsCollectionView.delegate = self
        hospitablsCollectionView.dataSource = self
        hospitablsCollectionView.contentInset = UIEdgeInsets.init(top: 16, left: 0, bottom: 20, right: 0)
    }

}
extension OneDayCareHospitalsViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hospitalsData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = viewModel.hospitalsData?[indexPath.row]
       let cell = collectionView.dequeue(indexpath: indexPath) as ExternalClinicHospitalsCollectionViewCell
        cell.cornerRadius = 10
        cell.applyDropShadow()
           
        guard let infoServie = viewModel.hospitalsData?[indexPath.row]
            else { return cell }
        cell.setupCell(infoService:infoServie)
        
     
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = viewModel.hospitalsData?[indexPath.row].id ?? 0
        viewModel.showHospitalProfile(hospitalId: id)
      
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
       }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.bounds.width - 32
            return CGSize(width: width, height: 140)
        }
     
}
// MARK: ViewModel Binding phamrmacies Data
extension OneDayCareHospitalsViewController{
   private func bindExternalClinicData(){
        viewModel.$hospitalsData
            .receive(on: DispatchQueue.main)
            .sink { pharmacies in
                self.hospitablsCollectionView.reloadData()
            }.store(in: &cancellables)
    }
    private func bindSearchResults() {
        viewModel.$hospitalsData
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.hospitablsCollectionView.reloadData()
                }.store(in: &cancellables)
        }
    private func setupSearchBar() {
        searchBar.searchTextfield.placeholder = AppLocalizedKeys.SearchforDoctor.localized
        searchBar.searchTextfield.textPublisher()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.viewModel.searchText = searchText
            }
            .store(in: &cancellables)
    }
}

