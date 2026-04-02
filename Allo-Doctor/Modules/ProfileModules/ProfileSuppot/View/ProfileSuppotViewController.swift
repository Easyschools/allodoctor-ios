//
//  ProfileSuppotViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/01/2025.
//

import UIKit
import MessageUI

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
    
    @IBAction func showEmailComposer(_ sender: Any) {
        let emailAddress = "allodoctor@allodoctor.com"
        
        // Check if device can send email
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients([emailAddress])
            mailComposer.setSubject(AppLocalizedKeys.supportRequest.localized)
            present(mailComposer, animated: true)
        } else {
            // Fallback to mailto URL scheme
            if let emailURL = URL(string: "mailto:\(emailAddress)") {
                if UIApplication.shared.canOpenURL(emailURL) {
                    UIApplication.shared.open(emailURL)
                } else {
                    // Show alert if email cannot be sent
                    showEmailAlert(email: emailAddress)
                }
            }
        }
    }
    
    @IBAction func showChat(_ sender: Any) {
        viewModel.showChat()
    }
    
    @IBAction func navigationBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    
    private func showEmailAlert(email: String) {
        let alert = UIAlertController(
            title: AppLocalizedKeys.emailNotAvailable.localized,
            message: AppLocalizedKeys.emailNotAvailableMessage.localized + " \(email)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: AppLocalizedKeys.ok.localized, style: .default))
        present(alert, animated: true)
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension ProfileSuppotViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
