//
//  SelectChatTypeViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 26/05/2025.
//
import Foundation
class SelectChatTypeViewModel{
    // MARK: - Properties
    var coordinator: HomeCoordinatorContact?
    private let apiClient: APIClient
    private var cancellables = Set<AnyCancellable>()
   
   
    // MARK: - Initialization
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }
    
}
extension SelectChatTypeViewModel {
    func navToChat(chatType:chatType){
        coordinator?.showChatViewController(chatType: chatType)
    }
    func navBack(){
        coordinator?.navigateBack()
    }
}
