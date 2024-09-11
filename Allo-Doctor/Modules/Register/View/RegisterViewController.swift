//
//  RegisterViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/09/2024.
//

import UIKit
import Combine
class RegisterViewController: BaseViewController<RegisterViewModel> {
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet private weak var createAccButton: CustomButton!
    @IBOutlet private weak var selectGenderView: UIView!
    private let dropdownView = DropdownTextFieldView()
    @IBOutlet private weak var selectAreaView: UIView!
    let selectGender = SelectGenderView()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setupUI(){
        createAccButton.setupButton(color: .appColor, font: .body, title: buttonsText.createAccount.rawValue, borderColor: .appColor, textColor: .white)}
    override func bindViewModel() {
        nameTextField.bindText(to: viewModel.nameSubject, storeIn: &cancellables)
        ageTextField.bindText(to: viewModel.ageSubject, storeIn: &cancellables)
        
    }
    @IBAction func createAccount(_ sender: Any) {
        viewModel.createuser()
    }
    
}
extension RegisterViewController{
    private func setupDropdownView() {
           dropdownView.translatesAutoresizingMaskIntoConstraints = false
        selectAreaView.addSubview(dropdownView)
        
       }
}


