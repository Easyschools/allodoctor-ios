//
//  OTPViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/09/2024.
//

import UIKit

class OTPViewController: BaseViewController<OTPViewModel>,UITextFieldDelegate{

    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var textFieldFour: UITextField!
    @IBOutlet weak var textFieldThree: UITextField!
    @IBOutlet weak var textFieldTwo: UITextField!
    @IBOutlet weak var textFieldOne: UITextField!
    @IBOutlet weak var submitButton: CustomButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldViewModelBind()
        setupTextFields()
        submitButton.setupButton(color: .appColor, title: "Submit", borderColor: .appColor, textColor: .white)
    }
    override func setupUI() {
        errorMessageLabel.isHidden = true
        submitButton.setupButton(color: .appColor, title: "Submit", borderColor: .appColor, textColor: .white)
    }

    @IBAction func submitButttonAction(_ sender: Any) {
//        if viewModel.checkOtp() == true {
//            UserDefaultsManager.sharedInstance.login()
//            viewModel.coordinator?.showTabBar()
//        }
//        else {
//            errorMessageLabel.isHidden = false
//        }
        viewModel.checkOtp()
    }
    
}
extension OTPViewController{
    func setupTextFields(){
            textFieldOne.delegate = self
            textFieldTwo.delegate = self
            textFieldThree.delegate = self
            textFieldFour.delegate = self
    }
@objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let index = getTextFieldIndex(for: textField) else { return false }

        // Manually update the text field’s text
        if !string.isEmpty {
            textField.text = string
            viewModel.handleInput(for: index, with: string)
            return false
        } else {
            textField.text = ""
            viewModel.handleInput(for: index, with: string)
            return false
        }
    }

    private func getTextFieldIndex(for textField: UITextField) -> Int? {
        switch textField {
        case textFieldOne:
            return 0
        case textFieldTwo:
            return 1
        case textFieldThree:
            return 2
        case textFieldFour:
            return 3
        default:
            return nil
        }
    }
    @objc  private func updateTextFieldFocus(to index: Int) {
           switch index {
           case 0:
               textFieldOne.becomeFirstResponder()
           case 1:
               textFieldTwo.becomeFirstResponder()
           case 2:
               textFieldThree.becomeFirstResponder()
           case 3:
               textFieldFour.becomeFirstResponder()
           default:
               break
           }
       }
    
}
extension OTPViewController{
    func textFieldViewModelBind(){
        viewModel.$activeTextField
            .sink { [weak self] activeIndex in
                self?.updateTextFieldFocus(to: activeIndex)
            }
            .store(in: &cancellables)
        
        // Observe if the OTP is complete to enable the submit button
        viewModel.$otpInput
            .map { $0.allSatisfy { !$0.isEmpty } }
            .assign(to: \.isEnabled, on: submitButton)
        .store(in: &cancellables)}
    
}
