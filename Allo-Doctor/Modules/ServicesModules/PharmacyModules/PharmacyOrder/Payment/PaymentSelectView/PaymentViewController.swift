//
//  PaymentViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/12/2024.
//

import UIKit

class PaymentViewController: UIViewController {
    // Combine subject to publish the selected payment method
    let paymentMethodSubject = PassthroughSubject<String, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func dismissButtonAction(_ sender: Any) {
        // Dismiss the view controller
        dismiss(animated: true, completion: nil)
    }

    @IBAction func selectPayOnlineAction(_ sender: Any) {
        // Publish "Paymob" for Pay Online
        paymentMethodSubject.send("paymob")
        dismiss(animated: true, completion: nil)
    }

    @IBAction func selectCashAction(_ sender: Any) {
        // Publish "Cash" for Cash
        paymentMethodSubject.send("cash")
        dismiss(animated: true, completion: nil)
    }
}
