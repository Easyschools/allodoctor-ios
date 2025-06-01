//
//  SelectChatTypeViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 26/05/2025.
//

import UIKit

class SelectChatTypeViewController: BaseViewController<SelectChatTypeViewModel> {
    @IBOutlet weak var upperView: UIView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func navBack(_ sender: Any) {
        viewModel.navBack()
    }
    @IBAction func doctorChatAction(_ sender: Any) {
        viewModel.navToChat(chatType: .doctorType)
    }
    @IBAction func customServiceAction(_ sender: Any) {
        viewModel.navToChat(chatType: .customerServiceType)
    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
}
