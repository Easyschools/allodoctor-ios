//
//  UserAdressSelectViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 05/11/2024.
//

import UIKit

class UserAdressSelectViewController: BaseViewController<UserAdressSelectViewModel> {
    var dismissalSubject = PassthroughSubject<Void, Never>()
    var choosedAdress = PassthroughSubject<String,Never>()
    @IBOutlet weak var tableViewDynamicHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var adressesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adressesTableView.reloadData()
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func addAdressAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.dismissalSubject.send()
        }
    }
    override func setupUI() {
        setupTableView()
        bindTableViewHeight()
    }
    override func bindViewModel() {
        bindUserAddress()
        viewModel.getUserAddresses()
    }
}
extension UserAdressSelectViewController{
   private func setupTableView(){
       adressesTableView.registerCell(cellClass: UserAddressTableViewCell.self)
       adressesTableView.dataSource = self
       adressesTableView.delegate = self
    }
   
}
extension UserAdressSelectViewController{
   private func bindUserAddress() {
       viewModel.$userAddresses
           .receive(on: DispatchQueue.main)
           .sink { addresses in
               self.adressesTableView.reloadData()
           }.store(in: &cancellables)
        
    }
}
extension UserAdressSelectViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userAddresses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath: indexPath) as UserAddressTableViewCell

        guard let item = viewModel.userAddresses?[indexPath.row] else {
            return UITableViewCell()
        }

        cell.addressLabel.text = item.address
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
    }
   
    private func bindTableViewHeight() {
        adressesTableView.publisher(for: \.contentSize)
            .sink { [weak self] newSize in
                guard let self = self else { return }
                if self.tableViewDynamicHeightConstraint.constant != newSize.height {
                    self.tableViewDynamicHeightConstraint.constant = newSize.height
                    self.view.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
    }
}

