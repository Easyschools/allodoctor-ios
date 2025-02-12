//
//  OperationHospitalsViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 17/11/2024.
//

import UIKit

class OperationHospitalsViewController: BaseViewController<OperationHospitalsViewModel> {

    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var navBackButton: CustomNavigationBackButton!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var dropDownView: CustomDropDownList!
    @IBOutlet weak var operationHospitalsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Overided FunctionFrom baseViewController
    override func bindViewModel() {
        bindExternalClinicData()
        viewModel.getOperationData(search: "", districtId: "")
        viewModel.getAllAreaOfResidence()
    }
    override func setupUI() {
        dropDownView.label.text = AppLocalizedKeys.selectArea.localized
        setupCollectionView()
    }
    @IBAction func districtView(_ sender: Any) {
        let citiesVC = SectionSearchableTableViewController(cityData: viewModel.cities)
        citiesVC.delegate = self
        viewModel.coordinator?.presentModallyWithRoot(citiesVC)
    }
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
}
extension OperationHospitalsViewController{

    private func setupCollectionView(){
        operationHospitalsCollectionView.registerCell(cellClass: OperationHospitalsCollectionViewCell.self)
        operationHospitalsCollectionView.delegate = self
        operationHospitalsCollectionView.dataSource = self
    }
}
extension OperationHospitalsViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.operationData?.infoServices?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hospital = viewModel.operationData?.infoServices?[indexPath.row]
       let cell = collectionView.dequeue(indexpath: indexPath) as OperationHospitalsCollectionViewCell
        cell.setupCell(price:hospital?.price ?? "0", hospitalLogoURL: hospital?.infoService?.image , name: hospital?.infoService?.nameEn ?? "", district: hospital?.infoService?.districtId?.nameEn ?? "", rating: hospital?.infoService?.avgRating ?? 0)
        cell.cornerRadius = 10
        cell.applyDropShadow()
        
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let opeationDataId = viewModel.operationData?.infoServices?[safe: indexPath.row]?.operationServiceID,
              let hospital = viewModel.operationData?.infoServices?[safe: indexPath.row] else {
            return
        }

        viewModel.coordinator?.showOperationAppointments(operationServiceId: opeationDataId, hospitalData: hospital)

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
           return UIEdgeInsets(top: 16, left: 16, bottom: 20, right: 16)
       }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.bounds.width - 32
            return CGSize(width: width, height: 188)
        }
     
}
// MARK: ViewModel Binding phamrmacies Data
extension OperationHospitalsViewController{
   private func bindExternalClinicData(){
       viewModel.$operationData
            .receive(on: DispatchQueue.main)
            .sink { pharmacies in
                self.operationHospitalsCollectionView.reloadData()
            }.store(in: &cancellables)
    }
}




extension OperationHospitalsViewController:SectionSearchableTableViewControllerDelegate {
    func sectionSearchableTableViewController(_ controller: SectionSearchableTableViewController, didSelectDistrictWithID id: Int, districtName name: String) {
   
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
        viewModel.getOperationData(search: searchView.searchTextfield.text ?? "", districtId: id.toString())
    }
    
    func sectionSearchableTableViewControllerDidTapDismiss(_ controller: SectionSearchableTableViewController) {
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
    
}
