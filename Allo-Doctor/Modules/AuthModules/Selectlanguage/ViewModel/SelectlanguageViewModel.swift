//
//  SelectlanguageViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/09/2024.
//

import Foundation
class SelectlanguageViewModel{
    var coordinator:HomeCoordinatorContact?
    
}
extension SelectlanguageViewModel {
    func goToBordingScreen(){
        coordinator?.showPhonenumberScreen()
    }
}
