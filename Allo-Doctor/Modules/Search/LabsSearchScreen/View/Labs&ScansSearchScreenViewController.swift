//
//  LabsSearchScreenViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/09/2024.
//

import UIKit
import Kingfisher
enum screenType{
    case labs
    case scans
}
class LabsSearchScreenViewController: BaseViewController<LabsSearchScreenViewModel>{
 
    @IBOutlet weak var screenTypeLabel: CairoBold!
    @IBOutlet weak var selectAreaLabel: UIButton!
    @IBOutlet weak var selectCityDropDownList: CustomDropDownList!
    @IBOutlet weak var insuraneProviderLabel: UILabel!
    @IBOutlet weak var upperView: CustomCornerRaduis!
    @IBOutlet weak var searchBar: SearchView!
    
    @IBOutlet weak var dunamicViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dynamicColllectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var navButton: CustomNavigationBackButton!

    @IBOutlet weak var labsCollectionView: UICollectionView!
    var medicalInsuranceId : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
      
       
    }
    
    @IBAction func selectInsuranceAction(_ sender: Any) {
       
        let insuranceVC = InsuranceCompanyTableViewController()
        insuranceVC.delegate = self
        viewModel.coordinator?.presentModallyWithRoot(insuranceVC)
    }
    @IBAction func selectAreaAction(_ sender: Any) {
        let citiesVC = SectionSearchableTableViewController(cityData: viewModel.cities)
        citiesVC.delegate = self
        viewModel.coordinator?.presentModallyWithRoot(citiesVC)
    }
    override func setupUI(){
        setupCollectionView()
        setupViewAccordingToScreenType()
        bindCollectionViewHeight()
    }
    override func bindViewModel() {
        viewModel.fetchLabsAndScans(search: "",medicalInsuranceId:medicalInsuranceId)
        bindCollectionView()
        viewModel.getAllAreaOfResidence()
        searchBar.searchTextfield.textPublisher()
            .sink { [weak self] searchText in
                self?.viewModel.search(query: searchText)
            }
            .store(in: &cancellables)

    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 30)

    }


    @IBAction func navBack(_ sender: Any) {
        viewModel.coordinator?.navigateBack()
    }
    

}
extension LabsSearchScreenViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setupCollectionView() {
        labsCollectionView.delegate = self
        labsCollectionView.dataSource = self
        labsCollectionView.registerCell(cellClass: LabsCollectionViewCell.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.labs?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  
        let cell = collectionView.dequeue(indexpath: indexPath) as LabsCollectionViewCell
        let data = viewModel.labs?[indexPath.row]
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            cell.configure(labName: data?.nameAr ?? "Not available", imageURL: data?.mainImage ?? "")
        }
        else{
            cell.configure(labName: data?.nameEn ?? "Not available", imageURL: data?.mainImage ?? "")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = viewModel.labs?[indexPath.row].id ?? 1
        viewModel.navToLabsAnsScanProfile(url: "", id: id)
    }
}
extension LabsSearchScreenViewController{
    private func bindCollectionView() {
        viewModel.$labs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] labs in
                self?.labsCollectionView.reloadData()
            }.store(in: &cancellables)
    }
}
extension LabsSearchScreenViewController{
   func setupViewAccordingToScreenType() {
       if viewModel.screenType == labAndScan.labs.rawValue{
           navButton.setTitle(AppLocalizedKeys.bookLabs.localized)
           screenTypeLabel.text = AppLocalizedKeys.featureLabCenter.localized
           searchBar.searchTextfield.placeholder = AppLocalizedKeys.searchForLabCenter.localized
       }
       else {
           navButton.setTitle(AppLocalizedKeys.bookScan.localized)
           screenTypeLabel.text = AppLocalizedKeys.featureScanCenter.localized
           searchBar.searchTextfield.placeholder =  AppLocalizedKeys.searchForScanCenter.localized
       }
   }
    private func bindCollectionViewHeight() {
        labsCollectionView.publisher(for: \.contentSize)
            .sink { [weak self] newSize in
                guard let self = self else { return }
                if self.dynamicColllectionViewHeightConstraint.constant != newSize.height {
                    self.dynamicColllectionViewHeightConstraint.constant = newSize.height
                    self.view.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
        
    }
}

extension LabsSearchScreenViewController:SectionSearchableTableViewControllerDelegate {
    func sectionSearchableTableViewController(_ controller: SectionSearchableTableViewController, didSelectDistrictWithID id: Int, districtName name: String) {
        
        selectAreaLabel.setTitle(name, for: .normal)
//        viewModel.districtId.value = id
//                    isCitySelected = true
        
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
    
    func sectionSearchableTableViewControllerDidTapDismiss(_ controller: SectionSearchableTableViewController) {
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
}
extension LabsSearchScreenViewController:InsuranceCompanyTableViewControllerDelegate {
    func insuranceCompanyTableViewController(_ controller: InsuranceCompanyTableViewController, didSelectItem item: InsuranceCompany) {
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            insuraneProviderLabel.text = item.name_ar
        }
        else{
            insuraneProviderLabel.text = item.name_en}
        viewModel.fetchLabsAndScans(search: searchBar.searchTextfield.text ?? "", medicalInsuranceId: item.id)
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
        
    }
    
    func insuranceCompanyTableViewControllerDidTapDismiss(_ controller: InsuranceCompanyTableViewController) {
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
}
