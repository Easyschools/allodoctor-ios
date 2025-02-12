//
//  ExternalClinicHospitalsViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 17/11/2024.
//

import UIKit

class ExternalClinicHospitalsViewController:
    BaseViewController<ExternalClinicHospitalsViewModel> {

    @IBOutlet weak var citiesView: CustomDropDownList!
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
        viewModel.getExternalClinicHospitals()
        viewModel.getAllAreaOfResidence()
    }
    @IBAction func selectAreaAction(_ sender: Any) {
        let citiesVC = SectionSearchableTableViewController(cityData: viewModel.cities)
        citiesVC.delegate = self
        viewModel.coordinator?.presentModallyWithRoot(citiesVC)
    }
    override func setupUI() {
//        bindCollectionViewHeight()
        citiesView.label.text = AppLocalizedKeys.selectArea.localized
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
extension ExternalClinicHospitalsViewController{

    private func setupCollectionView(){
        hospitablsCollectionView.registerCell(cellClass: ExternalClinicHospitalsCollectionViewCell.self)
        hospitablsCollectionView.delegate = self
        hospitablsCollectionView.dataSource = self
        hospitablsCollectionView.contentInset = UIEdgeInsets.init(top: 16, left: 0, bottom: 20, right: 0)
    }

}
extension ExternalClinicHospitalsViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.externalClinicData?.infoServices?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeue(indexpath: indexPath) as ExternalClinicHospitalsCollectionViewCell
        cell.cornerRadius = 10
        cell.applyDropShadow()
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        viewModel.navToDoctors()
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
extension ExternalClinicHospitalsViewController{
   private func bindExternalClinicData(){
        viewModel.$externalClinicData
            .receive(on: DispatchQueue.main)
            .sink { externalClinic in
                self.hospitablsCollectionView.reloadData()
            }.store(in: &cancellables)
    }
   
   
}

extension ExternalClinicHospitalsViewController:SectionSearchableTableViewControllerDelegate {
    func sectionSearchableTableViewController(_ controller: SectionSearchableTableViewController, didSelectDistrictWithID id: Int, districtName name: String) {
        citiesView.label.text = name
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
    
    func sectionSearchableTableViewControllerDidTapDismiss(_ controller: SectionSearchableTableViewController) {
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
    
}
