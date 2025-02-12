//
//  InsuranceSelectViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 12/12/2024.
//

import Foundation
class InsuranceSelectViewModel{
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var  userInsurance: [UserInsurance]?
    private var apiClient: APIClient
    
    // Initializer
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }
}
extension InsuranceSelectViewModel{
    func navToAddInsurance(){
        coordinator?.showAddInsurnace()
    }
    func navBack(){
        coordinator?.navigateBack()
    }
    func navToInsuranceDelete(userInsurance:UserInsurance){
        coordinator?.showInsuranceDetails(userInsurance: userInsurance)
    }
}
extension InsuranceSelectViewModel{
    func fetchUserInsurance() {
        let router = APIRouter.fetchUserInsurance
        apiClient.fetchData(from: router.url, as: UserInsuranceResponse.self)
            .sink(receiveCompletion: {  completion in
                switch completion {
                case .failure(let error):
                 print(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.userInsurance = response.data
            }).store(in: &cancellables)
    }
}
