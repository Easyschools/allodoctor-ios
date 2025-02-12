//
//  UserAddressViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 09/11/2024.
//

import UIKit

class UserAddressViewController: BaseViewController<UserAddressViewModel> {
    @IBOutlet weak var appartmentTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var adressView: UIView!
    @IBOutlet weak var apartmentView: UIView!
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var floorView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setupUI() {
        setupTextFieldValidation()
    }
    override func bindViewModel() {
        bindVmData()
    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    @IBAction func saveAdressAction(_ sender: Any) {
       
            // Validate the text fields
            let isAddressValid = addressTextField.validateNotEmpty(message: "Please enter an address", viewController: self)
            let isFloorValid = floorTextField.validateNotEmpty(message: "Please enter the floor number", viewController: self)
            let isAppartmentValid = appartmentTextField.validateNotEmpty(message: "Please enter the apartment number", viewController: self)


            if isAddressValid && isFloorValid && isAppartmentValid {
               
                viewModel.addUserAdress()
            }
        }

    }

extension UserAddressViewController{
   private func setupTextFieldValidation() {
      
       addressTextField.setCharacterLimit(200)
       floorTextField.setCharacterLimit(10)
       appartmentTextField.setCharacterLimit(5)
    }
private func  bindVmData(){
    addressTextField.bindText(to: viewModel.address , storeIn: &cancellables)
    floorTextField.bindText(to: viewModel.floor, storeIn: &cancellables)
    appartmentTextField.bindText(to: viewModel.appartmentNumber, storeIn: &cancellables)
    }
}
extension  UserAddressViewController{
   
}
