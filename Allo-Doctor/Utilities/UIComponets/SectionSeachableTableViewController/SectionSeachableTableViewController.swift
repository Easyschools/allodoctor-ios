//
//  SectionSeachableTableViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/12/2024.
//

import UIKit


protocol SectionSearchableTableViewControllerDelegate: AnyObject {
    func sectionSearchableTableViewController(_ controller: SectionSearchableTableViewController, didSelectDistrictWithID id: Int, districtName name: String)
    func sectionSearchableTableViewControllerDidTapDismiss(_ controller: SectionSearchableTableViewController)
}

class SectionSearchableTableViewController: UIViewController {
    
    weak var delegate: SectionSearchableTableViewControllerDelegate?
    
    private var cities: [(name: String, districts: [(id: Int, name: String)])] = []
    private var filteredCities: [(name: String, districts: [(id: Int, name: String)])] = []
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    private lazy var dismissButton: UIBarButtonItem = {
        UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissTapped))
    }()
    
    init(cityData: [City]) {
        super.init(nibName: nil, bundle: nil)
        parseCityData(cityData)
        self.filteredCities = self.cities
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = dismissButton
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    private func parseCityData(_ cityData: [City]) {
        cities = cityData.compactMap { city -> (String, [(id: Int, name: String)])? in
            guard let cityName = city.nameEn ?? city.name else { return nil }
            let districts = city.districts?.compactMap { district -> (Int, String)? in
                guard let districtID = district.id, let districtName = district.nameEn ?? district.name else { return nil }
                return (districtID, districtName)
            } ?? []
            return (cityName, districts)
        }
    }
    
    @objc private func dismissTapped() {
        delegate?.sectionSearchableTableViewControllerDidTapDismiss(self)
    }
}

extension SectionSearchableTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredCities[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities[section].districts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let district = filteredCities[indexPath.section].districts[indexPath.row]
        cell.textLabel?.text = district.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let district = filteredCities[indexPath.section].districts[indexPath.row]
        delegate?.sectionSearchableTableViewController(self, didSelectDistrictWithID: district.id, districtName: district.name)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension SectionSearchableTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCities = cities
        } else {
            filteredCities = cities.map { city in
                let filteredDistricts = city.districts.filter {
                    $0.name.localizedCaseInsensitiveContains(searchText)
                }
                return (city.name, filteredDistricts)
            }.filter { !$0.districts.isEmpty }
        }
        tableView.reloadData()
    }
}
