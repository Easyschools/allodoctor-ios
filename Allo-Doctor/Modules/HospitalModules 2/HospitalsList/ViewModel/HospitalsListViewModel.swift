//
//  HospitalsListViewModel.swift
//  Allo-Doctor
//
//  Created by Assistant on 14/11/2025.
//

import Foundation
import Combine

class HospitalsListViewModel {
    // MARK: - Published Properties
    @Published var hospitals: [HospitalInfoService] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    // MARK: - Properties
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    private var apiClient: APIClient

    // MARK: - Initialization
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }

    // MARK: - API Methods
    func fetchHospitals() {
        isLoading = true
        let router = APIRouter.fetchHospitals(isPaginate: 50, serviceId: 1)

        apiClient.fetchData(from: router.url, as: HospitalResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch hospitals: \(error.localizedDescription)"
                    print("Error fetching hospitals: \(error)")
                }
            }, receiveValue: { [weak self] hospitalResponse in
                self?.hospitals = hospitalResponse.data
                print("Fetched \(hospitalResponse.data.count) hospitals")
            })
            .store(in: &cancellables)
    }

    // MARK: - Navigation Methods
    func navigateToHospitalSpecialties(hospital: HospitalInfoService) {
        coordinator?.showHospitalSpecialties(hospital: hospital)
    }

    func navigateBack() {
        coordinator?.navigateBack()
    }
}
