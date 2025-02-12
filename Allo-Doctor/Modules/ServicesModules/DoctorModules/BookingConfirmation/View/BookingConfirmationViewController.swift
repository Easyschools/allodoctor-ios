//
//  BookingConfirmationViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/10/2024.
//

import UIKit
import Kingfisher

class BookingConfirmationViewController: BaseViewController<BookingConfirmationViewModel> {
    // MARK: - Outlets
    @IBOutlet weak var appointmentTime: CairoRegular!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var doctorImage: CircularImageView!
    @IBOutlet weak var doctorNameLabel: CairoBold!
    @IBOutlet weak var titleLabel: CairoRegular!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var appointmentDayLabel: CairoBold!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var chooseAnotherPatient: SelectableButton!
    @IBOutlet weak var fromToLabel: CairoRegular!
    @IBOutlet weak var adressLabel: CairoRegular!
    @IBOutlet weak var feesLabel: CairoRegular!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIView()
        configureChooseAnotherPatientButton()
        setupUIViewController()
    }
    
    override func bindViewModel() {
        bindTextFields()
    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    
    // MARK: - Actions
    @IBAction func navBackButtonAction(_ sender: Any) {
        viewModel.navBack()
    }
    
    @IBAction func confirmationBookingAction(_ sender: Any) {
        handleBookingConfirmation()
    }
}

// MARK: - Private Methods
private extension BookingConfirmationViewController {
    func configureChooseAnotherPatientButton() {
        chooseAnotherPatient.onSelectionChanged = { [weak self] isSelected in
            guard let self = self else { return }
            self.updateUserInteractionForTextFields(isEnabled: isSelected)
        }
    }
    
    func handleBookingConfirmation() {
        viewModel.createBooking()
        let confirmationView = ConfirmationView(frame: view.bounds)
        
        confirmationView.proceedActionPublisher
            .sink { [weak self] _ in
                self?.viewModel.navToHome()
            }
            .store(in: &cancellables)
        
        view.addSubview(confirmationView)
    }
    
    func updateUserInteractionForTextFields(isEnabled: Bool) {
        nameTextField.isUserInteractionEnabled = isEnabled
        phoneNumberTextField.isUserInteractionEnabled = isEnabled
        
        if isEnabled {
            nameTextField.text = ""
            phoneNumberTextField.text = ""
        } else {
            nameTextField.text = UserDefaultsManager.sharedInstance.getUserName()
            phoneNumberTextField.text = UserDefaultsManager.sharedInstance.getMobileNumber()
            viewModel.nameSubject.value = UserDefaultsManager.sharedInstance.getUserName() ?? ""
            viewModel.numberSubject.value = UserDefaultsManager.sharedInstance.getMobileNumber() ?? ""
        }
    }
}

// MARK: - ViewModel Binding
private extension BookingConfirmationViewController {
 
    
    func bindTextFields() {
        nameTextField.bindText(to: viewModel.nameSubject, storeIn: &cancellables)
        phoneNumberTextField.bindText(to: viewModel.numberSubject, storeIn: &cancellables)
    }
}

// MARK: - UI Setup
private extension BookingConfirmationViewController {
    func setupUIView() {
        updateUserInteractionForTextFields(isEnabled: false)
    }
    
    func setupUIViewController() {
        guard let doctorData = viewModel.doctorData else { return }
        let hours = viewModel.appoinmentHour
        configureDoctorImage(with: doctorData.mainImage)
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            doctorNameLabel.text = doctorData.nameAr
            titleLabel.text = doctorData.titleAr
            appointmentDayLabel.text = viewModel.appoinmentDay?.convertDayToArabic()
        }
        else{
            doctorNameLabel.text = doctorData.nameEn
            titleLabel.text = doctorData.titleEn
            appointmentDayLabel.text = viewModel.appoinmentDay
        }
    
        
        adressLabel.text = doctorData.address
        feesLabel.text = (doctorData.price ?? "").appendingWithSpace(AppLocalizedKeys.EGP.localized)
        appointmentTime.text = hours?.from?.convertTo12HourFormat().prepend(AppLocalizedKeys.From.localized, separator: " ").appendingWithSpace( hours?.to?.convertTo12HourFormat().prepend(AppLocalizedKeys.To.localized, separator: " ") ?? "")
    }
    
    func configureDoctorImage(with imageUrlString: String?) {
        guard let imageUrlString = imageUrlString, let imageUrl = URL(string: imageUrlString) else {
            doctorImage.image = UIImage(named: "placeholder") // Replace with your placeholder image name
            return
        }
        
        doctorImage.kf.setImage(with: imageUrl)
    }
}
