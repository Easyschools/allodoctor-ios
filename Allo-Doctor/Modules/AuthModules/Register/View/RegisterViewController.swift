//
//  RegisterViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/09/2024.
//

import UIKit

class RegisterViewController: BaseViewController<RegisterViewModel>
{
    @IBOutlet weak var selectAreaLabel: CairoRegular!
    @IBOutlet weak var selectMedicalButton: UIButton!
    @IBOutlet weak var selectAreaButton: UIButton!
    @IBOutlet weak var genderSelection: GenderSelectionControl!
    @IBOutlet weak var errorMessage: CairoBold!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet private weak var createAccButton: CustomButton!
    private var selectedData:String?
    private var isGenderSelected = false
    private var isCitySelected = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        createAccButton.setupButton(color: .appColor,  title: buttonsText.createAccount.rawValue, borderColor: .appColor, textColor: .white)
        selectAreaButton.tag = 1
    }
    
    override func setupUI() {
        genderSelection.onGenderSelected = { [weak self] gender in
            if gender == .female {
                self?.isGenderSelected = true
                self?.viewModel.genderSubject.send("female")
            }
            else {self?.isGenderSelected = true
                self?.viewModel.genderSubject.send("male")}
        }
        errorImage.isHidden = true
        errorMessage.isHidden = true
        ageTextField.addPadding(By: 10, for: .left)
        nameTextField.addPadding(By: 10, for: .left)
    }
    
    override func bindViewModel() {
        nameTextField.bindText(to: viewModel.nameSubject, storeIn: &cancellables)
        ageTextField.bindText(to: viewModel.ageSubject, storeIn: &cancellables)
        viewModel.getAllAreaOfResidence()
    }
    
    
    @IBAction func createAccount(_ sender: Any) {
        if validateInputs() {
            viewModel.createuser()
          
        }
    }
    
    @IBAction func areaResidencePresentView(_ sender: Any) {
        let citiesVC = SectionSearchableTableViewController(cityData: viewModel.cities)
        citiesVC.delegate = self
        viewModel.coordinator?.presentModally(citiesVC)
        selectedData = "area"
        selectAreaButton.tag = 1
    }
    
    private func validateInputs() -> Bool {
        // Validate name
        guard let name = nameTextField.text, !name.isEmpty else {
            showError(AppLocalizedKeys.EnterName.localized)
            return false
        }
        
        let nameRegex = "^[a-zA-Z ]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        guard namePredicate.evaluate(with: name) else {
            showError(AppLocalizedKeys.NameValidation.localized)
            return false
        }
        
        // Validate age
        guard let ageText = ageTextField.text, let age = Int(ageText) else {
            showError(AppLocalizedKeys.ValidAge.localized)
            return false
        }
        
        if age <= 10 || age > 100 {
            showError(AppLocalizedKeys.AgeVerify.localized)
            return false
        }
        
        // Validate medical condition selection
       
        // Validate city selection
        guard isCitySelected else {
            showError(AppLocalizedKeys.SelectCity.localized)
            return false
        }
        guard isGenderSelected else {
            showError(AppLocalizedKeys.selectGender.localized)
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

            selectAreaLabel.text = item
            isCitySelected = true
        
        viewModel.coordinator?.dismissPresnet(self)
    }
}
extension RegisterViewController:SectionSearchableTableViewControllerDelegate {
    func sectionSearchableTableViewController(_ controller: SectionSearchableTableViewController, didSelectDistrictWithID id: Int, districtName name: String) {
            selectAreaLabel.text = name
            viewModel.districtId.value = id
            isCitySelected = true
        viewModel.coordinator?.dismissPresnet(self)
    }
    
        func sectionSearchableTableViewControllerDidTapDismiss(_ controller: SectionSearchableTableViewController) {
            viewModel.coordinator?.dismissPresnet(self)
        }
        
    }
