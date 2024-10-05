//
//  MyProfileViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 12/09/2024.
//

import UIKit

class MyProfileViewController: BaseViewController<MyProfileViewModel> {

    @IBOutlet weak var userInfo: CairoRegular!
    @IBOutlet weak var userName: CairoSemiBold!
    @IBOutlet weak var myActivity: UIControl!
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        logoutButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        logoutButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 2, right: 0)
    }


    @IBAction func activityAction(_ sender: Any) {

    }
    
    @IBAction func medicalInfoAction(_ sender: Any){
    }
    @IBAction func logoutAction(_ sender: Any) {
        UserDefaultsManager.sharedInstance.logout()
        viewModel.navToLogin()
    }
}
