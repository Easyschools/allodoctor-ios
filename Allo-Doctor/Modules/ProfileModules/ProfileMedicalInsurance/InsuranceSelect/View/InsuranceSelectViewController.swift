//
//  InsuranceSelectViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 11/12/2024.
//

import UIKit

class InsuranceSelectViewController: BaseViewController<InsuranceSelectViewModel> {
    @IBOutlet weak var insuranceCollectionView: UICollectionView!
    
    @IBOutlet weak var dynamicHeightCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var upperView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchUserInsurance()
        bindData()
    }
    override func setupUI() {
        setupCollectionView()
    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 25)
        bindCollectionViewHeight()
    }
    @IBAction func addInsurance(_ sender: Any) {
        viewModel.navToAddInsurance()
    }
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
}
extension InsuranceSelectViewController{
private func setupCollectionView(){
    insuranceCollectionView.registerCell(cellClass: InsuranceCollectionViewCell.self)
    insuranceCollectionView.delegate = self
    insuranceCollectionView.dataSource = self
    insuranceCollectionView.contentInset = UIEdgeInsets.init(top: 16, left: 0, bottom: 20, right: 0)
}
                        
}
extension InsuranceSelectViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.userInsurance?.count ?? 0
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let data = viewModel.userInsurance?[indexPath.row] else {
    
    return UICollectionViewCell()
    }

   let cell = collectionView.dequeue(indexpath: indexPath) as InsuranceCollectionViewCell
    cell.cornerRadius = 10
    cell.applyDropShadow()
    if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
        cell.configure(name: data.nameAr, imageUrl: data.mainImage)
    }
    else{
        cell.configure(name: data.nameEn, imageUrl: data.mainImage)
         }
    return cell
}

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    if let serviceId = services?.oneDayServices?[indexPath.row].dayService?.id {
//                selectedServiceSubject.send(serviceId)
//            }
    if let userInsurance = viewModel.userInsurance?[indexPath.row] {
        viewModel.navToInsuranceDelete(userInsurance: userInsurance)
    } else {
        print("Invalid index or no insurance data available")
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
        return CGSize(width: width, height: 64)
    }
 private func  bindData(){
      viewModel.$userInsurance
                .receive(on: DispatchQueue.main)
                .sink { [weak self] subServices in
                    self?.insuranceCollectionView.reloadData()
                }.store(in: &cancellables)
        }
    private func bindCollectionViewHeight() {
        insuranceCollectionView.publisher(for: \.contentSize)
            .sink { [weak self] newSize in
                guard let self = self else { return }
                if self.dynamicHeightCollectionViewConstraint.constant != newSize.height {
                    self.dynamicHeightCollectionViewConstraint.constant = newSize.height + 30
                    self.view.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
    }
    }
 

