//
//  OneDayCareProfileViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 26/12/2024.
//

import Foundation
import Combine

protocol OneDayCareProfileViewModelProtocol {
    var hospitalData: OneDayCareHospitals? { get }
    var isLoading: Bool { get }
    var error: Error? { get }
    
    func getHospitalData()
    func showOneDayCareAppointments(serviceId: Int)
}

class OneDayCareProfileViewModel: OneDayCareProfileViewModelProtocol {
    // MARK: - Published Properties
    @Published private(set) var hospitalData: OneDayCareHospitals?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    // MARK: - Private Properties
    private let coordinator: HomeCoordinatorContact
    private let apiClient: APIClientProtocol
    private let hospitalId: Int
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(
        coordinator: HomeCoordinatorContact,
        apiClient: APIClientProtocol = APIClient(),
        hospitalId: Int
    ) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.hospitalId = hospitalId
    }
    
    // MARK: - Public Methods
    func getHospitalData() {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        let router = APIRouter.fetchHospitalData(hospitalId: hospitalId)
        
        apiClient.fetchData(from: router.url, as: OneDayCareHospitalsResponse.self)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            })
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleError(error)
                }
            } receiveValue: { [weak self] response in
                self?.hospitalData = response.data
            }
            .store(in: &cancellables)
    }
    
    func showOneDayCareAppointments(serviceId: Int) {
        coordinator.showOneDayCareAppointments(serviceId: serviceId)
    }
    
    // MARK: - Private Methods
    private func handleError(_ error: Error) {
        self.error = error
        #if DEBUG
        print("Error fetching hospital data:", error)
        #endif
    }
}
extension OneDayCareProfileViewModel{
    func navBack() {
        coordinator.navigateBack()
    }
}

// MARK: - Protocol Definitions
protocol APIClientProtocol {
    func fetchData<T: Decodable>(from url: URL, as type: T.Type) -> AnyPublisher<T, Error>
}

extension APIClient: APIClientProtocol {}

