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
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var textFieldFour: UITextField!
    @IBOutlet weak var textFieldThree: UITextField!
    @IBOutlet weak var textFieldTwo: UITextField!
    @IBOutlet weak var textFieldOne: UITextField!
    @IBOutlet weak var submitButton: CustomButton!
    
    // MARK: - Timer Properties
    private var resendTimer: Timer?
    private var remainingTime: Int = 30
    private let resendTimerDuration: Int = 30
    
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
        setupResendButton()
    }
    
    // MARK: - Actions
    @IBAction func resendAction(_ sender: Any) {
        startResendTimer()
    }
    @IBAction func submitButtonAction(_ sender: Any) {
        viewModel.checkOtp()
    }
    
    
    // MARK: - Timer Methods
    private func setupResendButton() {
        resendButton.setTitle(AppLocalizedKeys.resend.localized, for: .normal)
        resendButton.isEnabled = true
    }
    
    private func startResendTimer() {
        remainingTime = resendTimerDuration
        resendButton.isEnabled = false
        updateResendButtonTitle()
        
        resendTimer?.invalidate()
        resendTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    private func updateTimer() {
        remainingTime -= 1
        updateResendButtonTitle()
        
        if remainingTime <= 0 {
            stopResendTimer()
        }
    }
    
    private func stopResendTimer() {
        resendTimer?.invalidate()
        resendTimer = nil
        resendButton.isEnabled = true
        resendButton.setTitle("Resend", for: .normal)
    }
    
    private func updateResendButtonTitle() {
        if remainingTime > 0 {
            resendButton.setTitle("Resend in \(remainingTime)s", for: .disabled)
        }
    }
    
    // MARK: - Helper Methods
    private func configureTextFieldsAppearance() {
        let textFields = [textFieldOne, textFieldTwo, textFieldThree, textFieldFour]
        textFields.forEach { textField in
            textField?.textAlignment = .center
            textField?.keyboardType = .numberPad
            textField?.layer.cornerRadius = 5
            textField?.layer.borderWidth = 1
            textField?.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    private func updateTextFieldFocus(to index: Int) {
        // Reset all text field borders to light gray
        let textFields = [textFieldOne, textFieldTwo, textFieldThree, textFieldFour]
        textFields.forEach { textField in
            textField?.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        // Set active text field border to blue and make it first responder
        switch index {
        case 0:
            textFieldOne.becomeFirstResponder()
            textFieldOne.layer.borderColor = UIColor.blueApp.cgColor
        case 1:
            textFieldTwo.becomeFirstResponder()
            textFieldTwo.layer.borderColor = UIColor.blueApp.cgColor
        case 2:
            textFieldThree.becomeFirstResponder()
            textFieldThree.layer.borderColor = UIColor.blueApp.cgColor
        case 3:
            textFieldFour.becomeFirstResponder()
            textFieldFour.layer.borderColor = UIColor.blueApp.cgColor
        default: break
        }
    }
    
    // MARK: - Cleanup
    deinit {
        resendTimer?.invalidate()
    }
}

// MARK: - UITextFieldDelegate
extension OTPViewController: UITextFieldDelegate {
    func setupTextFields() {
        textFieldOne.delegate = self
        textFieldTwo.delegate = self
        textFieldThree.delegate = self
        textFieldFour.delegate = self
        
        // Add target for editing events to handle border color changes
        textFieldOne.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        textFieldTwo.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        textFieldThree.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        textFieldFour.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        
        textFieldOne.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        textFieldTwo.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        textFieldThree.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        textFieldFour.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let index = getTextFieldIndex(for: textField) else { return false }
        
        if !string.isEmpty { // Input a number
            // Only allow single digit input
            guard string.count == 1 && string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else {
                return false
            }
            
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
