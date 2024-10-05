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
        viewModel.fetchClincs()

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
        return viewModel.clinics?.info_service.count ?? 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClinicSearchScreenCollectionViewCell", for: indexPath) as? ClinicSearchScreenCollectionViewCell else {
            fatalError("Unable to dequeue DoctorSearchCollectionViewCell")
        }
        let clinic = viewModel.clinics?.info_service[indexPath.row]
        cell.ClinicName.text = clinic?.name_en
        cell.ClinicTitle.text = clinic?.name_en
        cell.clinicImage.kf.setImage(with:URL(string: clinic?.image ?? ""))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let clinicID = viewModel.clinics?.info_service[indexPath.row].id
     
        viewModel.navToClinicProfile(clinicID: String(clinicID!))
    }
}
extension ClinicSearchScreenViewController{
    private func bindClinicCollectionView() {
        viewModel.$clinics
            .receive(on: DispatchQueue.main)
            .sink { [weak self] clincs in
                self?.clinicsCollectionView.reloadData()
            }.store(in: &cancellables)
    }
}
