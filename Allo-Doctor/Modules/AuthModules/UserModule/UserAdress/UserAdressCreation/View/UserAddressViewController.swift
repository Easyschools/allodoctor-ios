//
//  UserAddressViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 09/11/2024.
//

import UIKit

class UserAddressViewController: BaseViewController<UserAddressViewModel> {
    @IBOutlet weak var adressView: UIView!
    @IBOutlet weak var apartmentView: UIView!
    @IBOutlet weak var floorView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setupUI() {
        setupViewUI()
    }
}
extension UserAddressViewController{
    func setupViewUI() {
        adressView.applyDropShadow()
        apartmentView.applyDropShadow()
        floorView.applyDropShadow()
    }
}
extension  UserAddressViewController{
   
}
