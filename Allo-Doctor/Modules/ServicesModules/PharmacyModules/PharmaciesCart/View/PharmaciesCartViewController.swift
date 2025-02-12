//
//  PharmaciesCartViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 28/10/2024.
//

import UIKit

class PharmaciesCartViewController: BaseViewController<PharmaciesCartViewModel> {
    @IBOutlet weak var navigationBackButton: CustomNavigationBackButton!
    
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    @IBOutlet weak var pharmaciesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        setupTableView()
        navigationBackButton.tintColor = .black
        navigationBackButton.setTitleColor(.black, for: .normal)
    }
    override func viewDidLayoutSubviews() {
        
     
     
    }
    override func bindViewModel() {
        bindPharmacyData()
        viewModel.getPharmaciesCart()
    }

    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    


}
extension PharmaciesCartViewController{
   private func setupTableView(){
       pharmaciesTableView.delegate = self
       pharmaciesTableView.dataSource = self
       pharmaciesTableView.registerCell(cellClass: PharmaciesListTableViewCell.self)
       pharmaciesTableView.frame = pharmaciesTableView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 140, right: 0))
    }
    private func setupViewUI(){
       
    }
    
}
extension PharmaciesCartViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pharmacies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath: indexPath) as PharmaciesListTableViewCell
        let data = viewModel.pharmacies?[indexPath.row]
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            cell.setup(pharmacyName: data?.nameAr ?? "Not Available", quantity: data?.totalQuantity ?? 0, imageURL: data?.image ?? "")
        }
        else{
            cell.setup(pharmacyName: data?.nameEn ?? "Not Available", quantity: data?.totalQuantity ?? 0, imageURL: data?.image ?? "")
        }
       
           return cell
       }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = viewModel.pharmacies?[indexPath.row].pharmacyID ?? 0
        viewModel.navToPharmacyCart(pharmacyId:id)
    }
   
    
}
extension PharmaciesCartViewController{
    private func bindPharmacyData(){
        viewModel.$pharmacies
            .receive(on: DispatchQueue.main)
            .sink { pharmacies in
                self.pharmaciesTableView.reloadData()
            }.store(in: &cancellables)
    }
}
