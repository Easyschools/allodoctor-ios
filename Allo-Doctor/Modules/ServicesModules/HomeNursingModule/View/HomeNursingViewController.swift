//
//  HomeNursingViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 02/12/2024.
//

import UIKit

class HomeNursingViewController: BaseViewController<HomeNursingViewModel> {
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var addressTextField: CustomTextView!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var noteTextField: CustomTextView!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    private var isAreaSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    override func setupUI() {
        setupTextField()
    }
    override func bindViewModel() {
        bindVm()
        handleViewModelResponse()
        viewModel.getAllAreaOfResidence()
    }
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    @IBAction func showAreaSelect(_ sender: Any) {
        let citiesVC = SectionSearchableTableViewController(cityData: viewModel.cities)
        citiesVC.delegate = self
        viewModel.coordinator?.presentModallyWithRoot(citiesVC)
    }
    @IBAction func confirmationButtonAction(_ sender: Any) {
        guard validateInputs() == false else {
            LoadingIndicator.shared.show()
            viewModel.confirmBooking()
            return
        }
       
    }
}
extension HomeNursingViewController{
    private func bindVm(){
        nameTextField.bindText(to: viewModel.name, storeIn: &cancellables)
        phoneTextField.bindText(to: viewModel.phone, storeIn: &cancellables)
        ageTextField.bindText(to: viewModel.age, storeIn: &cancellables)
        addressTextField.bindText(to: viewModel.address, storeIn: &cancellables)
        noteTextField.bindText(to: viewModel.note, storeIn: &cancellables)
    }
}
extension HomeNursingViewController:SectionSearchableTableViewControllerDelegate {
    func sectionSearchableTableViewController(_ controller: SectionSearchableTableViewController, didSelectDistrictWithID id: Int, districtName name: String) {
        
        areaLabel.text = name
        viewModel.districtId.value = id
        isAreaSelected = true
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
    
    func sectionSearchableTableViewControllerDidTapDismiss(_ controller: SectionSearchableTableViewController) {
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
}
extension HomeNursingViewController {
    private func handleViewModelResponse(){
        viewModel.$bookingStatus
            .receive(on: DispatchQueue.main)
            .sink { status in
                guard let status = status else { return }
                switch status {
                case .success:
                    LoadingIndicator.shared.hide()
                    self.handleSucessViews()
           
                case .failure:
                    AlertManager.showAlert(on: self, title: AppLocalizedKeys.error.localized, message: AppLocalizedKeys.somethingHappen.localized)
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
}
extension HomeNursingViewController{
 private  func setupTextField(){
       nameTextField.setCharacterLimit(50)
       phoneTextField.setCharacterLimit(11)
       ageTextField.setCharacterLimit(5)
//       noteTextField.placeholder = "Write any note"
//       addressTextField.placeholder = "بيييي"
       
   }
}
extension HomeNursingViewController{
    private func validateInputs() -> Bool {
        // Validate name
        guard let name = nameTextField.text, !name.isEmpty else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidName.localized, message: AppLocalizedKeys.nameEmpty.localized)
            return false
        }
        
        let nameRegex = "^[a-zA-Z ]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        guard namePredicate.evaluate(with: name) else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidName.localized, message: AppLocalizedKeys.NameRejecs.localized)
            return false
        }
        
        // Validate phone number
        guard let phone = phoneTextField.text, !phone.isEmpty else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidNumber.localized, message: AppLocalizedKeys.phoneEmpty.localized)
            return false
        }
        
        guard phone.isValidEgyptianNumber else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidNumber.localized, message: AppLocalizedKeys.phoneRejecs.localized)
            return false
        }
        
        // Validate age
        guard let ageText = ageTextField.text, !ageText.isEmpty else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidAge.localized, message: AppLocalizedKeys.ageEmpty.localized)
            return false
        }
        
        let ageRegex = "^([1-9][0-9]?|1[01][0-9]|120)$"
        let agePredicate = NSPredicate(format: "SELF MATCHES %@", ageRegex)
        guard agePredicate.evaluate(with: ageText) else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidAge.localized, message: AppLocalizedKeys.ageRejecs.localized)
            return false
        }
        
        // Validate address
        guard let address = addressTextField.text, !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidAddress.localized, message: AppLocalizedKeys.addressEmpty.localized)
            return false
        }
        
        // Validate area selection
        guard isAreaSelected == true else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.selectArea.localized, message: AppLocalizedKeys.selectArea.localized)
            return false
        }
        
        return true
    }


}
