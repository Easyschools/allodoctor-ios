//
//  HospitalSpecialtiesViewController.swift
//  Allo-Doctor
//
//  Created by Assistant on 15/11/2025.
//

import UIKit
import Combine

class HospitalSpecialtiesViewController: BaseViewController<HospitalSpecialtiesViewModel> {
    // MARK: - UI Components
    private let upperView: CustomCornerRaduis = {
        let view = CustomCornerRaduis()
        view.backgroundColor = .darkBlue_295DA8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let backButton: CustomNavigationBackButton = {
        let button = CustomNavigationBackButton()
        button.setTitle(AppLocalizedKeys.selectSpeciality.localized)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let searchBar: SearchView = {
        let searchBar = SearchView()
        searchBar.searchTextfield.placeholder = AppLocalizedKeys.searchForSpeciality.localized
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppLocalizedKeys.AllSpecialities.localized
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .greishWhiteF2F2F2
        table.separatorStyle = .singleLine
        table.rowHeight = 60
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        view.backgroundColor = .greishWhiteF2F2F2

        // Add subviews
        view.addSubview(upperView)
        view.addSubview(backButton)
        view.addSubview(searchBar)
        view.addSubview(sectionTitleLabel)
        view.addSubview(tableView)

        // Setup back button action
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        // Setup table view
        setupTableView()

        // Layout constraints
        NSLayoutConstraint.activate([
            // Upper view
            upperView.topAnchor.constraint(equalTo: view.topAnchor),
            upperView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            upperView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            upperView.heightAnchor.constraint(equalToConstant: 200),

            // Back button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.heightAnchor.constraint(equalToConstant: 44),

            // Search bar
            searchBar.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 50),

            // Section title
            sectionTitleLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Table view
            tableView.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upperView.roundCorners([.bottomLeft, .bottomRight], radius: 30)
    }

    override func bindViewModel() {
        super.bindViewModel()

        // Bind filtered specialties
        viewModel.$filteredSpecialties
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        // Bind search text
        searchBar.searchTextfield.textPublisher()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.viewModel.searchText = searchText
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions
    @objc private func backButtonTapped() {
        viewModel.navigateBack()
    }

    // MARK: - Setup
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        // Register cell with value1 style to support detail text label
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SpecialtyCell")
    }
}

// MARK: - UITableViewDelegate & DataSource
extension HospitalSpecialtiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredSpecialties.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SpecialtyCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "SpecialtyCell")
        }

        guard let cell = cell else {
            return UITableViewCell()
        }

        let specialty = viewModel.filteredSpecialties[indexPath.row]

        // Configure cell based on language
        let language = UserDefaultsManager.sharedInstance.getLanguage()
        cell.textLabel?.text = language == .ar ? (specialty.nameAr ?? specialty.name) : (specialty.nameEn ?? specialty.name)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        cell.textLabel?.textColor = .black

        // Add detail label for "Speciality" text
        cell.detailTextLabel?.text = AppLocalizedKeys.Speciality.localized
        cell.detailTextLabel?.textColor = .lightGray
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        // Add chevron
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .white

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedSpecialty = viewModel.filteredSpecialties[indexPath.row]
        viewModel.navigateToSpecialty(specialty: selectedSpecialty)
    }
}
