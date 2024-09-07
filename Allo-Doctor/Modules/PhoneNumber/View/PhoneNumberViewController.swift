//
//  PhoneNumberViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 06/09/2024.
//

import UIKit

class PhoneNumberViewController: UIViewController {
    @IBOutlet weak var otpButton: CustomButton!
    weak var coordinator: MainCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        otpButton.setupButton(color: .appColor, font: .headline, title: "Get OTP", borderColor: .appColor, textColor: .white)
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
