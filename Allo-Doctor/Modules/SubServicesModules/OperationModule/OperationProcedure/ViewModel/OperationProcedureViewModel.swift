//
//  OperationProcedureViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/12/2024.
//

import Foundation
class OperationProcedureViewModel{
    private var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    private var apiClient = APIClient()
    @Published var operationServiceId: Int?

    @Published var operationProcedure : OperationProcedure?
  
    // MARK: - ViewModel init
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), operationServiceId: Int) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.operationServiceId = operationServiceId
   
    }
    func getOperationProcedure() {
        let router = APIRouter.fetchOperationProcdure(operationServiceId: operationServiceId ?? 0)
        apiClient.fetchData(from: router.url, as: OperationProcedureResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Failed to fetch Cities: \(error.localizedDescription)"
                }
            }, receiveValue: { procedure in
                self.operationProcedure = procedure.data
            })
            .store(in: &cancellables)
    }

}
extension OperationProcedureViewModel{
    func navBack(){
        coordinator?.navigateBack()
    }
    func navToHome(){
        coordinator?.navigateToRoot()
    }
}
