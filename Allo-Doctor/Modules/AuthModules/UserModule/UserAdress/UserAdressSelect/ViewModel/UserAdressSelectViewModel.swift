//
//  UserAdressSelectViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 05/11/2024.
//

import Combine

class UserAdressSelectViewModel {
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    @Published var userAddresses: [UserAddress]?
    @Published var isLoading = false // Track loading state
    private var apiClient = APIClient()

    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }
}

extension UserAdressSelectViewModel {
    func getUserAddresses() {
        isLoading = true // Start loading
        let router = APIRouter.fetchUserAddresses
        apiClient.fetchData(from: router.url, as: UserAddressResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false // Stop loading
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self?.errorMessage = "Failed to fetch address: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] addressResponse in
                self?.userAddresses = addressResponse.data?.filter { $0.address != nil && !$0.address!.isEmpty }
            })
            .store(in: &cancellables)
    }
}
