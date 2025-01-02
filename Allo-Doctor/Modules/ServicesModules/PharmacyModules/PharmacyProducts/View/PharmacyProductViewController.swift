//
//  PharmacyProductViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 22/10/2024.
//

import UIKit

class PharmacyProductViewController: BaseViewController<PharmacyProductViewModel> {

    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var proceedToBasketView: UIView!
    @IBOutlet weak var noOfItems: CairoRegular!
    @IBOutlet weak var productsStackView: UIStackView!
    @IBOutlet weak var totalPrice: CairoBold!
    @IBOutlet weak var backButton: CustomNavigationBackButton!
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var productsCollectionViewDynamicConstraint: NSLayoutConstraint!
    var addToCartSubject: PassthroughSubject<(Int, Double), Never>?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getProducts()
        viewModel.getGrandTotal()
        setupCollectionView()
        bindProductsData()
        bindGrandTotal()
        grandTotalViewCheck()
        proceedToBasketView.isHidden = true

       
    }
    override func viewDidLayoutSubviews() {
        upperView.applyDropShadow()
    }
    override func setupUI() {
        setupViewControllerUI()
        bindProductsData()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        viewModel.getGrandTotal()
//        bindProductsData()
//        bindGrandTotal()
    
    }
 
    @IBAction func proceedToBasketAction(_ sender: Any) {
        viewModel.navToPharmacyCart()
    }
}
extension PharmacyProductViewController{
    private func setupViewControllerUI() {
        backButton.tintColor = .black
        backButton.setTitleColor(.black, for: .normal)
    }
    private func setupCollectionView(){
        productsCollectionView.registerCell(cellClass: ProductsCollectionViewCell.self)
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
    }

    private func bindCollectionViewHeight() {
        productsCollectionView.publisher(for: \.contentSize)
            .sink { [weak self] newSize in
                guard let self = self else { return }
                if self.productsCollectionViewDynamicConstraint.constant != newSize.height {
                    self.productsCollectionViewDynamicConstraint.constant = newSize.height
                    self.productsCollectionViewDynamicConstraint.constant = self.productsStackView.intrinsicContentSize.height
                    self.view.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
    }
}
extension PharmacyProductViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products?.count ?? 0

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeue(indexpath: indexPath) as ProductsCollectionViewCell
        let product = viewModel.products?[indexPath.row].medication
        cell.setup(with: product?.mainImage ?? "", name: product?.nameEn ?? "", price: product?.price ?? "")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width*0.48, height: 250)
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = viewModel.products?[indexPath.row] else {return}
        vibrate()
        viewModel.productDetailsPresent(product:product)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
// MARK: ViewModel Binding phamrmacies Data
extension PharmacyProductViewController{
    private func bindProductsData(){
        viewModel.$products
            .receive(on: DispatchQueue.main)
            .sink { pharmacies in
                self.productsCollectionView.reloadData()
            }.store(in: &cancellables)
        viewModel.$grandTotalData
            .receive(on: DispatchQueue.main)
            .sink { [self] total in
                totalPrice.text = total?.totalPrice
                noOfItems.text = total?.items.count.toString()
            }.store(in: &cancellables)
    }
    func vibrate() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()

    }
    func bindGrandTotal(){
        addToCartSubject?
                    .sink { [weak self] quantity, price in
                        self?.totalPrice.text = String(price)
                        self?.noOfItems.text = quantity.toString()
                    }
                    .store(in: &cancellables)
    }
   private  func grandTotalViewCheck(){
       if viewModel.grandTotalData?.items.count == 0 {
           proceedToBasketView.isHidden = true
       }
       else {
           proceedToBasketView.isHidden = false
       }
    }
    
}



