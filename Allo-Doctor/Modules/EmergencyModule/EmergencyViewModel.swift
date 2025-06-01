//
//  EmergencyViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/12/2024.
//

import Foundation
import UIKit


class EmergencyViewModel: ObservableObject {
    var coordinator: HomeCoordinatorContact?
    var nameSubject = CurrentValueSubject<String, Never>("")
    var numberSubject = CurrentValueSubject<String, Never>("")
    var districtId = CurrentValueSubject<Int, Never>(0)
    var cancellables = Set<AnyCancellable>()
    
    @Published var cities: [City] = []
    @Published var errorMessage: String?
    @Published var bookingStatus: BookingStatus? // New published property
    
    private let apiClient: APIClient
    
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }
}

extension EmergencyViewModel {
    func createBooking() {
        let emergencyRequest = Emergencgy(
            name: nameSubject.value,
            phone: numberSubject.value,
            districtID: districtId.value,
            acceptTerms: 1,
            isME: 1,
            patientName: nameSubject.value,
            patientNumber: numberSubject.value
        )
        emergencyBooking(request: emergencyRequest)
    }
    
    func emergencyBooking(request: Emergencgy) {
        let router = APIRouter.bookEmergency(request)
        apiClient.postData(to: router.url, body: request, as: EmergencgyResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Booking failed: \(error.localizedDescription)"
                    self.bookingStatus = .failure
                }
            }, receiveValue: { response in
                print("Registration Response: \(response)")
                self.bookingStatus = .success
            })
            .store(in: &cancellables)
    }
}

extension EmergencyViewModel {
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
}
extension EmergencyViewModel {
    func navToHome(){
        coordinator?.navigateToRoot()
    }
    func navBack(){
        coordinator?.navigateBack()
    }
    func  dissmissToHome(vc:UIViewController) {
        coordinator?.dismissPresnetiontabBarNav(vc)
    }
}
