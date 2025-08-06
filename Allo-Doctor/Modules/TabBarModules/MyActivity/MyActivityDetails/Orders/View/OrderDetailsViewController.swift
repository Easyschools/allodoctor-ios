//
//  OrderDetailsViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/01/2025.
//

import UIKit
import Kingfisher
class OrderDetailsViewController: BaseViewController<OrderDetailsViewModel> {
    @IBOutlet weak var productsCollectionView: UICollectionView!

    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var totalPrice: CairoRegular!
    @IBOutlet weak var deleviryFees: CairoRegular!
    @IBOutlet weak var orderQuantity: CairoRegular!
    @IBOutlet weak var pharmacyName: CairoSemiBold!
    @IBOutlet weak var pharmacyImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func addReviewAndCancelButton(_ sender: Any) {
    }
    override func setupUI() {
       setupCollectionView()
        setupViewUI()
    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
 
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    override func bindViewModel() {
        bindProductsData()
        
    }
    @IBAction func dimissButton(_ sender: Any) {
//        viewModel.dissmissView(viewController: self)
    }
    
    @IBAction func proceedToCheckOutAction(_ sender: Any) {
//        viewModel.navToCheckOut()
    }

}
extension OrderDetailsViewController{

    private func setupViewUI(){
        let pharmacyCartData = viewModel.order
        if let imageUrlString = pharmacyCartData?.pharmacy?.mainImage,
           let imageUrl = URL(string: imageUrlString) {
            pharmacyImage.kf.setImage(with: imageUrl,
                                      placeholder: UIImage(named: "placeholder"),
                                      options: [.transition(.fade(0.2))])
        } else {
            pharmacyImage.image = UIImage(named: "placeholder") // Fallback to a placeholder image
        }
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
          
            pharmacyName.text = pharmacyCartData?.pharmacy?.nameAr
            
        }
        else{
            pharmacyName.text = pharmacyCartData?.pharmacy?.nameEn
            
        }
        orderQuantity.text = pharmacyCartData?.cartItems?.count.toString()
        if pharmacyCartData?.pharmacy?.deliveryfees?.toInt() == 0 {
            deleviryFees.text = AppLocalizedKeys.zero.localized
        }
        else {
            deleviryFees.text = pharmacyCartData?.pharmacy?.deliveryfees?.appendingWithSpace(AppLocalizedKeys.EGP.localized)
        }
        totalPrice.text = pharmacyCartData?.total?.appendingWithSpace(AppLocalizedKeys.EGP.localized)
//        totalPrice.text = (
//            pharmacyCartData?.total ?? "0").prepend(AppLocalizedKeys.total.localized, separator: ":").appendingWithSpace(AppLocalizedKeys.EGP.localized)
        orderQuantity.text = pharmacyCartData?.cartItems?.first?.quantity?.toString()
    }
    
}

extension OrderDetailsViewController{
    private func bindProductsData(){
        viewModel.$order
            .receive(on: DispatchQueue.main)
            .sink { pharmacies in
                self.setupViewUI()
                self.productsCollectionView.reloadData()
            }.store(in: &cancellables)
    }
}
extension OrderDetailsViewController{

    private func setupCollectionView(){
        productsCollectionView.registerCell(cellClass: OrderProductsCollectionViewCell.self)
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
    }
}
extension OrderDetailsViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.order?.cartItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ordersData = viewModel.order?.cartItems?[indexPath.row]
       let cell = collectionView.dequeue(indexpath: indexPath) as OrderProductsCollectionViewCell
        let isArabic = UserDefaultsManager.sharedInstance.getLanguage() == .ar
        let medication = ordersData?.medication
        let pharmacy = ordersData?.medicationPharmacy

        let name = isArabic ? (medication?.nameAr ?? "") : (medication?.nameEn ?? "")
        let imageUrl = medication?.mainImage ?? ""
        let quantity = ordersData?.quantity?.toString() ?? ""
            
        // Check if price after discount exists
        let price = pharmacy?.priceAfterDiscount ?? pharmacy?.price ?? ""

        cell.configureCell(name: name, price: price, quantity: quantity, imageUrl: imageUrl)

        cell.applyDropShadow()
        return cell
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
           return UIEdgeInsets(top: 16, left: 16, bottom: 20, right: 16)
       }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.bounds.width - 32
            return CGSize(width: width, height: 120)
        }
     
}
