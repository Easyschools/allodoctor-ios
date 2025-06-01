//
//  ProfileSettingsViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/12/2024.
//

import UIKit

class ProfileSettingsViewController: BaseViewController<ProfileSettingsViewModel> {

    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var navBackButton: CustomNavigationBackButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    @IBAction func showLangugaeSelect(_ sender: Any) {
        let contentViewController = ChangeLangugeViewController()
        let sheetController = FWIPNSheetViewController(controller: contentViewController, sizes: [.fixed(300)])
        present(sheetController, animated: true, completion: nil)
    }
    
    @IBAction func navIgationBackAction(_ sender: Any) {
        viewModel.navBack()
    
    }
    
}
