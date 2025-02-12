//
//  nonAuthUserViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 01/12/2024.
//

import UIKit
class NonAuthUserViewController: BaseViewController<NonAuthUserViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signInAction(_ sender: Any) {
        viewModel.navToPHoneNumber()
        
    }
    @IBAction func createAccountAction(_ sender: Any) {
        viewModel.navToPHoneNumber()
    }
}
