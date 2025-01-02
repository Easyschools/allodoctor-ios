//
//  RegisterViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/09/2024.
//

import UIKit

class RegisterViewController: BaseViewController<RegisterViewModel> {
    @IBOutlet weak var selectAreaLabel: CairoRegular!
    @IBOutlet weak var medicalConditionLabel: UILabel!
    let medicalConditions = [
        "Hypertension",
        "Diabetes",
        "Asthma",
        "Heart Disease",
        "Arthritis",
        "Chronic Kidney Disease",
    ]
    
    let cities = [
        "cairo",
        "Alexandria",
        "Aswan",
        "Matrouh",
        "Giza",
        "Elmanya"
    ]
    
    @IBOutlet weak var selectMedicalButton: UIButton!
    @IBOutlet weak var selectAreaButton: UIButton!
    @IBOutlet weak var genderSelection: GenderSelectionControl!
    @IBOutlet weak var errorMessage: CairoBold!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet private weak var createAccButton: CustomButton!
    private var selectedData:String?
    private var isMedicalConditionSelected = false
    private var isCitySelected = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        createAccButton.setupButton(color: .appColor,  title: buttonsText.createAccount.rawValue, borderColor: .appColor, textColor: .white)
        selectAreaButton.tag = 1
    }
    
    override func setupUI() {
        errorImage.isHidden = true
        errorMessage.isHidden = true
        ageTextField.addPadding(By: 10, for: .left)
        nameTextField.addPadding(By: 10, for: .left)
    }
    
    override func bindViewModel() {
        nameTextField.bindText(to: viewModel.nameSubject, storeIn: &cancellables)
        ageTextField.bindText(to: viewModel.ageSubject, storeIn: &cancellables)
    }
    
    @IBAction func showMedicalConditions(_ sender: Any) {
        let medicalConditionVC = SearchableTableViewController(items: medicalConditions)
        medicalConditionVC.delegate = self
        medicalConditionVC.setTitle("Select Medical Condition")
        viewModel.coordinator?.presentModally(medicalConditionVC)
        selectedData = "medical"
    }
    
    @IBAction func createAccount(_ sender: Any) {
        if validateInputs() {
            viewModel.createuser()
            UserDefaultsManager.sharedInstance.login()
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func areaResidencePresentView(_ sender: Any) {
        let citiesVC = SearchableTableViewController(items: cities)
        citiesVC.delegate = self
        citiesVC.setTitle("Select Area")
        viewModel.coordinator?.presentModally(citiesVC)
        selectedData = "area"
        selectAreaButton.tag = 1
    }
    
    private func validateInputs() -> Bool {
        // Validate name
        guard let name = nameTextField.text, !name.isEmpty else {
            showError("Please enter a name.")
            return false
        }
        
        let nameRegex = "^[a-zA-Z ]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        guard namePredicate.evaluate(with: name) else {
            showError("Name should contain only letters and spaces.")
            return false
        }
        
        // Validate age
        guard let ageText = ageTextField.text, let age = Int(ageText) else {
            showError("Please enter a valid age.")
            return false
        }
        
        if age <= 10 || age > 100 {
            showError("Age should be between 10 and 100.")
            return false
        }
        
        // Validate medical condition selection
        guard isMedicalConditionSelected else {
            showError("Please select a medical condition.")
            return false
        }
        
        // Validate city selection
        guard isCitySelected else {
            showError("Please select a city.")
            return false
        }

        hideError()
        return true
    }
    
    private func showError(_ message: String) {
        errorMessage.text = message
        errorMessage.isHidden = false
        errorImage.isHidden = false
    }
    
    private func hideError() {
        errorMessage.isHidden = true
        errorImage.isHidden = true
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension RegisterViewController: SearchableTableViewControllerDelegate {
    func searchableTableViewControllerDidTapDismiss(_ controller: SearchableTableViewController) {
        viewModel.coordinator?.dismissPresnet(self)
    }
    
    func searchableTableViewController(_ controller: SearchableTableViewController, didSelectItem item: String) {
        if selectedData == "area" {
            selectAreaLabel.text = item
            isCitySelected = true
        } else {
            medicalConditionLabel.text = item
            isMedicalConditionSelected = true
        }
        
        viewModel.coordinator?.dismissPresnet(self)
    }
}
