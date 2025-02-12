//
//  InsuranceDeleteViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/01/2025.
//

import Foundation
class InsuranceDeleteViewModel{
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var userInsurance: UserInsurance?
    private var apiClient: APIClient
    @Published var deleteState: BookingStatus?
    
    // Initializer
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), userInsurance:UserInsurance) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.userInsurance = userInsurance
    }
    func deleteInsurance(){
        let router = APIRouter.deleteInsurance(id:userInsurance?.id ?? 0)
        print(router.url)
        apiClient.deleteData(from: router.url, as: DeleteResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.deleteState = .success
                    print("Delete request completed successfully.")
                case .failure(let error):
                    self.deleteState = .failure
                    print("Error during delete request: \(error)")
                }
            }, receiveValue: { response in
                print("Message: \(response.Message)")
                print("Data: \(response.data)")
            })
        .store(in: &cancellables)}
}
extension InsuranceDeleteViewModel{
    func navBack(){
        coordinator?.navigateBack()
    }
}
