//
//  MyProfileViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 12/09/2024.
//


import Foundation
import UIKit
class MyProfileViewModel{
    var coordinator: HomeCoordinatorContact?
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
      
    }
    
}
extension MyProfileViewModel{
    func  navToLogin(){
        coordinator?.showSplashScreen()
    }
    func navToProfileEdit(){
        coordinator?.showProfileEdit()
    }
    func navToInsuranceSelect()
    {
        coordinator?.showAlluserInsurance()
    }
    func navToProfileSettings(){
        coordinator?.showProfileSettings()
    }
    func showMedicalInfo(){
        coordinator?.showProfileMedical()
    }
    func showFavourites(){
        coordinator?.showProfileFavouritesViewController()
    }
    func showProfileSupport(){
        coordinator?.showProfileSuppotViewController()
    }
}

