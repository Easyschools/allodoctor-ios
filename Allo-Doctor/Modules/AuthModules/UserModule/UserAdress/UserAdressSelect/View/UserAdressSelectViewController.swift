//
//  UserAdressSelectViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 05/11/2024.
//

import UIKit

class UserAdressSelectViewController: BaseViewController<UserAdressSelectViewModel> {

    var dismissalSubject = PassthroughSubject<Void, Never>()
    var choosedAddress = PassthroughSubject<(String, Int), Never>()

    @IBOutlet weak var tableViewDynamicHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var adressesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    override func setupUI() {
        setupTableView()
        bindTableViewHeight()
    }

    private func setupTableView() {
        adressesTableView.registerCell(cellClass: UserAddressTableViewCell.self)
        adressesTableView.dataSource = self
        adressesTableView.delegate = self
    }

    private func bindTableViewHeight() {
        adressesTableView.publisher(for: \.contentSize)
            .sink { [weak self] newSize in
                guard let self = self, self.view.window != nil else { return }
                
                // Ensure the constraint is part of the same hierarchy before updating
                if let constraint = self.tableViewDynamicHeightConstraint,
                   self.tableViewDynamicHeightConstraint.isActive,
                   constraint.constant != newSize.height {
                    constraint.constant = newSize.height
                    UIView.animate(withDuration: 0.2) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
            .store(in: &cancellables)
    }

    override func bindViewModel() {
        bindUserAddress()
        bindLoadingState()
        viewModel.getUserAddresses()
    }

    private func bindLoadingState() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
//                    LoadingIndicator.shared.show()
                    self?.adressesTableView.isHidden = true
                } else {
//                    LoadingIndicator.shared.hide()
                    self?.adressesTableView.isHidden = false
                }
            }
            .store(in: &cancellables)
    }

    private func bindUserAddress() {
        viewModel.$userAddresses
            .receive(on: DispatchQueue.main)
            .sink { [weak self] addresses in
                self?.adressesTableView.reloadData()
            }
            .store(in: &cancellables)
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func addAdressAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.dismissalSubject.send()
        }
    }
}

extension UserAdressSelectViewController: UITableViewDelegate, UITableViewDataSource {
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedAddress = viewModel.userAddresses?[indexPath.row],
              let id = selectedAddress.id else {
            print("Error: Address ID is missing.")
            return
        }

        choosedAddress.send((selectedAddress.address ?? "Unknown Address", id))
        self.dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
