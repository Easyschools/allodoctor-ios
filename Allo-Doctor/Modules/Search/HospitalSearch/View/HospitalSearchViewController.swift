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
            hospitalsCollectionVIew.registerCell(cellClass: LabsCollectionViewCell.self)
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            switch viewModel.displayMode {
            case .hospitals:
                return 2  // Hardcoded for now, should be viewModel.hospitals?.data.count ?? 0
            case .specialties:
                return viewModel.filteredSpecialties.count
            }
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabsCollectionViewCell", for: indexPath) as? LabsCollectionViewCell else {
                fatalError("Unable to dequeue LabsCollectionViewCell")
            }

            switch viewModel.displayMode {
            case .hospitals:
                // Display hospital (original behavior)
                // let data = viewModel.hospitals?.data
                // cell.configure(hospital: data)
                break
            case .specialties:
                // Display specialty
                let specialty = viewModel.filteredSpecialties[indexPath.row]
                cell.configure(specialty: specialty)
            }

            return cell
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width*0.48, height: 100)
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            switch viewModel.displayMode {
            case .hospitals:
                viewModel.navToDoctorsSearch()
            case .specialties:
                let specialty = viewModel.filteredSpecialties[indexPath.row]
                viewModel.navigateToSpecialty(specialty: specialty)
            }
        }
    }
    extension HospitalSearchViewController{
        private func bindCollectionView() {
            // Bind hospitals data
            viewModel.$hospitals
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

