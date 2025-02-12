//
//  OneDayCareBookingViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 28/12/2024.
//

import UIKit

class OneDayCareBookingViewController: BaseViewController<OneDayCareBookingViewModel> {

    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var date: UIStackView!
    @IBOutlet weak var oneDayCarePrice: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var serviceDay: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
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
        guard validateInputs() == false else{ 
            viewModel.createBooking()
            return
        }
    }
    override func setupUI() {
        setupLabels()
    }
}
extension OneDayCareBookingViewController{
   func bindTextField(){
       nameTextField.bindText(to: viewModel.nameSubject, storeIn: &cancellables)
       phoneTextField.bindText(to: viewModel.phoneSubject, storeIn: &cancellables)
       nameTextField.setCharacterLimit(50)
       phoneTextField.setCharacterLimit(11)
   }
    func setupLabels(){
        let data = viewModel.hospitalData
        price.text = data.data.price?.appendingWithSpace(AppLocalizedKeys.EGP.localized)
      
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            serviceDay.text = viewModel.date?.convertDateFormatToArabic()
        }
        else{
            serviceDay.text = viewModel.date?.formatDateToMonth()
        }
       }
    
    private func handleViewModelResponse(){
        viewModel.$status
                   .receive(on: DispatchQueue.main)
                   .sink { status in
                       guard let status = status else { return }
                       switch status {
                       case .success:
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
extension OneDayCareBookingViewController{
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
       
        

        return true
    }
}
