//
//  SubServiceViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 16/09/2024.
//

import Foundation
class SubServiceViewModel{
    @Published var subServices: [SubService] = []
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    private var apiClient = APIClient()
    var coordinator: HomeCoordinatorContact?
    init(coordinator: HomeCoordinatorContact? = nil,apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }

}
extension SubServiceViewModel{
    func fetchSubServices() {
        let router = APIRouter.fetchSubServices(isPaginate: 15)
        
        apiClient.fetchData(from: router.url, as: SubServiceResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                   break
                case .failure(let error):
                  self.errorMessage = "Failed to fetch Services: \(error.localizedDescription)"
                }
            }, receiveValue: { subServiceResponse in
                self.subServices = subServiceResponse.data
                print(subServiceResponse.data)
            })
            .store(in: &cancellables)
        
    }
    func navToSearchScreen() {
        coordinator?.showSearchScreen()
    }
    func showHospitalSearch(){
        coordinator?.showHospitalSearch()
    }
    func showEmergency(){
        coordinator?.showEmergency()
    }
    func showChat(){
        coordinator?.showSelectChatTypeViewController()
    }
}
