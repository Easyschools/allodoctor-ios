//
//  ProfileSettingsViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/12/2024.
//

import Foundation
class ProfileSettingsViewModel{
        var coordinator: HomeCoordinatorContact?
        var cancellables = Set<AnyCancellable>()
        private let apiClient: APIClient
        init(coordinator: HomeCoordinatorContact? = nil,apiClient: APIClient = APIClient()) {
            self.coordinator = coordinator
            self.apiClient = apiClient
        }

    }
extension ProfileSettingsViewModel{
    func navBack(){
        coordinator?.navigateBack()
    }
}
