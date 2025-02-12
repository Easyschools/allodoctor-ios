//
//  nonAuthUserViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 02/12/2024.
//

import Foundation
class NonAuthUserViewModel{
    var coordinator: HomeCoordinatorContact?
    private let apiClient: APIClient
    init(coordinator: HomeCoordinatorContact? = nil,apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }
}
extension NonAuthUserViewModel{
  func navToPHoneNumber(){
      coordinator?.showPhonenumberScreen()
    }
}
