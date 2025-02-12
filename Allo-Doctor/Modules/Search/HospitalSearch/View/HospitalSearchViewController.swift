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
            return 2
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabsCollectionViewCell", for: indexPath) as? LabsCollectionViewCell else {
                fatalError("Unable to dequeue DoctorSearchCollectionViewCell")
            }
           
//            let data = viewModel.hospitals?.data
//            cell.labsImage.kf.setImage(with:URL(string: data?.image ?? ""))
            
            return cell
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width*0.48, height: 100)
        }
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            viewModel.navToDoctorsSearch()
        }
    }
    extension HospitalSearchViewController{
        private func bindCollectionView() {
            viewModel.$hospitals
                .receive(on: DispatchQueue.main)
                .sink { [weak self] hospitals in
                    self?.hospitalsCollectionVIew.reloadData()
                }.store(in: &cancellables)
        }
    }

