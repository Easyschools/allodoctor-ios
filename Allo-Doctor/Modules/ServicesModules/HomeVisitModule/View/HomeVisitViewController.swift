//
//  HomeVisitViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 20/11/2024.
//

import UIKit

class HomeVisitViewController: BaseViewController<HomeVisitViewModel> {
    @IBOutlet weak private var buttonView: UIView!
    @IBOutlet weak private var addressView: CustomDropShadowView!
    @IBOutlet weak private var termsAndConditionView: CustomDropShadowView!
    @IBOutlet weak var specialityName: UILabel!
    @IBOutlet weak var adressTextView: UITextView!
    @IBOutlet weak private var areaView: CustomDropShadowView!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak private var phoneNo: CustomDropShadowView!
    @IBOutlet weak private var nameView: CustomDropShadowView!
    @IBOutlet weak private var specialityView: CustomDropShadowView!
    @IBOutlet weak private var nameTextField: UITextField!
    @IBOutlet weak private var phoneNumberTextField: UITextField!
    @IBOutlet weak private var upperView: UIView!
    private var isAreaSelected = false
    private var isSpecialitySelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    override func setupUI() {
      
    }
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
        
    }
    override func bindViewModel() {
        bindVm()
        viewModel.getAllAreaOfResidence()
        handleViewModelResponse()
    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    @IBAction func specialitySelection(_ sender: Any) {
        showSpecialtySelector()
    }
    @IBAction func areaSelectionAction(_ sender: Any) {
        let citiesVC = SectionSearchableTableViewController(cityData: viewModel.cities)
        citiesVC.delegate = self
        viewModel.coordinator?.presentModallyWithRoot(citiesVC)
    }
    @IBAction func confirmBooking(_ sender: Any) {
        guard validateInputs() == false else {
            LoadingIndicator.shared.show()
            viewModel.confirmBooking()
            return
        }
    }
}
extension HomeVisitViewController{
    private func bindVm (){
        nameTextField.bindText(to: viewModel.name, storeIn: &cancellables)
        phoneNumberTextField.bindText(to: viewModel.phone, storeIn: &cancellables)
        adressTextView.bindText(to: viewModel.address, storeIn: &cancellables)
    }
}
extension HomeVisitViewController:SectionSearchableTableViewControllerDelegate {
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
extension HomeVisitViewController {
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
extension HomeVisitViewController:SpecialtySelectorDelegate {
    func showSpecialtySelector() {
           let specialtyVC = SpecialtySelectorViewController()
           specialtyVC.delegate = self
           let navController = UINavigationController(rootViewController: specialtyVC)
           present(navController, animated: true)
       }
    func specialtySelectorDidSelect(_ specialty: AllSpeciality) {
        isSpecialitySelected = true
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            specialityName.text = specialty.nameAr
        }
        else{
            specialityName.text = specialty.nameEn}
    }
    
    func specialtySelectorDidCancel() {
        
    }
}
extension HomeVisitViewController{
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
        guard let phone = phoneNumberTextField.text, !phone.isEmpty else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidNumber.localized, message: AppLocalizedKeys.phoneEmpty.localized)
            return false
        }
        
        guard phone.isValidEgyptianNumber else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidNumber.localized, message: AppLocalizedKeys.phoneRejecs.localized)
            return false
        }
        
      
        // Validate address
        guard let address = adressTextView.text, !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidAddress.localized, message: AppLocalizedKeys.addressEmpty.localized)
            return false
        }
        
        // Validate area selection
        guard isAreaSelected == true else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.selectArea.localized, message: AppLocalizedKeys.selectArea.localized)
            return false
        }
        guard isSpecialitySelected == true else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.selectSpeciality.localized, message: AppLocalizedKeys.selectSpeciality.localized)
            return false
        }
        
        return true
    }

}
