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
    @IBOutlet weak var searchTextfield: SearchView!
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
        
    }
    override func viewDidLayoutSubviews() {
    }
    override func setupUI() {
        setupViewControllerUI()
        bindProductsData()
         setupSearchBar()
     

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getGrandTotal()
        grandTotalViewCheck()
    }
 
    @IBAction func navBack(_ sender: Any) {
        viewModel.navBack()
    }
    @IBAction func proceedToBasketAction(_ sender: Any) {
        proceedToBasketView.isHidden = true
        viewModel.grandTotalData = nil
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
        let product = viewModel.products?[indexPath.row]
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            cell.setup(with: product?.mainImage ?? "", name: product?.nameAr ?? "", price: product?.medicationPharmacies?[0].price ?? "")}
        else {  cell.setup(with: product?.mainImage ?? "", name: product?.nameEn ?? "", price: product?.medicationPharmacies?[0].price ?? "")}
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width*0.48, height: 250)
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = viewModel.products?[indexPath.row] else {return}
        vibrate()
        viewModel.productDetailsPresent(product:product, viewController: self)
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
    private func checkGrandTotal(){
        
      
             
    }
    private func bindProductsData(){
        viewModel.$products
            .receive(on: DispatchQueue.main)
            .sink { pharmacies in
                self.productsCollectionView.reloadData()
            }.store(in: &cancellables)
        viewModel.$grandTotalData
            .receive(on: DispatchQueue.main)
            .sink { [self] total in
                if total?.totalQuantity == nil {
                    proceedToBasketView.isHidden = true
                }
                else{
                    proceedToBasketView.isHidden = false
                    totalPrice.text = (total?.totalPrice ?? "Zero").appendingWithSpace(AppLocalizedKeys.EGP.localized)
                    noOfItems.text = total?.totalQuantity.toString().prepend(AppLocalizedKeys.quantity.localized, separator: " ")
                }
              
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
       
       proceedToBasketView.isHidden = (viewModel.grandTotalData?.totalQuantity == nil)
       
    }
    
    private func setupSearchBar() {
        searchTextfield.searchTextfield.placeholder = AppLocalizedKeys.searchForAnyProduct.localized
        searchTextfield.searchTextfield.textPublisher()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.viewModel.searchText = searchText
            }
            .store(in: &cancellables)
    }
}
extension PharmacyProductViewController:addToCartTapped{
    internal  func didTapButton() {
        viewModel.getGrandTotal()
        bindProductsData()
    }
}
