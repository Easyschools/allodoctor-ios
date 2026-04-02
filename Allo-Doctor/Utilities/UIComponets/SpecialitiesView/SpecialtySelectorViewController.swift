//
//  SpecialtySelectorViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/01/2025.
//

import UIKit
import Combine

enum SpecialtySelectorMode {
    case allSpecialties // Fetch all specialties from API
    case hospitalSpecialties(hospitalId: Int, specialties: [Specialty], coordinator: HomeCoordinatorContact) // Display specific hospital's specialties
}

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

    // Hospital-specific properties
    private var displayMode: SpecialtySelectorMode = .allSpecialties
    private var hospitalSpecialties: [Specialty] = []
    private var filteredHospitalSpecialties: [Specialty] = []
    
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
    
    // MARK: - Initializers
    convenience init(mode: SpecialtySelectorMode) {
        self.init(nibName: nil, bundle: nil)
        self.displayMode = mode

        // If hospital mode, extract specialties
        if case .hospitalSpecialties(_, let specialties, _) = mode {
            self.hospitalSpecialties = specialties
            self.filteredHospitalSpecialties = specialties
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Fetch specialties only in all specialties mode
        switch displayMode {
        case .allSpecialties:
            fetchSpecialties()
        case .hospitalSpecialties:
            tableView.reloadData()
        }
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
                // Remove duplicates based on ID
                var uniqueSpecialties: [AllSpeciality] = []
                var seenIds: Set<Int> = []
                for specialty in response {
                    if let id = specialty.id, !seenIds.contains(id) {
                        uniqueSpecialties.append(specialty)
                        seenIds.insert(id)
                    }
                }
                self?.allSpecialties = uniqueSpecialties
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
        switch displayMode {
        case .allSpecialties:
            if searchText.isEmpty {
                filteredSpecialties = allSpecialties
            } else {
                filteredSpecialties = allSpecialties.filter { specialty in
                    let searchLowercased = searchText.lowercased()
                    return specialty.nameEn?.lowercased().contains(searchLowercased) ?? true ||
                    ((specialty.nameAr?.lowercased().contains(searchLowercased)) != nil) ||
                    ((specialty.name?.lowercased().contains(searchLowercased)) != nil)
                }
            }

        case .hospitalSpecialties:
            if searchText.isEmpty {
                filteredHospitalSpecialties = hospitalSpecialties
            } else {
                filteredHospitalSpecialties = hospitalSpecialties.filter { specialty in
                    let searchLowercased = searchText.lowercased()
                    let language = UserDefaultsManager.sharedInstance.getLanguage()
                    let name = language == .ar ? (specialty.nameAr ?? specialty.name ?? "") : (specialty.nameEn ?? specialty.name ?? "")
                    return name.lowercased().contains(searchLowercased)
                }
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
        switch displayMode {
        case .allSpecialties:
            return filteredSpecialties.count
        case .hospitalSpecialties:
            return filteredHospitalSpecialties.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialtyCell", for: indexPath)

        // Configure cell based on language and mode
        let language = UserDefaultsManager.sharedInstance.getLanguage()

        switch displayMode {
        case .allSpecialties:
            let specialty = filteredSpecialties[indexPath.row]
            cell.textLabel?.text = language == .ar ? specialty.nameAr : specialty.nameEn

        case .hospitalSpecialties:
            let specialty = filteredHospitalSpecialties[indexPath.row]
            cell.textLabel?.text = language == .ar ? (specialty.nameAr ?? specialty.name) : (specialty.nameEn ?? specialty.name)
        }

        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch displayMode {
        case .allSpecialties:
            let selectedSpecialty = filteredSpecialties[indexPath.row]
            delegate?.specialtySelectorDidSelect(selectedSpecialty)
            dismiss(animated: true)

        case .hospitalSpecialties(let hospitalId, _, let coordinator):
            let selectedSpecialty = filteredHospitalSpecialties[indexPath.row]
            // Navigate to doctors for this hospital and specialty
            coordinator.showDoctorsForHospital(hospitalId: hospitalId, specialtyId: selectedSpecialty.id, serviceId: nil, externalClinicServiceId: nil)
        }
    }
}

// MARK: - UISearchBarDelegate
extension SpecialtySelectorViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterSpecialties(searchText)
    }
}
