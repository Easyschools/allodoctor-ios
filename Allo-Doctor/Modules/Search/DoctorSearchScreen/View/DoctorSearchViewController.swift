//
//  DoctorSearchViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/09/2024.
//

import UIKit


class DoctorSearchViewController: BaseViewController<DoctorSearchViewModel> {
    @IBOutlet weak var lowerStackView: UIStackView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var doctorsCollectionView: UICollectionView!
    @IBOutlet weak var citiesDropList: CustomDropDownList!
    
    @IBOutlet weak var doctorSearchBar: SearchView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchDoctors(searchedText:"")
    }
    
    override func setupUI() {
        super.setupUI()
        setupSearchBar()
        setupCollectionView()
       
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upperView.roundCorners(corners: [.bottomLeft, .bottomRight],
                               radius: Dimensions.upperViewBorderRaduis.rawValue)
    }

    override func bindViewModel() {
        super.bindViewModel()
        bindDoctorCollectionView()
        bindSearchResults()
    }

    @IBAction func navBack(_ sender: Any) {
        viewModel.coordinator?.navigateBack()
    }
}

// MARK: - Collection View Delegate & Data Source
extension DoctorSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setupCollectionView() {
        doctorsCollectionView.delegate = self
        doctorsCollectionView.dataSource = self
        doctorsCollectionView.registerCell(cellClass: DoctorSearchCollectionViewCell.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.doctors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoctorSearchCollectionViewCell", for: indexPath) as? DoctorSearchCollectionViewCell else {
            fatalError("Unable to dequeue DoctorSearchCollectionViewCell")
        }
        
        let doctor = viewModel.doctors[safe: indexPath.row]
        cell.doctorName.text = doctor?.name ?? "Unknown Doctor"
        cell.AdressLabel.text = doctor?.address ?? "Address not available"
        cell.feesLabel.text = doctor?.price ?? "Fees not available"
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 241)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let doctor = viewModel.doctors[safe: indexPath.row] else { return }
        viewModel.navToDoctorProfile(doctorID: String(doctor.id))
    }
}

// MARK: - ViewModel Binding
extension DoctorSearchViewController {
    private func bindDoctorCollectionView() {
        viewModel.$doctors
            .receive(on: DispatchQueue.main)
            .sink { [weak self] doctors in
                print("Received \(doctors.count) doctors")
                self?.doctorsCollectionView.reloadData()
            }.store(in: &cancellables)
    }
    private func setupSearchBar() {
        doctorSearchBar.searchTextfield.placeholder = "Search for doctor or hospital"
        doctorSearchBar.searchTextfield.textPublisher()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.viewModel.searchText = searchText
            }
            .store(in: &cancellables)
    }
    func bindSearchResults() {
        viewModel.$doctors
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.doctorsCollectionView.reloadData()
            }.store(in: &cancellables)
    }
}

// MARK: - Safe Array Access Extension
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
