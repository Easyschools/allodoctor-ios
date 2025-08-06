//
//  ProfileSuppotViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/01/2025.
//

import Foundation
import UIKit
class ProfileSuppotViewModel{
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?

    private var apiClient: APIClient
    
    // Initializer
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }
}
extension ProfileSuppotViewModel {
    func showChat(){
        coordinator?.showChatViewController(chatType:.customerServiceType)
    }
    func navBack(){
        coordinator?.navigateBack()
    }
    func showNumberView(uiviewController:UIViewController){
        UIHelper.showCallActionSheet(phoneNumber: "010104561837", on: uiviewController)
    }
}
