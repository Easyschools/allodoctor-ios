//
//  MyProfileViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 12/09/2024.
//

import UIKit

class MyProfileViewController: BaseViewController<MyProfileViewModel> {

    @IBOutlet weak var userMobile: CairoRegular!
    @IBOutlet weak var userName: CairoBold!
    @IBOutlet weak var logoutButton: UIButton!
    private var userdefault: UserDefaultProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.setTitle(AppLocalizedKeys.logout.localized, for: .normal)

        logoutButton.contentHorizontalAlignment = LocalizationManager.shared.isRTL() ? .right : .left
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            logoutButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
            logoutButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 24)
        }
        else{
            logoutButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            logoutButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 2, right: 0)}
        logoutButton.applyDropShadow()
    }
    override func viewWillAppear(_ animated: Bool) {
        userName.text =  UserDefaultsManager.sharedInstance.getUserName()
    }
    override func setupUI() {
        userName.text =  UserDefaultsManager.sharedInstance.getUserName()
    
        userMobile.text =  UserDefaultsManager.sharedInstance.getMobileNumber()
     
    }
    @IBAction func navToSetttings(_ sender: Any) {
        viewModel.navToProfileSettings()
    }
    @IBAction func navTouserInsurance(_ sender: Any) {
        viewModel.navToInsuranceSelect()
    }
    @IBAction func navToProfileEdit(_ sender: Any) {
        viewModel.navToProfileEdit()
    }
  
    
    @IBAction func navToProfileSupport(_ sender: Any) {
        viewModel.showProfileSupport()
    }
    @IBAction func medicalInfoAction(_ sender: Any){
        viewModel.showMedicalInfo()
    }
    @IBAction func navToFavourites(_ sender: Any) {
        viewModel.showFavourites()
    }
    @IBAction func logoutAction(_ sender: Any) {
        UserDefaultsManager.sharedInstance.logout()
        UserDefaultsManager.sharedInstance.resetAllData()
        viewModel.navToLogin()
        
    }
}
