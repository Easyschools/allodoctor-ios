//
//  PhoneNumberViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 06/09/2024.
//

import UIKit

class PhoneNumberViewController: UIViewController {
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var otpButton: CustomButton!
    var userDefaultsManager: UserDefaultProtocol
    weak var coordinator: MainCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        otpButton.setupButton(color: .appColor, font: .headline, title: buttonsText.getOtp.rawValue, borderColor: .appColor, textColor: .white)
        mobileNumberTextField.addPadding(By: Dimensions.textFieldPadding.rawValue , for: .left)
     
    }
    init(userDefaultsManager: UserDefaultProtocol = UserDefaultsManager.sharedInstance) {
           self.userDefaultsManager = userDefaultsManager
           super.init(nibName: nil, bundle: nil)
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @IBAction func GetOtpAction(_ sender: Any) {
        userDefaultsManager.setMobileNumber(mobileNumber: mobileNumberTextField.text)
        coordinator?.goToRegister()
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
