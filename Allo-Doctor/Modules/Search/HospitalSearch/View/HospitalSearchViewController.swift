//
//  HospitalSearchViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 30/09/2024.
//

import UIKit

class HospitalSearchViewController: BaseViewController<HospitalSearchViewModel> {
    @IBOutlet weak var upperView: CustomCornerRaduis!
    @IBOutlet weak var searchBar: SearchView!
        
    @IBOutlet weak var hospitalsCollectionVIew: UICollectionView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
          
           
        }
        override func setupUI(){
            setupCollectionView()
        }
        override func bindViewModel() {
            viewModel.fetchHospitals()
            bindCollectionView()
        }
        override func viewDidLayoutSubviews() {
            upperView.roundCorners([.bottomLeft,.bottomRight], radius: 30)
        }


        @IBAction func navBack(_ sender: Any) {
            viewModel.coordinator?.navigateBack()
        }
        

    }
    extension HospitalSearchViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        func setupCollectionView() {
            hospitalsCollectionVIew.delegate = self
            hospitalsCollectionVIew.dataSource = self
            // Register cell for hospitals (full-width cards with background image)
            hospitalsCollectionVIew.registerCell(cellClass: ExternalClinicHospitalsCollectionViewCell.self)
            // Register cell for specialties (2-column grid)
            hospitalsCollectionVIew.registerCell(cellClass: LabsCollectionViewCell.self)
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            switch viewModel.displayMode {
            case .hospitals:
                return viewModel.filteredHospitals.count
            case .specialties:
                return viewModel.filteredSpecialties.count
            }
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            switch viewModel.displayMode {
            case .hospitals:
                // Display hospital with full-width card
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExternalClinicHospitalsCollectionViewCell", for: indexPath) as? ExternalClinicHospitalsCollectionViewCell else {
                    fatalError("Unable to dequeue ExternalClinicHospitalsCollectionViewCell")
                }
                let hospital = viewModel.filteredHospitals[indexPath.row]
                cell.setupCell(hospital: hospital)
                return cell

            case .specialties:
                // Display specialty with 2-column grid
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabsCollectionViewCell", for: indexPath) as? LabsCollectionViewCell else {
                    fatalError("Unable to dequeue LabsCollectionViewCell")
                }
                let specialty = viewModel.filteredSpecialties[indexPath.row]
                cell.configure(specialty: specialty)
                return cell
            }
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            switch viewModel.displayMode {
            case .hospitals:
                // Full-width vertical cards for hospitals
                let width = collectionView.bounds.width - 32 // 16pt padding on each side
                return CGSize(width: width, height: 140)
            case .specialties:
                // 2-column grid for specialties
                return CGSize(width: collectionView.frame.width*0.48, height: 100)
            }
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            switch viewModel.displayMode {
            case .hospitals:
                let hospital = viewModel.filteredHospitals[indexPath.row]
                viewModel.navigateToHospitalFromList(hospital: hospital)
            case .specialties:
                let specialty = viewModel.filteredSpecialties[indexPath.row]
                viewModel.navigateToSpecialty(specialty: specialty)
            }
        }
    }
    extension HospitalSearchViewController{
        private func bindCollectionView() {
            // Bind filtered hospitals data (for hospitals mode)
            viewModel.$filteredHospitals
                .receive(on: DispatchQueue.main)
                .sink { [weak self] hospitals in
                    self?.hospitalsCollectionVIew.reloadData()
                }.store(in: &cancellables)

            // Bind specialties data (for specialties mode)
            viewModel.$filteredSpecialties
                .receive(on: DispatchQueue.main)
                .sink { [weak self] specialties in
                    self?.hospitalsCollectionVIew.reloadData()
                }.store(in: &cancellables)

            // Bind search text to viewModel
            searchBar.searchTextfield.textPublisher()
                .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
                .removeDuplicates()
                .sink { [weak self] searchText in
                    self?.viewModel.searchText = searchText
                }
                .store(in: &cancellables)
        }
    }

