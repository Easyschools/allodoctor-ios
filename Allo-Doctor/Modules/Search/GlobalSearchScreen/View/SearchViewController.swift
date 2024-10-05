//
//  SearchViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 15/09/2024.
//

import UIKit
import Combine

class SearchViewController: BaseViewController<SearchViewModel> {
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: SearchView!
    @IBOutlet weak var citiesDropDownVIew: CustomDropDownList!
    @IBOutlet weak private var searchTableView: UITableView!
    @IBOutlet weak private var upperView: UIView!
    
    @IBOutlet weak var searchResultLabel: CairoSemiBold!
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBackTo()
        viewModel.coordinator?.navigationController.popViewController(animated: true)
    }
    
    private var citiesArr: [City] = []
    var cityNames: [String] = []
    private var filteredSpecialties: [Specialty] = []
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
     
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
        citiesDropDownVIew.label.text = "Select city"
    }
    
    override func bindViewModel() {
        viewModel.fetchSpecialties(id: 1)
        viewModel.fetchCities()
        bindSpeciality()
        bindCities()
        bindSearchResults()
    }
    
    private func setupSearchBar() {
        searchBar.searchTextfield.textPublisher()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.viewModel.searchText = searchText
            }
            .store(in: &cancellables)
    }
}

// MARK: - TableView Setup
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResult.isEmpty ? filteredSpecialties.count : viewModel.searchResult.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchTableViewCell = tableView.dequeue(indexPath: indexPath)
        
        if viewModel.searchResult.isEmpty {
            let specialty = filteredSpecialties[indexPath.row]
            cell.cellLabel.text = specialty.nameEn
        } else {
            let searchResult = viewModel.searchResult[indexPath.row]
            cell.cellLabel.text = searchResult.name
            cell.searchedItemType.text = searchResult.type
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.searchResult[indexPath.row].type == "doctor"{
            let doctorid =  viewModel.searchResult[indexPath.row].id
            viewModel.navToDoctor(id:String(doctorid))
        }
        else{
            viewModel.navtoDoctorSearch()}
    }
    
    private func setupTableView() {
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.registerCell(cellClass: SearchTableViewCell.self)
        searchTableView.separatorStyle = .none
        searchTableView.separatorInset = .zero
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
                self?.cityNames.append(contentsOf: names)
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


