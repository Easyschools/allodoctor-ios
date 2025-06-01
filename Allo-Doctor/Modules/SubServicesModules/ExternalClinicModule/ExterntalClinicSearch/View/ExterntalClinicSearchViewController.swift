//
//  ExterntalClinicSearchViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 13/11/2024.
//

import UIKit

class ExterntalClinicSearchViewController: BaseViewController<ExterntalClinicSearchViewModel> {
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var searchBar: SearchView!
    @IBOutlet weak var navButton: CustomNavigationBackButton!
    @IBOutlet weak var searchedLableTitle: CairoBold!
    @IBOutlet weak var externalClinicsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        setupSearchBar()
        setupTableView()
        
    }
    
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    override func bindViewModel() {
        searchBar.searchTextfield.placeholder = AppLocalizedKeys.SearchForAnyOutPatientClinic.localized
        viewModel.setupSearchSubscription()
        bindOperations()
    }
    
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft, .bottomRight], radius: 25)
    }
}

// MARK: - TableView Setup
extension ExterntalClinicSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.externalClinics?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let externalClinicId = viewModel.externalClinics?[indexPath.row].id ?? 0
         viewModel.navToClinicHospitals(externalClinicId: externalClinicId)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchScreenTableViewCell = tableView.dequeue(indexPath: indexPath)
        if UserDefaultsManager.sharedInstance.getLanguage() == .en{
            cell.setup(withLabelName: viewModel.externalClinics?[indexPath.row].nameEn ?? "")}
        else {
            cell.setup(withLabelName: viewModel.externalClinics?[indexPath.row].nameAr ?? "")
        }
        cell.selectionStyle = .none
        return cell
    }
    

   
    private func setupTableView() {
        externalClinicsTableView.dataSource = self
        externalClinicsTableView.delegate = self
        externalClinicsTableView.registerCell(cellClass: SearchScreenTableViewCell.self)
        externalClinicsTableView.separatorStyle = .none
        externalClinicsTableView.separatorInset = .zero
        externalClinicsTableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 8, right: 0)
    }
}

// MARK: - Data Binding
extension ExterntalClinicSearchViewController {
    private func bindOperations() {
        viewModel.$externalClinics
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.externalClinicsTableView.reloadData()
            }.store(in: &cancellables)
    }
    

    private func setupSearchBar() {
        searchBar.searchTextfield.textPublisher()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.viewModel.searchText = searchText
                self?.viewModel.clearSearchResults()
                self?.searchedLableTitle.text = searchText.isEmpty ? AppLocalizedKeys.ExterntalClinic.localized : AppLocalizedKeys.searchResults.localized
            }
            .store(in: &cancellables)
    }
}
