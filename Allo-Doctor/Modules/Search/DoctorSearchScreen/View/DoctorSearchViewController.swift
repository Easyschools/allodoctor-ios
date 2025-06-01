//
//  DoctorSearchViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/09/2024.
//

import UIKit


class DoctorSearchViewController: BaseViewController<DoctorSearchViewModel> {
    @IBOutlet weak private var lowerStackView: UIStackView!
    @IBOutlet weak var noSearchPlaceHolder: UIStackView!
    @IBOutlet weak private var upperView: UIView!
    @IBOutlet weak private var doctorsCollectionView: UICollectionView!
    @IBOutlet weak private var citiesDropList: CustomDropDownList!
    @IBOutlet weak private var doctorSearchBar: SearchView!
    @IBOutlet weak var navBackButton: CustomNavigationBackButton!
    // MARK: - Life Cycle/
  
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
  
    override func setupUI() {
        super.setupUI()
        setupSearchBar()
        setupCollectionView()
        citiesDropList.label.text = AppLocalizedKeys.selectArea.localized
        navBackButton.setTitle(AppLocalizedKeys.doctors.localized)
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
        viewModel.fetchDoctors(searchedText: "", sortBy: "", districtId: nil, maxPrice: "", medicalInsuranceId: "", gender: "", title: "")
        viewModel.getAllAreaOfResidence()
        
    }

    @IBAction func selectAreaAction(_ sender: Any) {
        let citiesVC = SectionSearchableTableViewController(cityData: viewModel.cities)
        citiesVC.delegate = self
        viewModel.coordinator?.presentModallyWithRoot(citiesVC)
    }
    @IBAction func filterAction(_ sender: Any) {
        viewModel.presentFiter(viewController: self)
    }
    @IBAction func sortByAction(_ sender: Any) {
        let sortByVC = DoctorSortByViewController()
            
            // Subscribe to the sortOptionSelected subject
            sortByVC.sortOptionSelected
                .sink { [weak self] sortOption in
                    self?.handleSortOption(sortOption)
                }
                .store(in: &cancellables)
            
            // Present the view controller as a fitted sheet
        let sheetController = FWIPNSheetViewController(controller: sortByVC, sizes: [.percent(0.3)])
        sheetController.cornerRadius = 16
        // Present the sheet
        present(sheetController, animated: true, completion: nil)
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
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            cell.doctorName.text = doctor?.nameAr ?? "Unknown Doctor"
        }
        else {
            cell.doctorName.text = doctor?.nameEn ?? "Unknown Doctor"

        }
       
        cell.AdressLabel.text = doctor?.address ?? "Address not available"
        cell.feesLabel.text = doctor?.price ?? "Fees not available"
        if let doctor = viewModel.doctors[safe: indexPath.row] {
              cell.setupCell(with: doctor)
          }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 241)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let doctor = viewModel.doctors[safe: indexPath.row] else { return }
        viewModel.navToDoctorProfile(doctorID: String(doctor.id ?? 0),doctorServiveSpecialityId: 35)
    }
}

// MARK: - ViewModel Binding
extension DoctorSearchViewController {
    private func bindDoctorCollectionView() {
        viewModel.$filters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] doctors in
                self?.doctorsCollectionView.reloadData()
            }.store(in: &cancellables)
        viewModel.$doctors
               .receive(on: DispatchQueue.main)
               .sink { [weak self] doctors in
                   guard let self = self else { return }

                   print("Received \(doctors.count) doctors")

                   let searchText = self.doctorSearchBar.searchTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                   let isSearchTextEmpty = searchText.isEmpty
                   let hasNoResults = doctors.isEmpty

                   // Show the placeholder only if search is not empty and there are no results
                   self.noSearchPlaceHolder.isHidden = isSearchTextEmpty || !hasNoResults

                   self.doctorsCollectionView.reloadData()
               }
               .store(in: &cancellables)
    }
    private func setupSearchBar() {
        doctorSearchBar.searchTextfield.placeholder = AppLocalizedKeys.SearchforDoctor.localized
        doctorSearchBar.searchTextfield.textPublisher()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.viewModel.searchText = searchText
            }
            .store(in: &cancellables)
    }
private func bindSearchResults() {
        viewModel.$doctors
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.doctorsCollectionView.reloadData()
            }.store(in: &cancellables)
    }
private func handleSortOption(_ sortOption: SortOption) {
           switch sortOption {
           case .priceHighToLow:
               viewModel.fetchDoctors(searchedText: "", sortBy: sortOption.rawValue, districtId: nil, maxPrice: "", medicalInsuranceId: "", gender: "", title: "")
               doctorsCollectionView.reloadData()
           case .priceLowToHigh:
               viewModel.fetchDoctors(searchedText: "", sortBy: sortOption.rawValue, districtId: nil, maxPrice: "", medicalInsuranceId: "", gender: "", title: "")
               doctorsCollectionView.reloadData()
           case .topRated:
               viewModel.fetchDoctors(searchedText: "", sortBy: sortOption.rawValue, districtId: nil, maxPrice: "", medicalInsuranceId: "", gender: "", title: "")
               doctorsCollectionView.reloadData()
           }
       }

private func handleFilterOption(_ sortOption: SortOption) {
           switch sortOption {
           case .priceHighToLow:
               viewModel.fetchDoctors(searchedText: "", sortBy: sortOption.rawValue, districtId: nil, maxPrice: "", medicalInsuranceId: "", gender: "", title: "")
               doctorsCollectionView.reloadData()
           case .priceLowToHigh:
               viewModel.fetchDoctors(searchedText: "", sortBy: sortOption.rawValue, districtId: nil, maxPrice: "", medicalInsuranceId: "", gender: "", title: "")
               doctorsCollectionView.reloadData()
           case .topRated:
               viewModel.fetchDoctors(searchedText: "", sortBy: sortOption.rawValue, districtId: nil, maxPrice: "", medicalInsuranceId: "", gender: "", title: "")
               doctorsCollectionView.reloadData()
           }
       }
}

// MARK: - Safe Array Access Extension
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
extension DoctorSearchViewController:SectionSearchableTableViewControllerDelegate {
    func sectionSearchableTableViewController(_ controller: SectionSearchableTableViewController, didSelectDistrictWithID id: Int, districtName name: String) {
        citiesDropList.label.text = name
//        selectAreaLabel.text = name
//        viewModel.districtId.value = id
        //            isCitySelected = true
        viewModel.fetchDoctors(searchedText:"", sortBy: "", districtId: id, maxPrice: "", medicalInsuranceId: "", gender: "", title: "")
        doctorsCollectionView.reloadData()
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
    
    func sectionSearchableTableViewControllerDidTapDismiss(_ controller: SectionSearchableTableViewController) {
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
}
