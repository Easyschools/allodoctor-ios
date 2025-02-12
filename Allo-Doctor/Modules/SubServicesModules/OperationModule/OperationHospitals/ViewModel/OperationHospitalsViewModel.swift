//
//  OperationHospitalsViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 17/11/2024.
//

import Foundation
class OperationHospitalsViewModel{   
    // MARK: - Proprties
   var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    private var apiClient = APIClient()
    @Published var operationId: Int?
    @Published var cities: [City] = []
    @Published var operationData: OperationData?
    // MARK: - ViewModel init
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), operationId: Int) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.operationId = operationId
    }
}

// MARK: - Fetching Pharmacy Cart
extension OperationHospitalsViewModel {
    func getOperationData(search:String,districtId:String) {
        getOperationData(operationId: operationId ?? 0, search: search, districtId:districtId)
    }
 
    private func getOperationData(operationId: Int,search:String,districtId:String) {
        let router = APIRouter.fetchOperationData(operationId: operationId, search: search, districtId: districtId)
        print(router.url)
        apiClient.fetchData(from: router.url, as: OperationDataResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self?.errorMessage = "Failed to fetch operation Data: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] operation in
                self?.operationData = operation.data
            })
            .store(in: &cancellables)
    }
    func getAllAreaOfResidence() {
        let router = APIRouter.fetchCities
        apiClient.fetchData(from: router.url, as: CityDataResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Failed to fetch Cities: \(error.localizedDescription)"
                }
            }, receiveValue: { citiesResponse in
                self.cities = citiesResponse.data ?? []
            })
            .store(in: &cancellables)
    }
    func navBack(){
        coordinator?.navigateBack()
    }
}
