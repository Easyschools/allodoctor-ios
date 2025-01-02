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
        
    }
    @IBAction func selectInsurance(_ sender: Any) {
        
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
        let isIdNumberValid = idNumber.validateNotEmpty(message: "Id number Field is required", viewController: self)
        let isAgeValid = ageTextField.validateNotEmpty(message: "Age Field is required", viewController: self) &&
                         ageTextField.validateNumberInRange(min: 10, max: 99, message: "Age must be between 10 and 99", viewController: self)
        if insuranceCard == nil {
            AlertManager.showInternetAlert(on: self, message: "Please ADD card")
        }
         
        if isIdNumberValid && isAgeValid && insuranceCard != nil {
            viewModel.addInsurance()
        }
    }
   
}
extension UserInsuranceViewController{
    private func bindVm(){
        idNumber.bindText(to: viewModel.idNumber, storeIn: &cancellables)
        ageTextField.bindText(to: viewModel.age, storeIn: &cancellables)
        
        //        daysDropDownView.selectionPublisher
        //            .sink { [weak self] day in
        //                self?.viewModel.day.value = day
        //            }
        //            .store(in: &cancellables)
        //        monthDropDownView.selectionPublisher
        //            .sink { [weak self] month in
        //                let month = month.monthNumber()
        //                self?.viewModel.month.value = month?.toString() ?? ""
        //            }
        //            .store(in: &cancellables)
        //        yearsDropDownView.selectionPublisher
        //            .sink { [weak self] year in
        //                self?.viewModel.year.value = year
        //            }
        //        .store(in: &cancellables)}
    }
}
