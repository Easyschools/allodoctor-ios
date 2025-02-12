//
//  AppointmentsActivityViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 06/01/2025.
//

import UIKit

class AppointmentsActivityViewController: BaseViewController<AppointmentsActivityViewModel> {
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var reviewView: UIStackView!
    @IBOutlet weak var bookingTypeImage: UIImageView!
    @IBOutlet weak var bookingTypeName: UILabel!
    @IBOutlet weak var cancelView: ShadowView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var nameOfAppointment: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 25)
        reviewView.isHidden = true
    }
    override func bindViewModel() {
        setupBindings()
    }
    override func setupUI() {
//        reviewView.isHidden = true

        if viewModel.bookingData.status == "Canceled"{
                    cancelView.isHidden = true
        }
    }
    @IBAction func navBack(_ sender: Any) {
        viewModel.navBack()
    }
    @IBAction func cancelAction(_ sender: Any) {
        viewModel.cancelReservation()
    }
    func setupBindings(){
        viewModel.$cancelStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let status = status else { return }
                switch status {
                case .success:
                    self?.handleSucessViews()
                case .failure:
                    AlertManager.showAlert(on: self!, title: AppLocalizedKeys.error.localized, message:  AppLocalizedKeys.somethingHappen.localized)
                }
            }.store(in: &cancellables)
       viewModel.$bookingData
               .receive(on: DispatchQueue.main)
               .sink { [weak self] _ in
                   self?.setupUi()
               }.store(in: &cancellables)
           
    }
}
extension AppointmentsActivityViewController{
    func setupUi(){
        let data = viewModel.bookingData
        if data.typeOfBooking == "booking" {
            bookingTypeImage.image = .doctorOfferIcon
            bookingTypeName.text = AppLocalizedKeys.doctors.localized
            if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
                nameOfAppointment.text = data.doctor?.doctorServiceSpecialty?.doctor?.nameAR
                
            }
            else{
                nameOfAppointment.text = data.doctor?.doctorServiceSpecialty?.doctor?.nameEn
            }
            price.text = data.doctor?.doctorServiceSpecialty?.doctor?.price?.appendingWithSpace(AppLocalizedKeys.EGP.localized)
            adressLabel.text =  data.doctor?.doctorServiceSpecialty?.doctor?.address
            
            
        }
       else if data.typeOfBooking == "labBookings" {
            bookingTypeImage.image = .labLogo
           bookingTypeName.text = AppLocalizedKeys.bookLabs.localized
           
           
        }
        else if data.typeOfBooking == "homeVisitBooking"{
            bookingTypeImage.image = .homeVisit
            nameOfAppointment.text = data.name
            adressLabel.text = data.address
            bookingTypeName.text = AppLocalizedKeys.homeVisitBookings.localized
            price.text = AppLocalizedKeys.priceInfo.localized
            
        }
        else if data.typeOfBooking == "nurseVisitBooking"{
            bookingTypeImage.image = .nurse
            nameOfAppointment.text = data.name
            adressLabel.text = data.address
            bookingTypeName.text = AppLocalizedKeys.homeVisitBookings.localized
            price.text = AppLocalizedKeys.priceInfo.localized
        }
        else if data.typeOfBooking == "operationBookings"{
            let data = viewModel.bookingData
            bookingTypeImage.image = .operation
            bookingTypeName.text = AppLocalizedKeys.operationBookings.localized
            if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            nameOfAppointment.text = data.operation_service?.operation?.nameAr
            }
            else{
                nameOfAppointment.text = data.operation_service?.operation?.nameEn
            }
            adressLabel.text = data.operation_service?.info_service?.address
            price.text = data.operation_service?.price?.appendingWithSpace(AppLocalizedKeys.EGP.localized)
            }

        else if data.typeOfBooking == "intensiveCareBooking"{
            bookingTypeImage.image = .intesiveCare
            bookingTypeName.text = AppLocalizedKeys.intensiveCareBooking.localized
            price.text = AppLocalizedKeys.priceInfo.localized
        }
    }
  
}
extension AppointmentsActivityViewController{
    private func handleSucessViews(){
        
        let confirmationView = ConfirmationView(frame: view.bounds)
        confirmationView.setupView(message: AppLocalizedKeys.reservestionCancelled.localized, description:  AppLocalizedKeys.reservationCancelledSuccessfully.localized)
        confirmationView.proceedActionPublisher
            .sink { [weak self] _ in
                self?.viewModel.navBack()
            }
            .store(in: &cancellables)
        // Add it to the view controller's view
        view.addSubview(confirmationView)
    }
}
