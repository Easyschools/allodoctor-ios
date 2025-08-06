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
    @IBOutlet weak var priceStack: UIStackView!
    @IBOutlet weak var bookingDate: UIStackView!
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
       
    }
    override func bindViewModel() {
        setupBindings()
    }
    override func setupUI() {
//        reviewView.isHidden = true
        reviewView.isHidden = true
        if viewModel.bookingData.status == "Pending"{
                    cancelView.isHidden = false
        }
        else{
            cancelView.isHidden = true
        }
       
    }
    @IBAction func navBack(_ sender: Any) {
        viewModel.navBack()
    }
    @IBAction func cancelAction(_ sender: Any) {
        viewModel.cancelReservation()
    }
    @IBAction func addReviewAction(_ sender: Any) {
        viewModel.navToReview()
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
                date.text = data.doctor?.appointmentDay.nameAr.appendingWithSpace(data.doctor?.appointmentHour.from?.convertTo12HourFormat() ?? AppLocalizedKeys.notAvailable.localized)
            }
            else{
                nameOfAppointment.text = data.doctor?.doctorServiceSpecialty?.doctor?.nameEn
                date.text = data.doctor?.appointmentDay.nameEn.appendingWithSpace(data.doctor?.appointmentHour.from?.convertTo12HourFormat() ?? AppLocalizedKeys.notAvailable.localized)
            }
            price.text = data.doctor?.doctorServiceSpecialty?.doctor?.price?.appendingWithSpace(AppLocalizedKeys.EGP.localized) ?? AppLocalizedKeys.notAvailable.localized
            adressLabel.text =  data.doctor?.doctorServiceSpecialty?.doctor?.address ?? AppLocalizedKeys.notAvailable.localized
             if viewModel.bookingData.status == "Done" {
                reviewView.isHidden = false
            }
            
        }
       else if data.typeOfBooking == "labBookings" {
           priceStack.isHidden = true
          bookingTypeImage.image = .labLogo
           bookingTypeName.text = AppLocalizedKeys.bookLabs.localized
           adressLabel.text = data.lab?.labDetails?.address  ?? AppLocalizedKeys.notAvailable.localized
           if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
               nameOfAppointment.text = data.lab?.labDetails?.nameAr  ?? AppLocalizedKeys.notAvailable.localized
               date.text = data.lab?.appointment_day?.nameAr.appendingWithSpace(data.lab?.appointment_hour?.from?.convertTo12HourFormat() ?? AppLocalizedKeys.notAvailable.localized)
               
           }
           else{
               nameOfAppointment.text = data.lab?.labDetails?.nameEn
               date.text = data.lab?.appointment_day?.nameEn.appendingWithSpace(data.lab?.appointment_hour?.from?.convertTo12HourFormat() ?? AppLocalizedKeys.notAvailable.localized)
           }
           if viewModel.bookingData.status == "Done" {
              reviewView.isHidden = false
          }
           
        }
        else if data.typeOfBooking == "homeVisitBooking"{
            bookingDate.isHidden = true
            bookingTypeImage.image = .homeVisit
            nameOfAppointment.text = data.name
            adressLabel.text = data.address
            bookingTypeName.text = AppLocalizedKeys.homeVisitBookings.localized
            price.text = AppLocalizedKeys.priceInfo.localized
            
        }
        else if data.typeOfBooking == "nurseVisitBooking"{
            bookingDate.isHidden = true
            bookingTypeImage.image = .nurse
            nameOfAppointment.text = data.name
            adressLabel.text = data.address
            bookingTypeName.text = AppLocalizedKeys.homeVisitBookings.localized
            price.text = AppLocalizedKeys.priceInfo.localized
        }
        else if data.typeOfBooking == "emergencyBooking"{
            bookingDate.isHidden = true
            bookingTypeImage.image = .operation
            nameOfAppointment.text = data.name
            adressLabel.text = data.address
            bookingTypeName.text = AppLocalizedKeys.Ambulance.localized
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
            adressLabel.text = data.operation_service?.info_service?.address ?? AppLocalizedKeys.notAvailable.localized
            price.text = data.operation_service?.price?.appendingWithSpace(AppLocalizedKeys.EGP.localized)
            }

        else if data.typeOfBooking == "intensiveCareBooking"{
            bookingDate.isHidden = true
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
