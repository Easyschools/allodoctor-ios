//
//  PharmacyCartViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 30/10/2024.
//

import UIKit

class PharmacyCartViewController: BaseViewController<PharmacyCartViewModel> {
    @IBOutlet weak var pharmacyImage: UIImageView!
    @IBOutlet weak var checkOutLabel: CairoBold!
    @IBOutlet weak var confirmationView: ShadowView!
    @IBOutlet weak var productsStackView: UIStackView!
    @IBOutlet weak var upperStackView: UIStackView!
    @IBOutlet weak var numberOfItems: CairoRegular!
    @IBOutlet weak var pharmacyName: CairoSemiBold!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var totalPrice: CairoRegular!
    @IBOutlet weak var checkOutView: UIView!
    @IBOutlet weak var cartProductsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        checkOutView.isHidden = true
        setupTableView()
        viewModel.getPharmacyCart()
        
    
    }
    override func setupUI() {
        checkOutLabel.text = AppLocalizedKeys.checkOut.localized
    }
    override func viewDidLayoutSubviews() {
        
        upperView.applyDropShadow()
     
    }
    override func bindViewModel() {
        bindProductsData()
    }
    @IBAction func dimissButton(_ sender: Any) {
        viewModel.dissmissView(viewController: self)
    }
    
    @IBAction func proceedToCheckOutAction(_ sender: Any) {
        viewModel.navToCheckOut()
    }

}
extension PharmacyCartViewController{
   private func setupTableView(){
        cartProductsTableView.delegate = self
        cartProductsTableView.dataSource = self
       cartProductsTableView.registerCell(cellClass: PharmacyCartTableViewCell.self)
       cartProductsTableView.frame = cartProductsTableView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 140, right: 0))
    }
    private func setupViewUI(){
        let pharmacyCartData = viewModel.pharmacyCart
        pharmacyImage.kf.setImage(with: URL(string: pharmacyCartData?.image ?? ""))
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
          
            pharmacyName.text = pharmacyCartData?.nameAr
        }
        else{ let pharmacyCartData = viewModel.pharmacyCart
            pharmacyName.text = pharmacyCartData?.nameEn
        }
        totalPrice.text = (pharmacyCartData?.totalAfterDiscount ?? "0").prepend(AppLocalizedKeys.total.localized, separator: ":").appendingWithSpace(AppLocalizedKeys.EGP.localized)
        numberOfItems.text = pharmacyCartData?.totalQuantity.toString().prepend(AppLocalizedKeys.orderList.localized, separator: " ")
    }
    
}
extension PharmacyCartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pharmacyCart?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath: indexPath) as PharmacyCartTableViewCell
        
        // Cancel any existing subscriptions
        cell.cancellables.removeAll()
        
        // Safely get the items array and check the index
        if let items = viewModel.pharmacyCart?.items,
           indexPath.row < items.count {
            let item = items[indexPath.row]
            
            // Configure initial cell state
            cell.itemQuantityLabel.text = "\(item.quantity)"
            cell.configureCell(with: item)
            
            // Set up quantity update callback
            cell.quantityUpdateCallback = { [weak self] newQuantity in
                self?.viewModel.updateItemQuantity(itemId: item.id ?? 0, newQuantity: newQuantity)
            }
            
            // Set up binding for quantity updates
            viewModel.$pharmacyCart
                .compactMap { $0?.items }
                .filter { items in
                    // Ensure the index is still valid
                    indexPath.row < items.count
                }
                .compactMap { items -> Int? in
                    // Safely get the quantity for this item
                    guard indexPath.row < items.count else { return nil }
                    return items[indexPath.row].quantity
                }
                .receive(on: DispatchQueue.main)
                .sink { [weak cell] quantity in
                    cell?.itemQuantityLabel.text = "\(quantity)"
                }
                .store(in: &cell.cancellables)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
}
extension PharmacyCartViewController{
    private func bindProductsData(){
        viewModel.$pharmacyCart
            .receive(on: DispatchQueue.main)
            .sink { pharmacies in
                self.setupViewUI()
                self.cartProductsTableView.reloadData()
            }.store(in: &cancellables)
    }
}
// Add this extension to PharmacyCartViewController
extension PharmacyCartViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Create the delete action
        let deleteAction = UIContextualAction(style: .destructive, title: AppLocalizedKeys.deletedSuccessfully.localized) { [weak self] (action, view, completion) in
            guard let self = self,
                  let items = self.viewModel.pharmacyCart?.items,
                  indexPath.row < items.count else {
                completion(false)
                return
            }
            
            // Get the correct item ID
            let itemToDelete = items[indexPath.row]
            let itemId = itemToDelete.id ?? 0
            
            // Call the delete function from view model
            self.viewModel.deleteProduct(productId: itemId) { [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        // The UI will be updated automatically through the binding
                        // No need to manually manipulate the array or delete rows
                        completion(true)
                    } else {
                        // Handle error case
                        completion(false)
                        // Optionally show an error message to the user
                    }
                }
            }
        }
        
        // Create and return the swipe configuration
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
}
