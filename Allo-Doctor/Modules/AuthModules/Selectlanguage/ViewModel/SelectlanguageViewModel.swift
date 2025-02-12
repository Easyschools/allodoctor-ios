//
//  SelectlanguageViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/09/2024.
//

import Foundation
class SelectlanguageViewModel{
    var coordinator:HomeCoordinatorContact?
    
init(coordinator: HomeCoordinatorContact? = nil) {
    self.coordinator = coordinator

}}
extension SelectlanguageViewModel {
    func handleAppLaunch() {
        if UserDefaultsManager.sharedInstance.checkingShowingOnboarding() {
            goToPhoneNoScreen()
      
        } else {
            // Show the onboarding flow
            goToBordingScreen()
        }
    }
  private  func goToBordingScreen(){
        coordinator?.showOnboardingScreen()
    }
   private  func goToPhoneNoScreen(){
        coordinator?.showPhonenumberScreen()
    }
    
}
