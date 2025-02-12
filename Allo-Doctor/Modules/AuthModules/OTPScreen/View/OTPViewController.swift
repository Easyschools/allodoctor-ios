//
//  OTPViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/09/2024.
//

import UIKit
import Combine

class OTPViewController: BaseViewController<OTPViewModel> {
    
    // MARK: - Outlets
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var textFieldFour: UITextField!
    @IBOutlet weak var textFieldThree: UITextField!
    @IBOutlet weak var textFieldTwo: UITextField!
    @IBOutlet weak var textFieldOne: UITextField!
    @IBOutlet weak var submitButton: CustomButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        textFieldViewModelBind()
        setupUI()
    }
    
    override func setupUI() {
        errorMessageLabel.isHidden = true
        configureTextFieldsAppearance()
    }
    
    // MARK: - Actions
    @IBAction func submitButtonAction(_ sender: Any) {
         viewModel.checkOtp()
//            UserDefaultsManager.sharedInstance.login()
//            viewModel.coordinator?.showTabBar()
//        } else {
//            errorMessageLabel.isHidden = false
//        }
    }
    
    // MARK: - Helper Methods
    private func configureTextFieldsAppearance() {
        let textFields = [textFieldOne, textFieldTwo, textFieldThree, textFieldFour]
        textFields.forEach { textField in
            textField?.textAlignment = .center
            textField?.keyboardType = .numberPad
            textField?.layer.cornerRadius = 5
            textField?.layer.borderWidth = 1
        }
    }
    
    private func updateTextFieldFocus(to index: Int) {
        switch index {
        case 0: textFieldOne.becomeFirstResponder()
        case 1: textFieldTwo.becomeFirstResponder()
        case 2: textFieldThree.becomeFirstResponder()
        case 3: textFieldFour.becomeFirstResponder()
        default: break
        }
    }
}

// MARK: - UITextFieldDelegate
extension OTPViewController: UITextFieldDelegate {
    func setupTextFields() {
        textFieldOne.delegate = self
        textFieldTwo.delegate = self
        textFieldThree.delegate = self
        textFieldFour.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let index = getTextFieldIndex(for: textField) else { return false }
        
        if !string.isEmpty { // Input a number
            textField.text = string
            viewModel.handleInput(for: index, with: string)
            let nextIndex = index + 1
            if nextIndex < 4 {
                updateTextFieldFocus(to: nextIndex)
            } else {
                textField.resignFirstResponder()
            }
        } else { // Delete a number
            textField.text = ""
            viewModel.handleInput(for: index, with: string)
            let previousIndex = index - 1
            if previousIndex >= 0 {
                updateTextFieldFocus(to: previousIndex)
            }
        }
        return false
    }
    
    private func getTextFieldIndex(for textField: UITextField) -> Int? {
        switch textField {
        case textFieldOne: return 0
        case textFieldTwo: return 1
        case textFieldThree: return 2
        case textFieldFour: return 3
        default: return nil
        }
    }
}

// MARK: - Combine Binding
extension OTPViewController {
    func textFieldViewModelBind() {
        viewModel.$activeTextField
            .sink { [weak self] activeIndex in
                self?.updateTextFieldFocus(to: activeIndex)
            }
            .store(in: &cancellables)
        
        viewModel.$otpInput
            .map { $0.allSatisfy { !$0.isEmpty } }
            .assign(to: \.isEnabled, on: submitButton)
            .store(in: &cancellables)
    }
}
