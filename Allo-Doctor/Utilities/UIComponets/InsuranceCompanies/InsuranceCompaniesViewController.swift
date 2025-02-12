//
//  InsuranceCompaniesViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 16/12/2024.
//


import UIKit
import Combine

// Define a model for insurance companies
struct InsuranceCompany: Decodable {
    let id: Int
    let name_ar: String
    let name_en: String
}
struct InsuranceResponse: Decodable {
    let data : [InsuranceCompany]?
}
// Protocol for delegation
protocol InsuranceCompanyTableViewControllerDelegate: AnyObject {
    func insuranceCompanyTableViewController(_ controller: InsuranceCompanyTableViewController, didSelectItem item: InsuranceCompany)
    func insuranceCompanyTableViewControllerDidTapDismiss(_ controller: InsuranceCompanyTableViewController)
}

class InsuranceCompanyTableViewController: UIViewController {
    
    weak var delegate: InsuranceCompanyTableViewControllerDelegate?
    let apiClient = APIClient()

    private var items: [InsuranceCompany] = []
    private var filteredItems: [InsuranceCompany] = []
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(.dismissButton, for: .normal)
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchInsuranceCompanies()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(dismissButton)
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            titleLabel.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: dismissButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            searchBar.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func dismissButtonTapped() {
        delegate?.insuranceCompanyTableViewControllerDidTapDismiss(self)
    }
    
    private func fetchInsuranceCompanies() {
        guard let url = URL(string: "https://allodoctor-backend.developnetwork.net/api/admin/medical-insurance/all") else {
            print("Invalid URL")
            return
        }
        apiClient.fetchData(from: url, as: InsuranceResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to fetch data: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] insuranceCompanies in
                print("Response: \(insuranceCompanies)")
                self?.items = insuranceCompanies.data ?? []
                self?.filteredItems = insuranceCompanies.data ?? []
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)

    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}

extension InsuranceCompanyTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = filteredItems[indexPath.row]
        cell.textLabel?.text = "\(item.name_en) (\(item.name_ar))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = filteredItems[indexPath.row]
        delegate?.insuranceCompanyTableViewController(self, didSelectItem: selectedItem)
    }
}

extension InsuranceCompanyTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter {
                $0.name_en.lowercased().contains(searchText.lowercased()) ||
                $0.name_ar.contains(searchText)
            }
        }
        tableView.reloadData()
    }
}
