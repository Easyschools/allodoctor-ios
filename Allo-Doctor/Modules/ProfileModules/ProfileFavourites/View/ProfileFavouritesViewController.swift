//
//  ProfileFavouritesViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 26/11/2024.
//

import UIKit

class ProfileFavouritesViewController: BaseViewController<ProfileFavouritesViewModel> {
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var emptyImage: UIImageView!
    @IBOutlet weak var favouritesCollectionView: UICollectionView!
    @IBOutlet weak var favToggleSwitch: CustomToggleSwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyImage.isHidden = true
    }
    override func setupUI() {
        setupCollectionView()
        
    }
    override func bindViewModel() {
        viewModel.fetchDoctorFavourite()
        bindData()
    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
}
extension ProfileFavouritesViewController{
private func setupCollectionView(){
    favouritesCollectionView.registerCell(cellClass: FavouritesCollectionViewCell.self)
    favouritesCollectionView.delegate = self
    favouritesCollectionView.dataSource = self
    favouritesCollectionView.contentInset = UIEdgeInsets.init(top: 16, left: 0, bottom: 20, right: 0)
}
                        
}
extension ProfileFavouritesViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return  viewModel.favData?.data?.count ?? 0
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let data = viewModel.favData?.data?[indexPath.row]
   let cell = collectionView.dequeue(indexpath: indexPath) as FavouritesCollectionViewCell
    cell.cornerRadius = 10
    cell.applyDropShadow()
    if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
        cell.configure(imageUrl:data?.favoritable.mainImage ?? "", title: data?.favoritable.titleAr ?? "", name: data?.favoritable.nameAr ?? "")
    }
    else{  cell.configure(imageUrl:data?.favoritable.mainImage ?? "", title: data?.favoritable.titleEn ?? "", name: data?.favoritable.nameEn ?? "")
         }
    let delete = viewModel.favData?.data?[indexPath.row].favoritableType
    cell.favouriteButtonTapped = { [weak self] in
        self?.viewModel.deleteFav(entity: data?.favoritableType ?? "", favId: data?.favoritableID ?? 0)
           }
    return cell
}

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewModel.favData?.data?[indexPath.row]
        if  data?.favoritableType == "Doctor" {
            viewModel.navToDoctors(doctorID: data?.favoritable.id.toString() ?? "")
        }
        else if data?.favoritableType == "Pharmacy"  {
            viewModel.navToPhramacy(pharmacyId: data?.favoritable.id ?? 0)
        }
    }
func collectionView(_ collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 24
}

func collectionView(_ collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 24
}
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
   }
   
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32
        return CGSize(width: width, height: 124)
    }
 private func  bindData(){

      viewModel.$favData
                .receive(on: DispatchQueue.main)
                .sink { [weak self] subServices in
                    self?.favouritesCollectionView.reloadData()
                    if  self?.viewModel.favData?.data?.count == 0 {
                        self?.emptyImage.isHidden = false
                    }
                }.store(in: &cancellables)
        }
    
    }
 

