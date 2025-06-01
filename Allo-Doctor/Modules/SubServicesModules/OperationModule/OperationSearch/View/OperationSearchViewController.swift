//
//  OperationSearchViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 13/11/2024.
//

import UIKit

class OperationSearchViewController: BaseViewController<OperationSearchViewModel> {
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchResultLabel: CairoBold!
    @IBOutlet weak var searchBar: SearchView!
    
    private var isLoadingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func setupUI() {
        setupSearchBar()
        setupTableView()
    }
    
    override func bindViewModel() {
        bindOperations()
        bindLoadingState()
        viewModel.getOperations(searchedText: "")
        viewModel.setupSearchSubscription()
    }
    
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft, .bottomRight], radius: 25)
    }
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
}

// MARK: - TableView Setup
extension OperationSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.operations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchScreenTableViewCell = tableView.dequeue(indexPath: indexPath)
        cell.setup(withLabelName: viewModel.operations?[indexPath.row].nameEn ?? "")
        cell.selectionStyle = .none
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.bounds.size.height
        
        // Load more when user scrolls to bottom (with some threshold)
        if position > contentHeight - scrollViewHeight - 100 {
            viewModel.loadMoreOperations()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let operationId = viewModel.operations?[indexPath.row].id else {return}
        viewModel.navToOperationHospitals(operationID: operationId)
    }
    private func setupTableView() {
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.registerCell(cellClass: SearchScreenTableViewCell.self)
        searchTableView.separatorStyle = .none
        searchTableView.separatorInset = .zero
        searchTableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
}

// MARK: - Data Binding
extension OperationSearchViewController {
    private func bindOperations() {
        viewModel.$operations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.searchTableView.reloadData()
            }.store(in: &cancellables)
    }
    
    private func bindLoadingState() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.isLoadingMore = isLoading
            }.store(in: &cancellables)
    }
    private func setupSearchBar() {
        searchBar.searchTextfield.placeholder = AppLocalizedKeys.searchForAnyOperation.localized
        searchBar.searchTextfield.textPublisher()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.viewModel.searchText = searchText
                self?.viewModel.clearSearchResults()
                self?.searchResultLabel.text = searchText.isEmpty ? "Operations" : "Search Results"
                self?.searchTableView.reloadData()
            }
            .store(in: &cancellables)
    }

}
