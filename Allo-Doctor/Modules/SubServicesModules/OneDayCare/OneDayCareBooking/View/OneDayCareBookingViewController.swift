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

        if let dateStr = viewModel.date, !dateStr.isEmpty {
            if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
                serviceDay.text = dateStr.convertDateFormatToArabic()
            } else {
                serviceDay.text = dateStr.formatDateToMonth()
            }
        } else {
            setupDatePicker()
        }
    }

    private func setupDatePicker() {
        serviceDay.text = "Select Date"
        serviceDay.textColor = .blueApp
        serviceDay.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        serviceDay.addGestureRecognizer(tapGesture)
    }

    @objc private func showDatePicker() {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        datePicker.calendar = Calendar(identifier: .gregorian)
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
            datePicker.locale = Locale(identifier: "ar")
        } else {
            datePicker.locale = Locale(identifier: "en")
        }
        datePicker.frame = CGRect(x: 0, y: 0, width: alertController.view.bounds.width - 20, height: 200)
        alertController.view.addSubview(datePicker)

        let confirmAction = UIAlertAction(title: AppLocalizedKeys.Confirm.localized, style: .default) { [weak self] _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "en")
            formatter.calendar = Calendar(identifier: .gregorian)
            let apiDate = formatter.string(from: datePicker.date)
            self?.viewModel.date = apiDate

            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
                displayFormatter.locale = Locale(identifier: "ar")
            } else {
                displayFormatter.locale = Locale(identifier: "en")
            }
            displayFormatter.calendar = Calendar(identifier: .gregorian)
            self?.serviceDay.text = displayFormatter.string(from: datePicker.date)
            self?.serviceDay.textColor = .black
        }

        let cancelAction = UIAlertAction(title: AppLocalizedKeys.cancelled.localized, style: .cancel)

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
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

        // Validate date is selected
        guard let dateStr = viewModel.date, !dateStr.isEmpty else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.error.localized, message: "Please select a date.")
            return false
        }

        return true
    }
}
