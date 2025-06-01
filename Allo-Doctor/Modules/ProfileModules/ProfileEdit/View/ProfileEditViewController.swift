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
        bindData()
        bindState()
    }
    


    
    private func validateInputs() -> Bool {
        // Validate name
        guard let name = nameTextField.text, !name.isEmpty else {
            showError(AppLocalizedKeys.nameEmpty.localized)
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
            showError(AppLocalizedKeys.ValidAge.localized)
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
extension ProfileEditViewController{
    private func bindData() {
        viewModel.$userData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] banners in
                self?.setupData()
            }.store(in: &cancellables)
        
    }
    func setupData(){
        let userData = viewModel.userData
        nameTextField.text = userData?.name
        emailTextField.text = userData?.email
        ageTextField.text = userData?.age ?? ""
        areaLabel.text = userData?.district?.nameEn ?? ""
    }
}
extension ProfileEditViewController{
    private func handleSucessViews(){
        let confirmationView = ConfirmationView(frame: view.bounds)
        confirmationView.setupView(message: AppLocalizedKeys.userUpdated.localized, description: AppLocalizedKeys.userUpdatedSuccessfully.localized)
        confirmationView.proceedActionPublisher
            .sink { [weak self] _ in
                self?.viewModel.navBack()
            }
            .store(in: &cancellables)
        // Add it to the view controller's view
        view.addSubview(confirmationView)
    }
}
extension ProfileEditViewController {
    private func bindState() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .idle:
                    break
                case .loading:
                    LoadingIndicator.shared.show()
                case .success:
                    LoadingIndicator.shared.hide()
                    handleSucessViews()
                case .error:
                    LoadingIndicator.shared.hide()
                    AlertManager.showAlert(on: self, title: AppLocalizedKeys.error.localized, message: AppLocalizedKeys.somethingHappen.localized)
                }
            }
            .store(in: &cancellables)
    }
}
