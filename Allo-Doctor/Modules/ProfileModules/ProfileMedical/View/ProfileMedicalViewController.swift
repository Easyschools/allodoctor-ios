//
//  ProfileMedicalViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/12/2024.
//

import UIKit

class ProfileMedicalViewController: BaseViewController<ProfileMedicalViewModel> {

    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var navBackButton: CustomNavigationBackButton!
    @IBOutlet weak var confirmationButton: CustomButton!
    @IBOutlet weak var medicalHistoryTextView: CustomTextView!
    @IBOutlet weak var allergieTextView: CustomTextView!
    @IBOutlet weak var medicineTextView: CustomTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmationButton.setTitle(AppLocalizedKeys.Confirm.localized, for: .normal)
        navBackButton.setTitle(AppLocalizedKeys.myMedicalInfo.localized)

    }

    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    
    override func bindViewModel() {
        viewModel.fetchMedicalData()
        bindData()
        setupTextView()
    }
    @IBAction func confirmationButton(_ sender: Any) {
        viewModel.confirmBooking()
 
    }
 private func setupTextView(){
     medicineTextView.placeholder = AppLocalizedKeys.myMedicalInfo.localized
     medicalHistoryTextView.placeholder = AppLocalizedKeys.myMedicalInfo.localized
     allergieTextView.placeholder = AppLocalizedKeys.myMedicalInfo.localized
     allergieTextView.bindText(to: viewModel.allergy, storeIn: &cancellables)
     medicineTextView.bindText(to: viewModel.medication, storeIn: &cancellables)
     medicalHistoryTextView.bindText(to: viewModel.medicalHistory, storeIn: &cancellables)
    }
    private func  bindData(){
        viewModel.$medicalData
                   .receive(on: DispatchQueue.main)
                   .sink { [weak self] subServices in
                       self?.medicalHistoryTextView.text =  subServices?.medicalHistory
                       self?.allergieTextView.text = subServices?.allergy
                       self?.medicineTextView.text = subServices?.medication
                   }.store(in: &cancellables)
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
       
}
extension ProfileMedicalViewController{
    private func handleSucessViews(){
        
        let confirmationView = ConfirmationView(frame: view.bounds)
        confirmationView.setupView(message: AppLocalizedKeys.medicalInfoUpdated.localized, description:  AppLocalizedKeys.medicalInfoUpdatedSuccesfully.localized)
        confirmationView.proceedActionPublisher
            .sink { [weak self] _ in
                self?.viewModel.navBack()
            }
            .store(in: &cancellables)
        // Add it to the view controller's view
        view.addSubview(confirmationView)
    }
}
