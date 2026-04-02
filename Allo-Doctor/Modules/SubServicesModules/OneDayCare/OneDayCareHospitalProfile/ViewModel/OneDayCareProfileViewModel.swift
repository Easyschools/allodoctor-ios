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
                if response.data?.oneDayServices?.isEmpty ?? true {
                    self?.fetchDayServicesAsFallback()
                }
            }
            .store(in: &cancellables)
    }
    
    func showOneDayCareAppointments(serviceId: Int) {
        // Find the selected service to get price info
        let selectedService = hospitalData?.oneDayServices?.first(where: { $0.id == serviceId })
        let appointmentData = OneDayCareAppointmentsModel.AppointmentData(
            id: selectedService?.id,
            price: selectedService?.price,
            from: selectedService?.from,
            to: selectedService?.to,
            infoService: nil,
            dayService: nil,
            days: nil
        )
        let hospitalModel = OneDayCareAppointmentsModel(data: appointmentData)
        coordinator.showOneDayCareBooking(dayServiceId: serviceId, date: "", hospitalData: hospitalModel, infoServiceId: hospitalId)
    }
    
    private func fetchDayServicesAsFallback() {
        let router = APIRouter.fetchDayServices(isPaginate: 10, infoServiceId: hospitalId)
        apiClient.fetchData(from: router.url, as: DayServiceListResponse.self)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] response in
                guard let items = response.data, !items.isEmpty else { return }
                let services = items.map { item in
                    OneDayService(
                        id: item.id,
                        price: nil,
                        from: nil,
                        to: nil,
                        dayService: DayService(
                            id: item.id,
                            nameEn: item.nameEn,
                            nameAr: item.nameAr,
                            descriptionEn: item.descriptionEn,
                            descriptionAr: item.descriptionAr,
                            image: item.image,
                            backgroundImage: item.backgroundImage,
                            address: item.address,
                            lat: item.lat,
                            long: item.long
                        )
                    )
                }
                self?.hospitalData?.oneDayServices = services
            }
            .store(in: &cancellables)
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

