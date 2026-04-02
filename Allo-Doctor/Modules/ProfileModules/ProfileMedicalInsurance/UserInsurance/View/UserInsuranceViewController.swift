//
//  UserInsuranceViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 12/12/2024.
//

import UIKit
import PhotosUI

class UserInsuranceViewController: BaseViewController<UserInsuranceViewModel>, PHPickerViewControllerDelegate {
    @IBOutlet weak var upperView: UIView!

    @IBOutlet weak var insuranceProviderLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var insuranceCard: UIImageView!
    @IBOutlet weak var idNumber: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        idNumber.setCharacterLimit(40)
        ageTextField.setCharacterLimit(10)
        deleteButton.isHidden = true
        bindVm()

    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    override func bindViewModel() {
        bindVM()
        bindVm()
    }

    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    @IBAction func cancelAction(_ sender: Any) {
        viewModel.navBack()
    }
    @IBAction func saveAction(_ sender: Any) {
       setupValidate()
    }
    @IBAction func addCardAction(_ sender: Any) {
        openImagePicker()
    }
    @IBAction func deleteButtonAction(_ sender: Any) {
        viewModel.deleteImage()
        
    }
    @IBAction func selectInsurance(_ sender: Any) {
        let insuranceVC = InsuranceCompanyTableViewController()
        insuranceVC.delegate = self
        viewModel.coordinator?.presentModallyWithRoot(insuranceVC)
    }
}
extension UserInsuranceViewController{
   private func bindVM(){
        viewModel.$selectedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.insuranceCard.image = image
                self?.deleteButton.isHidden = (image == nil)
            }
            .store(in: &cancellables)
  
       viewModel.$status
           .receive(on: DispatchQueue.main)
           .sink { [weak self] status in
               LoadingIndicator.shared.hide()
               guard let status = status else { return }
               switch status {
               case .success:
                 
                   self?.handleSucessViews()
               case .failure:
                   AlertManager.showAlert(on: self!, title:AppLocalizedKeys.error.localized, message: AppLocalizedKeys.somethingHappen.localized)
               }
           }
           .store(in: &cancellables)
    }
    @objc private func openImagePicker() {
           var config = PHPickerConfiguration()
           config.selectionLimit = 1
           config.filter = .images

           let picker = PHPickerViewController(configuration: config)
           picker.delegate = self
           present(picker, animated: true)
       }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
           dismiss(animated: true)

           guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }

           provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
               if let image = object as? UIImage {
                   self?.viewModel.saveImage(image)
               }
           }
       }
    @objc private func deleteImage() {
           viewModel.deleteImage()
       }
    func setupValidate() {
        // Validate insurance provider selection first
        guard viewModel.insuranceId.value != 0 else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.error.localized, message: AppLocalizedKeys.insuranceProviderEmpty.localized)
            return
        }

        // Validate age
        guard let ageText = ageTextField.text, !ageText.isEmpty else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.error.localized, message: AppLocalizedKeys.ageEmpty.localized)
            return
        }

        guard let age = Int(ageText), age >= 10 && age <= 99 else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.error.localized, message: AppLocalizedKeys.ValidAge.localized)
            return
        }

        // Validate ID number
        guard let idNumberText = idNumber.text, !idNumberText.isEmpty else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.error.localized, message: AppLocalizedKeys.idNumberEmpty.localized)
            return
        }

        // Validate insurance card photo
        guard viewModel.selectedImage != nil else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.error.localized, message: AppLocalizedKeys.pleaseAddInsuranceCardPhoto.localized)
            return
        }

        LoadingIndicator.shared.show()
        viewModel.addInsurance()
    }
   
}
extension UserInsuranceViewController{
    private func bindVm(){
        idNumber.bindText(to: viewModel.idNumber, storeIn: &cancellables)
        ageTextField.bindText(to: viewModel.age, storeIn: &cancellables)
    }
}
extension UserInsuranceViewController:InsuranceCompanyTableViewControllerDelegate {
    func insuranceCompanyTableViewController(_ controller: InsuranceCompanyTableViewController, didSelectItem item: InsuranceCompany) {
        insuranceProviderLabel.text = item.name_en
        viewModel.insuranceId.value = item.id
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
        
    }
    
    func insuranceCompanyTableViewControllerDidTapDismiss(_ controller: InsuranceCompanyTableViewController) {
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
}
extension UserInsuranceViewController{
    private func handleSucessViews(){
        let confirmationView = ConfirmationView(frame: view.bounds)
        confirmationView.setupView(message: AppLocalizedKeys.insuranceAdded.localized, description: AppLocalizedKeys.insuranceAddedSuccessfully.localized)
        confirmationView.proceedActionPublisher
            .sink { [weak self] _ in
                self?.viewModel.navBack()
            }
            .store(in: &cancellables)
        // Add it to the view controller's view
        view.addSubview(confirmationView)
    }
    private func validateInputs() -> Bool {
        // Validate name
        guard let idNumber = idNumber.text, !idNumber.isEmpty else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.InvalidName.localized, message: AppLocalizedKeys.nameEmpty.localized)
            return false
        }
        return true
    }
}
