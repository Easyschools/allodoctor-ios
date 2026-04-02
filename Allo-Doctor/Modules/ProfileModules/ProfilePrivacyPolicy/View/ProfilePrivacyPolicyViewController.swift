//
//  ProfilePrivacyPolicyViewController.swift
//  Allo-Doctor
//
//  Created for App Store Submission
//

import UIKit
import WebKit

class ProfilePrivacyPolicyViewController: BaseViewController<ProfilePrivacyPolicyViewModel> {

    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPolicyContent()
    }

    override func setupUI() {
        titleLabel.text = AppLocalizedKeys.privacyPolicy.localized
    }

    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft, .bottomRight], radius: 25)
    }

    @IBAction func navigationBackAction(_ sender: Any) {
        viewModel.navBack()
    }

    private func loadPolicyContent() {
        let isArabic = LocalizationManager.shared.getLanguage() == .arabic
        let htmlContent = isArabic ? viewModel.getArabicPolicyHTML() : viewModel.getEnglishPolicyHTML()
        webView.loadHTMLString(htmlContent, baseURL: nil)
    }
}
