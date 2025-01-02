//
//  UserAddressViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 09/11/2024.
//

import Foundation
class UserAddressViewModel{
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
    extension UserAddressViewModel{
    func getUserAddresses(){
            let router = APIRouter.fetchUserAddresses
                apiClient.fetchData(from: router.url, as: UserAddressResponse.self)
                    .sink(receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            print("Error: \(error)")
                            self?.errorMessage = "Failed to fetch Pharamcy: \(error.localizedDescription)"}
                    }, receiveValue: { [weak self]  address in
                        self?.userAddresses = address.data
                    }).store(in: &cancellables)
                
            }
        
        }



