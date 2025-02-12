//
//  ProfileEditViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 26/11/2024.
//

import UIKit

class ProfileEditViewController: BaseViewController<ProfileEditViewModel> {
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setupUI() {

    }
    override func viewDidLayoutSubviews() {

        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    @IBAction func areaOfResidanceAction(_ sender: Any) {
        let citiesVC = SectionSearchableTableViewController(cityData: viewModel.cities)
        citiesVC.delegate = self
        viewModel.coordinator?.presentModallyWithRoot(citiesVC)
       
        
    }
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    @IBAction func saveAction(_ sender: Any) {
        viewModel.updateUser()
    }
    @IBAction func cancelAction(_ sender: Any) {
        viewModel.navBack()
    }
    private var selectedData:String?
    private var isMedicalConditionSelected = false
    private var isCitySelected = false
   


    
    override func bindViewModel() {
        bindVmData()
        viewModel.getAllAreaOfResidence()
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
        
      

        hideError()
        return true
    }
    
    private func showError(_ message: String) {
  
    }
    
    private func hideError() {
   
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}


    
   

extension ProfileEditViewController:SectionSearchableTableViewControllerDelegate {
    func sectionSearchableTableViewController(_ controller: SectionSearchableTableViewController, didSelectDistrictWithID id: Int, districtName name: String) {
        
            areaLabel.text = name
            viewModel.districtId.value = id
            isCitySelected = true

        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
    
        func sectionSearchableTableViewControllerDidTapDismiss(_ controller: SectionSearchableTableViewController) {
            viewModel.coordinator?.dismissPresnetiontabBarNav(self)
        }
        
    func bindVmData(){
        ageTextField.bindText(to: viewModel.ageSubject, storeIn: &cancellables)
        nameTextField.bindText(to: viewModel.nameSubject, storeIn: &cancellables)
        emailTextField.bindText(to: viewModel.emailSubject, storeIn: &cancellables)
    }
    }
