//
//  ProfileSuppotViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/01/2025.
//

import UIKit

class ProfileSuppotViewController: BaseViewController<ProfileSuppotViewModel> {

    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var appMessage: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var appEmail: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var appPhoneNumber: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setupUI() {
        message.text = AppLocalizedKeys.inAppMessaging.localized
        appMessage.text = AppLocalizedKeys.askAnyQuestionWithUs.localized
        email.text = AppLocalizedKeys.Email.localized
        phoneNumber.text = AppLocalizedKeys.ContactUs.localized
    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    @IBAction func showPhoneView(_ sender: Any) {
        viewModel.showNumberView(uiviewController: self)
    }
    @IBAction func showChat(_ sender: Any) {
        viewModel.showChat()
    }
    @IBAction func navigationBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    

}
