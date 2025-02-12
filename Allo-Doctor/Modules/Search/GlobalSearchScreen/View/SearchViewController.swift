//
//  SearchViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 15/09/2024.
//

import UIKit

enum Type: String {
    case doctor = "doctor"
    case infoService = "infoService"
}

class SearchViewController: BaseViewController<SearchViewModel> {
    // MARK: - IBOutlets
    @IBOutlet weak private var searchBar: SearchView!
    @IBOutlet weak private var citiesDropDownVIew: CustomDropDownList!
    @IBOutlet weak private var searchTableView: UITableView!
    @IBOutlet weak private var upperView: UIView!
    @IBOutlet weak private var searchResultLabel: CairoBold!
    
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBackTo()
        viewModel.coordinator?.navigationController.popViewController(animated: true)
      
    }
    
    @IBAction func showAreaSelection(_ sender: Any) {
        let citiesVC = SectionSearchableTableViewController(cityData: viewModel.cities)
        citiesVC.delegate = self
        viewModel.coordinator?.presentModallyWithRoot(citiesVC)
    }
    private var citiesArr: [City] = []
    var cityNames: [String] = []
    private var filteredSpecialties: [AllSpeciality] = []
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    override func bindViewModel() {
        viewModel.fetchSpecialties(isPaginate:5)
//        viewModel.fetchCities()
        bindSpeciality()
        bindCities()
        viewModel.getAllAreaOfResidence()
        bindSearchResults()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        upperView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: Dimensions.upperViewBorderRaduis.rawValue)
    }
    
    // MARK: - Setup
    override func setupUI() {
        setupTableView()
        citiesDropDownVIew.setDropdownHeight(500)
        setupSearchBar()
        citiesDropDownVIew.label.text = AppLocalizedKeys.selectArea.localized
    }
    
    private func setupSearchBar() {
        searchBar.searchTextfield.placeholder = AppLocalizedKeys.searchForSpecialityOrDoctor.localized
        searchBar.searchTextfield.textPublisher()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.viewModel.searchText = searchText
                self?.searchResultLabel.text =  AppLocalizedKeys.searchResults.localized
                if searchText.isEmpty {
                    self?.viewModel.clearSearchResults()
                    self?.searchResultLabel.text =  AppLocalizedKeys.AllSpecialities.localized
                    self?.searchTableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - TableView Setup
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchText.isEmpty ? viewModel.specialties.count : viewModel.searchResult.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchTableViewCell = tableView.dequeue(indexPath: indexPath)
        
        if viewModel.searchText.isEmpty {
            if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
                cell.cellLabel.text = viewModel.specialties[indexPath.row].nameAr
            }
            else{
                cell.cellLabel.text = viewModel.specialties[indexPath.row].nameEn}
            cell.searchedItemType.text = AppLocalizedKeys.Speciality.localized
        } else {
            if let searchResult = viewModel.searchResult.indices.contains(indexPath.row) ? viewModel.searchResult[indexPath.row] : nil {
                if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
                    cell.cellLabel.text = searchResult.nameAr}
                else { cell.cellLabel.text = searchResult.nameEn}
                cell.searchedItemType.text = searchResult.type.capitalized
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.searchText.isEmpty {
            viewModel.navtoDoctorSearch(specialityId: viewModel.specialties[indexPath.row].id.toString())
        } else {
            if let type = Type(rawValue: viewModel.searchResult[indexPath.row].type) {
                switch type {
                case .doctor:
                    let doctorid = viewModel.searchResult[indexPath.row].id
                    viewModel.navToDoctor(id: String(doctorid))
                case .infoService:
                    let clinicId = viewModel.searchResult[indexPath.row].id
                    viewModel.navToClinicProfile(id: String(clinicId))
                }
            } else {
                viewModel.navtoDoctorSearch(specialityId: viewModel.specialties[indexPath.row].id.toString())
            }
        }
    }
    
    private func setupTableView() {
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.registerCell(cellClass: SearchTableViewCell.self)
        searchTableView.separatorStyle = .none
        searchTableView.separatorInset = .zero
        searchTableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 8, right: 0)
    }
}

// MARK: - Data Binding
extension SearchViewController {
    
    func bindSpeciality() {
        viewModel.$specialties
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.filteredSpecialties = value
                self?.searchTableView.reloadData()
            }.store(in: &cancellables)
    }
    
    func bindCities() {
        viewModel.$cities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cities in
                let names = cities.map { $0.name }
//                self?.cityNames.append(contentsOf: names)
                self?.citiesDropDownVIew.items = self?.cityNames ?? []
            }.store(in: &cancellables)
    }
    
    func bindSearchResults() {
        viewModel.$searchResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.searchTableView.reloadData()
            }.store(in: &cancellables)
    }
}
extension SearchViewController:SectionSearchableTableViewControllerDelegate {
    func sectionSearchableTableViewController(_ controller: SectionSearchableTableViewController, didSelectDistrictWithID id: Int, districtName name: String) {
        citiesDropDownVIew.label.text = name
        viewModel.districtId.value = id
//        isCitySelected = true
        
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
    
    func sectionSearchableTableViewControllerDidTapDismiss(_ controller: SectionSearchableTableViewController) {
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
}
