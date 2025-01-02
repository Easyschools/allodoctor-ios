//
//  UserAdressSelectViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 05/11/2024.
//

import Foundation
class UserAdressSelectViewModel{
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    private var apiClient = APIClient()
    @Published var userAddresses : [UserAddress]?
    
//    @Published var productId:Int?
    
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
   
       
    }}
extension UserAdressSelectViewModel{
    func getUserAddresses() {
        let router = APIRouter.fetchUserAddresses
        apiClient.fetchData(from: router.url, as: UserAddressResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self?.errorMessage = "Failed to fetch address: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] addressResponse in
                // Filter out addresses that are nil or empty
                self?.userAddresses = addressResponse.data?.filter { $0.address != nil && !$0.address!.isEmpty }
            })
            .store(in: &cancellables)
    }

}
