//
//  OffersBannersViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 17/12/2024.
//

import UIKit

class OffersBannersViewController: BaseViewController<OffersBannersViewModel> {

    @IBOutlet weak var screenTypeLabel: CairoMeduim!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var offersCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }// Do any additional setup after loading the view.
        override func setupUI(){
            setupCollectionView()
            setupViewAccordingToScreenType()
          
        }
        override func bindViewModel() {
            viewModel.getAllOffers()
            bindCollectionView()
           
        }
        override func viewDidLayoutSubviews() {
            upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)

        }


        @IBAction func navBack(_ sender: Any) {
            viewModel.coordinator?.navigateBack()
        }
        

    }
    extension OffersBannersViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        func setupCollectionView() {
            offersCollectionView.delegate = self
            offersCollectionView.dataSource = self
            offersCollectionView.registerCell(cellClass: OffersBannersCollectionViewCell.self)
           

        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel.banners?.count ?? 0
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
               return UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 16)
           }
           
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeue(indexpath: indexPath) as OffersBannersCollectionViewCell
           
            let data = viewModel.banners?[indexPath.row]
            if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
                cell.configure(providerTitle: data?.related?.titleAr ?? "", providerName: data?.related?.nameAr ?? "", offerImageUrl:data?.related?.image , bannerImageUrl: data?.image)
            }
            else{
                cell.configure(providerTitle: data?.related?.titleEn ?? "", providerName: data?.related?.nameEn ?? "", offerImageUrl:data?.related?.image , bannerImageUrl: data?.image)}
            cell.applyDropShadow()
            cell.cornerRadius = 10
            return cell
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.bounds.width - 32
            return CGSize(width: width, height: 136)
        }
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let id = viewModel.banners?[indexPath.row].related?.id
            if viewModel.screenType == "doctor" {
                viewModel.navToDoctor(id: id ?? 0)
            }
            else {
                viewModel.navToPharmacy(id: id ?? 0)
            }
        }
    }
    extension OffersBannersViewController{
        private func bindCollectionView() {
            viewModel.$banners
                .receive(on: DispatchQueue.main)
                .sink { [weak self] banners in
                    self?.offersCollectionView.reloadData()
                }.store(in: &cancellables)
        }
    }
extension OffersBannersViewController{
    func setupViewAccordingToScreenType() {
        if viewModel.screenType == "doctor" {
            screenTypeLabel.text = AppLocalizedKeys.doctors.localized
        }
        else {
            screenTypeLabel.text = "Phamracies"
        }
        
    }
}
