//
//  PharmacyCartViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 30/10/2024.
//

import UIKit

class PharmacyCartViewController: BaseViewController<PharmacyCartViewModel> {

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
        cartProductsTableView.register(UINib(nibName: "PharmacyCartTableViewCell", bundle: nil), forCellReuseIdentifier: "PharmacyCartTableViewCell")
    }
    private func setupViewUI(){
        let pharmacyCartData = viewModel.pharmacyCart
        totalPrice.text = (pharmacyCartData?.totalPrice ?? "0").prepend("Total", separator: " ") + " " + "EGP"
        pharmacyName.text = pharmacyCartData?.name
        numberOfItems.text = pharmacyCartData?.totalQuantity.toString().prepend("Order List:", separator: " ")
    }
    
}
extension PharmacyCartViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pharmacyCart?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "PharmacyCartTableViewCell") as! PharmacyCartTableViewCell
           
           guard let item = viewModel.pharmacyCart?.items[indexPath.row] else {
               return cell
           }
           
           // Set initial quantity
           cell.itemQuantityLabel.text = "\(item.quantity)"
           
           // Setup quantity update callback
           cell.quantityUpdateCallback = { [weak self] newQuantity in
               self?.viewModel.updateItemQuantity(itemId: item.id, newQuantity: newQuantity)
           }
           
           // Bind quantity updates from view model
           viewModel.$pharmacyCart
               .compactMap { $0?.items[indexPath.row].quantity }
               .receive(on: DispatchQueue.main)
               .sink { [weak cell] quantity in
                   cell?.itemQuantityLabel.text = "\(quantity)"
               }
               .store(in: &cell.cancellables)
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
