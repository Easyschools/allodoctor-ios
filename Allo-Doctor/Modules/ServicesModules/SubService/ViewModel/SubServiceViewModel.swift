//
//  SubServiceViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 16/09/2024.
//

import Foundation

struct HospitalByIdResponse: Codable {
    let data: HospitalInfoService
}

class SubServiceViewModel{
    @Published var subServices: [SubService] = []
    @Published var banners: [Banner]?
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    private var apiClient = APIClient()
    var coordinator: HomeCoordinatorContact?
    var infoServiceId: Int?
    init(coordinator: HomeCoordinatorContact? = nil,apiClient: APIClient = APIClient(), infoServiceId: Int? = nil) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.infoServiceId = infoServiceId
    }

}
extension SubServiceViewModel{
    func fetchSubServices() {
        let router = APIRouter.fetchSubServices(isPaginate: 15)
        
        apiClient.fetchData(from: router.url, as: SubServiceResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                   break
                case .failure(let error):
                  self.errorMessage = "Failed to fetch Services: \(error.localizedDescription)"
                }
            }, receiveValue: { subServiceResponse in
                self.subServices = subServiceResponse.data
                print(subServiceResponse.data)
            })
            .store(in: &cancellables)
        
    }
    func navToSearchScreen() {
        coordinator?.showSearchScreen(serviceId: nil)
    }
    func showHospitalSearch(){
        coordinator?.showHospitalSearch()
    }
    func showEmergency(){
        coordinator?.showEmergency()
    }
    func showChat(){
        coordinator?.showChatViewController(chatType: .customerServiceType)
    }
    func fetchHospitalAndShowSpecialties(hospitalId: Int) {
        let router = APIRouter.fetchHospitalById(hospitalId: hospitalId)
        apiClient.fetchData(from: router.url, as: HospitalByIdResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to fetch hospital: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                self?.coordinator?.showHospitalSpecialties(hospital: response.data)
            })
            .store(in: &cancellables)
    }
    func fetchBanners() {
        let router = APIRouter.fetchOffers(offerType: "doctor")
        apiClient.fetchData(from: router.url, as: BannerResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] response in
                      self?.banners = response.data ?? []
                  })
            .store(in: &cancellables)
    }
    func navBack() {
        coordinator?.navigateBack()
    }
}

