//
//  SpecialtySelectorViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/01/2025.
//

import UIKit

protocol SpecialtySelectorDelegate: AnyObject {
    func specialtySelectorDidSelect(_ specialty: AllSpeciality)
    func specialtySelectorDidCancel()
}

class SpecialtySelectorViewController: UIViewController {
    // MARK: - Properties
    private var apiClient = APIClient()
    private var cancellables = Set<AnyCancellable>()
    private var allSpecialties: [AllSpeciality] = []
    private var filteredSpecialties: [AllSpeciality] = []
    weak var delegate: SpecialtySelectorDelegate?
    
    // MARK: - UI Components
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = AppLocalizedKeys.searchForSpeciality.localized
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "SpecialtyCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchSpecialties()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = AppLocalizedKeys.selectSpeciality.localized
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle.fill"), // Use a system image or replace with a valid custom image
            style: .done,
            target: self,
            action: #selector(cancelTapped)
        )
        
        navigationItem.leftBarButtonItem?.tintColor = .grey6B7280
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Data Fetching
    private func fetchSpecialties() {
        let router = APIRouter.fetchSpecialities(isPaginate: 0)
        
        apiClient.fetchAllPages(from: router.url, as: AllSpecialityResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.showError("Failed to fetch Specialities: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] response in
                self?.allSpecialties = response
                self?.filteredSpecialties = self?.allSpecialties ?? []
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    @objc private func cancelTapped() {
        delegate?.specialtySelectorDidCancel()
        dismiss(animated: true)
    }
    
    private func filterSpecialties(_ searchText: String) {
        if searchText.isEmpty {
            filteredSpecialties = allSpecialties
        } else {
            filteredSpecialties = allSpecialties.filter { specialty in
                let searchLowercased = searchText.lowercased()
                return specialty.nameEn.lowercased().contains(searchLowercased) ||
                       specialty.nameAr.lowercased().contains(searchLowercased) ||
                       specialty.name.lowercased().contains(searchLowercased)
            }
        }
        tableView.reloadData()
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate & DataSource
extension SpecialtySelectorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSpecialties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialtyCell", for: indexPath)
        let specialty = filteredSpecialties[indexPath.row]
        
        // Configure cell based on language
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
            cell.textLabel?.text = specialty.nameAr
        } else {
            cell.textLabel?.text = specialty.nameEn
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSpecialty = filteredSpecialties[indexPath.row]
        delegate?.specialtySelectorDidSelect(selectedSpecialty)
        dismiss(animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SpecialtySelectorViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterSpecialties(searchText)
    }
}
