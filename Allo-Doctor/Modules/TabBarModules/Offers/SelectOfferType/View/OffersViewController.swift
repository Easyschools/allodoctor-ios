//
//  OffersViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 12/09/2024.
//

import UIKit

class OffersViewController: BaseViewController<OffersViewModel> {

    @IBOutlet weak var upperView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }

    @IBAction func pharmacyOffersAction(_ sender: Any) {
    }
    @IBAction func doctorOffersAction(_ sender: Any) {
    }
}
