//
//  MyProfileViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 12/09/2024.
//


import Foundation
class MyProfileViewModel{
    var coordinator: HomeCoordinatorContact?
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
      
    }
    
}
extension MyProfileViewModel{
   func  navToLogin(){
       coordinator?.showPhonenumberScreen()
    }
}

