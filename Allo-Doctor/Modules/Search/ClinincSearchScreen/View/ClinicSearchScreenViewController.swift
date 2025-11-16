//
//  ClinicSearchScreenViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/09/2024.
//

import UIKit
import Kingfisher
class ClinicSearchScreenViewController: BaseViewController<ClinicSearchScreenViewModel> {
    @IBOutlet weak var upperView: UIView!
    
    @IBOutlet weak var citiesDropDownList: CustomDropDownList!
    @IBOutlet weak var clinicsSearchBar: SearchView!
    @IBOutlet weak var clinicsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Only fetch clinics if in clinics mode
        switch viewModel.displayMode {
        case .clinics:
            viewModel.fetchClincs()
        case .hospitalSpecialties:
            break // Specialties already loaded in ViewModel
        }
    }
    override func setupUI() {
        setupCollectionView()
    }
    override func bindViewModel() {
        bindClinicCollectionView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upperView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: Dimensions.upperViewBorderRaduis.rawValue)
    }

    @IBAction func navBackAvtion(_ sender: Any) {
        viewModel.coordinator?.navigateBack()
    }
    

}
extension ClinicSearchScreenViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setupCollectionView() {
        clinicsCollectionView.delegate = self
        clinicsCollectionView.dataSource = self
        clinicsCollectionView.registerCell(cellClass: ClinicSearchScreenCollectionViewCell.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel.displayMode {
        case .clinics:
            return viewModel.clinics?.info_service?.count ?? 0
        case .hospitalSpecialties:
            return viewModel.filteredSpecialties.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClinicSearchScreenCollectionViewCell", for: indexPath) as? ClinicSearchScreenCollectionViewCell else {
            fatalError("Unable to dequeue ClinicSearchScreenCollectionViewCell")
        }

        switch viewModel.displayMode {
        case .clinics:
            let clinic = viewModel.clinics?.info_service?[indexPath.row]
            cell.ClinicName.text = clinic?.name_en
            cell.ClinicTitle.text = clinic?.name_en
            cell.clinicImage.kf.setImage(with:URL(string: clinic?.image ?? ""))

        case .hospitalSpecialties:
            let specialty = viewModel.filteredSpecialties[indexPath.row]
            cell.configure(specialty: specialty)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.displayMode {
        case .clinics:
            return CGSize(width: collectionView.frame.width, height: 200)
        case .hospitalSpecialties:
            return CGSize(width: collectionView.frame.width, height: 60)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.displayMode {
        case .clinics:
            if let clinicID = viewModel.clinics?.info_service?[indexPath.row].id {
                viewModel.navToClinicProfile(clinicID: String(clinicID))
            } else {
                print("Error: clinicID is nil.")
            }

        case .hospitalSpecialties:
            let specialty = viewModel.filteredSpecialties[indexPath.row]
            viewModel.navigateToSpecialty(specialty: specialty)
        }
    }
}
extension ClinicSearchScreenViewController{
    private func bindClinicCollectionView() {
        // Bind clinics data
        viewModel.$clinics
            .receive(on: DispatchQueue.main)
            .sink { [weak self] clincs in
                self?.clinicsCollectionView.reloadData()
            }.store(in: &cancellables)

        // Bind filtered specialties
        viewModel.$filteredSpecialties
            .receive(on: DispatchQueue.main)
            .sink { [weak self] specialties in
                self?.clinicsCollectionView.reloadData()
            }.store(in: &cancellables)

        // Bind search text to viewModel
        clinicsSearchBar.searchTextfield.textPublisher()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.viewModel.searchText = searchText
            }
            .store(in: &cancellables)
    }
}
