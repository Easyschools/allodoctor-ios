//
//  PhoneNumberViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 06/09/2024.
//
import UIKit
import Foundation
class PhoneNumberViewController: BaseViewController<PhoneNumberViewModel> {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var otpButton: CustomButton!
    @IBOutlet weak var enterValidNumberImage: UIImageView!
    @IBOutlet weak var enterValidNumberLabel: UILabel!
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    internal override func setupUI() {
        enterValidNumberImage.isHidden = true
        enterValidNumberLabel.isHidden = true
        otpButton.setupButton(color: .appColor,  title: buttonsText.getOtp.rawValue, borderColor: .appColor, textColor: .white)
        mobileNumberTextField.addPadding(By: Dimensions.textFieldPadding.rawValue, for: .left)
    }
    override func bindViewModel() {
        mobileNumberTextField.bindText(to: viewModel.mobileSubject, storeIn: &cancellables)
    }
    

    // MARK: - Get OTP Action
    @IBAction func getOtpAction(_ sender: Any) {
        guard let mobileNumber = mobileNumberTextField.text else { return }
        
        if mobileNumber.isValidEgyptianNumber {
            // Valid number, navigate to OTP screen
            enterValidNumberImage.isHidden = true
            enterValidNumberLabel.isHidden = true
            
            // Save the valid mobile number
            viewModel.postMobileNumber()
           
        } else {
            // Invalid number, show error image and label
            enterValidNumberImage.isHidden = false
            enterValidNumberLabel.isHidden = false
        }
    }
    
    // MARK: - Dismiss Keyboard on Tap
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension String {
    // Validate if the string is a valid Egyptian mobile number
    var isValidEgyptianNumber: Bool {
        let regex = "^01[0-2,5]{1}[0-9]{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}
