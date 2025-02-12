//
//  EmergencyViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 09/11/2024.
//

import UIKit

class EmergencyViewController: BaseViewController<EmergencyViewModel> {


    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var confirmationButton: CustomButton!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var selectAreaLabel: UILabel!
    @IBOutlet weak var acceptTermsButton: SelectableButton!
    private var isAreaSelected:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextfield.bindText(to: viewModel.nameSubject, storeIn: &cancellables)
        phoneNumberTextField.bindText(to: viewModel.numberSubject, storeIn: &cancellables)
    }
    override func setupUI() {
        confirmationButton.isUserInteractionEnabled = false
        confirmationButton.layer.backgroundColor = UIColor.grey6B7280.cgColor
    }
    override func bindViewModel() {
        handleViewModelResponse()
        viewModel.getAllAreaOfResidence()
        viewModel.$errorMessage
                 .sink { [weak self] errorMessage in
                     guard let self = self, let errorMessage = errorMessage else { return }
                     self.showErrorAlert(message: errorMessage)
                 }
                 .store(in: &viewModel.cancellables)
        acceptTermsButton.onSelectionChanged = { isSelected in
            if isSelected {
                self.confirmationButton.isUserInteractionEnabled = true
                self.confirmationButton.layer.backgroundColor = UIColor.appColor.cgColor
            } else {
                self.confirmationButton.isUserInteractionEnabled = false
                self.confirmationButton.layer.backgroundColor = UIColor.greyA8A8A8.cgColor
            }
        }
    }

    @IBAction func chooseArea(_ sender: Any) {
        let citiesVC = SectionSearchableTableViewController(cityData: viewModel.cities)
        citiesVC.delegate = self
        viewModel.coordinator?.presentModallyWithRoot(citiesVC)

    }
    @IBAction func dismissButtonAction(_ sender: Any) {
        viewModel.navBack()
    }
    @IBAction func acceptTermsAction(_ sender: Any) {
    }
    @IBAction func confirmationAction(_ sender: Any) {
        if validateInputs(){
            viewModel.createBooking()}
    }
}
extension EmergencyViewController:SectionSearchableTableViewControllerDelegate {
    func sectionSearchableTableViewController(_ controller: SectionSearchableTableViewController, didSelectDistrictWithID id: Int, districtName name: String) {
     
            selectAreaLabel.text = name
            viewModel.districtId.value = id
            isAreaSelected = true
        
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
    
        func sectionSearchableTableViewControllerDidTapDismiss(_ controller: SectionSearchableTableViewController) {
            viewModel.coordinator?.dismissPresnetiontabBarNav(self)
        }
    private func showErrorAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    private func handleViewModelResponse(){
        viewModel.$bookingStatus
                   .receive(on: DispatchQueue.main)
                   .sink { status in
                       guard let status = status else { return }
                       switch status {
                       case .success:
                           self.handleSucessViews()
                       case .failure:
                           AlertManager.showAlert(on: self, title:AppLocalizedKeys.error.localized, message: AppLocalizedKeys.somethingHappen.localized)
                       }
                   }
                   .store(in: &cancellables)
    }
    private func handleSucessViews(){
        let confirmationView = ConfirmationView(frame: view.bounds)
        confirmationView.proceedActionPublisher
                   .sink { [weak self] _ in
                       self?.viewModel.navToHome()
                   }
                   .store(in: &cancellables)
               // Add it to the view controller's view
         view.addSubview(confirmationView)
    }
    private func validateInputs() -> Bool {
        // Validate name
        guard let name = nameTextfield.text, !name.isEmpty else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidName.localized, message: AppLocalizedKeys.nameEmpty.localized)
            return false
        }
        
        let nameRegex = "^[a-zA-Z ]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        guard namePredicate.evaluate(with: name) else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidName.localized, message:AppLocalizedKeys.NameRejecs.localized)
            return false
        }
        
        // Validate phone number
        guard let phone = phoneNumberTextField.text, !phone.isEmpty else {
            AlertManager.showAlert(on: self, title:AppLocalizedKeys.InvalidNumber.localized, message: AppLocalizedKeys.phoneEmpty.localized)
            return false
        }
        
        // Use the isValidEgyptianNumber extension to validate the phone number
        guard phone.isValidEgyptianNumber else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidNumber.localized, message: AppLocalizedKeys.phoneRejecs.localized)
            return false
        }
        guard isAreaSelected else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.selectArea.localized, message: AppLocalizedKeys.selectArea.localized)
            return false
        }

        return true
    }
  
}
