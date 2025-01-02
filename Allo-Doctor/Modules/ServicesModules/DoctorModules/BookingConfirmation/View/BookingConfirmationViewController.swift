//
//  BookingConfirmationViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/10/2024.
//

import UIKit

class BookingConfirmationViewController: BaseViewController<BookingConfirmationViewModel> {
    @IBOutlet weak var doctorNameLabel: CairoBold!
    @IBOutlet weak var titleLabel: CairoRegular!
    @IBOutlet weak var appointmentDayLabel: CairoBold!
    @IBOutlet weak var fromToLabel: CairoRegular!
    @IBOutlet weak var adressLabel: CairoRegular!
    
    @IBOutlet weak var feesLabel: CairoRegular!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func bindViewModel() {
        bindViewModelData()
    }
    @IBAction func navBackButtonAction(_ sender: Any) {
        viewModel.navBack()
    }
    
    @IBAction func confirmationBookingAction(_ sender: Any) {
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
extension BookingConfirmationViewController{
  func bindViewModelData(){
        viewModel.$appoinmentDay.receive(on: DispatchQueue.main)
            .sink { day in
                self.appointmentDayLabel.text = day?.uppercased()
                print(day ?? "no")
            }.store(in: &cancellables)
      viewModel.$appoinmentHour.receive(on: DispatchQueue.main)
          .sink { hour in
              self.fromToLabel.text = "From \(hour?.from.convertTo12HourFormat() ?? "") To \(hour?.to.convertTo12HourFormat() ?? "")"
          }.store(in: &cancellables)
      viewModel.$doctorData.receive(on: DispatchQueue.main)
          .sink { doctorData in
              self.setupUIViewController()
          }.store(in: &cancellables)
    }
    
}
extension BookingConfirmationViewController{
    private func setupUIViewController() {
        let doctorData = viewModel.doctorData
        doctorNameLabel.text = doctorData?.name
        titleLabel.text = doctorData?.titleEn
        adressLabel.text = doctorData?.address
        feesLabel.text = (doctorData?.price ?? "") + " EGP"
    }
}
