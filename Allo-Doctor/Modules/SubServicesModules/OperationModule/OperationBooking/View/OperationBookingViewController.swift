//
//  OperationBookingViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 17/11/2024.
//

import UIKit

class OperationBookingViewController: BaseViewController<OperationBookingViewModel> {
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var patientName: UITextField!
    @IBOutlet weak var operationPrice: UILabel!
    @IBOutlet weak var operationDate: UILabel!
    @IBOutlet weak var patientPhone: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func bindViewModel() {
        bindTextField()
        handleViewModelResponse()
    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    @IBAction func confirmBooking(_ sender: Any) {
        if validateInputs() {
            viewModel.createBooking()
        }
       
    }
    override func setupUI() {
        setupLabels()
    }
}
extension OperationBookingViewController{
   func bindTextField(){
       patientName.bindText(to:viewModel.nameSubject, storeIn: &cancellables)
       patientPhone.bindText(to:viewModel.phoneSubject, storeIn: &cancellables)
       patientName.setCharacterLimit(50)
       patientPhone.setCharacterLimit(11)
   }
    func setupLabels(){
        let data = viewModel.hospitalData
        operationPrice.text = data.price?.appendingWithSpace(AppLocalizedKeys.EGP.localized)
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            operationDate.text = viewModel.date?.convertDateFormatToArabic()
        }
        else{
            operationDate.text = viewModel.date?.formatDateToMonth()}
       }
    private func handleViewModelResponse(){
        viewModel.$status
                   .receive(on: DispatchQueue.main)
                   .sink { status in
                       guard let status = status else { return }
                       switch status {
                       case .success:
                           self.viewModel.navToOperationConfirmed()
                       case .failure:
                           AlertManager.showAlert(on: self, title: "Something Happend", message: "Something Happend")
                        
                       }
                   }
                   .store(in: &cancellables)
    }
}
extension OperationBookingViewController{
    private func validateInputs() -> Bool {
        // Validate name
        guard let name = patientName.text, !name.isEmpty else {
            AlertManager.showAlert(on: self, title: "Error", message: "Name cannot be empty.")
            return false
        }
        
        let nameRegex = "^[a-zA-Z ]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        guard namePredicate.evaluate(with: name) else {
            AlertManager.showAlert(on: self, title: "Error", message: "Name must contain only letters and spaces.")
            return false
        }
        
        // Validate phone number
        guard let phone = patientPhone.text, !phone.isEmpty else {
            AlertManager.showAlert(on: self, title: "Error", message: "Phone number cannot be empty.")
            return false
        }
        
        // Use the isValidEgyptianNumber extension to validate the phone number
        guard phone.isValidEgyptianNumber else {
            AlertManager.showAlert(on: self, title: "Error", message: "Invalid phone number. Please enter a valid Egyptian number.")
            return false
        }

        return true
    }

}



